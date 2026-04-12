import 'dart:collection';

import '../domain/entities/metro_line.dart';
import '../domain/entities/route_result.dart';
import '../domain/entities/station.dart';
import 'fare_calculator.dart';
import 'metro_graph.dart';

/// Configuration for route-finding behaviour.
class RoutingPreferences {
  /// Extra penalty (seconds) added to each transfer when [minimizeTransfers] is true.
  static const int _transferPenaltySecs = 600; // 10 extra min per transfer

  /// Extra penalty (seconds) for non-accessible transfer stations.
  static const int _inaccessiblePenaltySecs = 1200; // 20 extra min

  /// Extra penalty (seconds) applied when transferring at one of these stations.
  /// Used to generate "miss-your-transfer" alternate routes.
  static const int _avoidTransferPenaltySecs = 3600; // 60 min — effectively forces a detour

  final bool minimizeTransfers;
  final bool preferAccessible;

  /// Station IDs at which transfer edges should receive a heavy penalty,
  /// steering Dijkstra toward a path that avoids those transfer points.
  final Set<String> avoidTransferStationIds;

  const RoutingPreferences({
    this.minimizeTransfers = false,
    this.preferAccessible = false,
    this.avoidTransferStationIds = const {},
  });
}

/// Dijkstra-based single-source shortest path engine for the Cairo Metro graph.
///
/// Complexity: O((V + E) log V) using a priority queue.
class DijkstraEngine {
  final MetroGraph graph;
  final Map<String, Station> stations;
  final Map<String, MetroLine> lines;

  const DijkstraEngine({
    required this.graph,
    required this.stations,
    required this.lines,
  });

  // ──────────────────────────────────────────────────────────
  // Public API
  // ──────────────────────────────────────────────────────────

  /// Returns up to [maxResults] routes sorted by total travel time.
  ///
  /// When [preferAccessible] is true, the primary (first) route avoids
  /// non-accessible transfer stations.  When [minimizeTransfers] is true,
  /// the primary route uses fewer transfers.
  ///
  /// The engine always generates diverse alternatives (fastest, fewest
  /// transfers, accessible) so the user sees multiple options.
  List<RouteResult> findTopRoutes(
    String fromId,
    String toId, {
    int maxResults = 3,
    bool preferAccessible = false,
    bool minimizeTransfers = false,
  }) {
    if (fromId == toId) return [];
    if (!graph.contains(fromId) || !graph.contains(toId)) return [];

    // Rule: if both stations are on the same line, only the direct route is
    // meaningful — skip Dijkstra entirely and slice the line's station list.
    // (Dijkstra cannot be used here because transfer edges are self-loops that
    //  are never re-relaxed, so the transfer penalty never applies and Dijkstra
    //  freely switches lines at shared stations, giving nonsensical shortcuts.)
    final directRoute = _directRouteOnSharedLine(fromId, toId);
    if (directRoute != null) {
      return [directRoute.copyWith(sortType: RouteSortType.fastest)];
    }

    final results = <RouteResult>[];

    // Build the primary preferences from caller flags.
    final primary = RoutingPreferences(
      minimizeTransfers: minimizeTransfers,
      preferAccessible: preferAccessible,
    );

    // Determine the sortType label for the primary route.
    final RouteSortType primaryLabel;
    if (preferAccessible) {
      primaryLabel = RouteSortType.accessible;
    } else if (minimizeTransfers) {
      primaryLabel = RouteSortType.fewestTransfers;
    } else {
      primaryLabel = RouteSortType.fastest;
    }

    // Route 1: Caller-preferred (default: pure fastest)
    final best = _dijkstra(fromId, toId, primary);
    if (best != null) {
      results.add(best.copyWith(sortType: primaryLabel));
    }

    // Route 2: Fewest transfers (skip if already the primary preference)
    if (!minimizeTransfers && results.length < maxResults) {
      final fewest = _dijkstra(
        fromId, toId,
        const RoutingPreferences(minimizeTransfers: true),
      );
      if (fewest != null && !_sameRoute(fewest, results)) {
        results.add(fewest.copyWith(sortType: RouteSortType.fewestTransfers));
      }
    }

    // Route 3: Accessible preference (skip if already the primary preference)
    if (!preferAccessible && results.length < maxResults) {
      final accessible = _dijkstra(
        fromId, toId,
        const RoutingPreferences(preferAccessible: true),
      );
      if (accessible != null && !_sameRoute(accessible, results)) {
        results.add(accessible.copyWith(sortType: RouteSortType.accessible));
      }
    }

    // Route 4: Pure fastest fallback (if we haven't hit maxResults yet
    // and the primary wasn't already fastest)
    if (primaryLabel != RouteSortType.fastest && results.length < maxResults) {
      final fastest = _dijkstra(fromId, toId, const RoutingPreferences());
      if (fastest != null && !_sameRoute(fastest, results)) {
        results.add(fastest.copyWith(sortType: RouteSortType.fastest));
      }
    }

    // Route 5: "Miss your transfer" alternative.
    // Take the primary route's transfer stations and heavily penalise them so
    // Dijkstra is forced to find a path through different transfer points.
    if (results.length < maxResults && results.isNotEmpty) {
      final primaryTransfers = results.first.transferStationIds.toSet();
      if (primaryTransfers.isNotEmpty) {
        final alt = _dijkstra(
          fromId,
          toId,
          RoutingPreferences(avoidTransferStationIds: primaryTransfers),
        );
        if (alt != null && !_sameRoute(alt, results)) {
          results.add(alt.copyWith(sortType: RouteSortType.alternativeRoute));
        }
      }
    }

    return results.take(maxResults).toList();
  }

  // ──────────────────────────────────────────────────────────
  // Core Dijkstra
  // ──────────────────────────────────────────────────────────

  RouteResult? _dijkstra(
    String start,
    String end,
    RoutingPreferences prefs,
  ) {
    // dist[stationId] = minimum cost (seconds) to reach stationId
    final dist = <String, int>{};
    // prev[stationId] = (_DijkstraNode) that leads to the shortest path
    final prev = <String, _DijkstraNode>{};

    for (final id in graph.allStationIds) {
      dist[id] = _infinity;
    }
    dist[start] = 0;

    // Priority queue ordered by accumulated cost (min-heap simulation via SplayTreeMap)
    final pq = SplayTreeMap<int, Queue<String>>();
    _enqueue(pq, 0, start);

    while (pq.isNotEmpty) {
      final currentCost = pq.firstKey()!;
      final queue = pq[currentCost]!;
      final current = queue.removeFirst();
      if (queue.isEmpty) pq.remove(currentCost);

      if (current == end) break;
      if (currentCost > (dist[current] ?? _infinity)) continue;

      for (final edge in graph.neighbors(current)) {
        int edgeCost = edge.weightSeconds;

        // Apply preference penalties
        if (edge.isTransfer) {
          if (prefs.minimizeTransfers) {
            edgeCost += RoutingPreferences._transferPenaltySecs;
          }
          if (prefs.preferAccessible) {
            final station = stations[edge.toStationId];
            if (station != null && !station.isAccessible) {
              edgeCost += RoutingPreferences._inaccessiblePenaltySecs;
            }
          }
        }
        // NOTE: avoidTransferStationIds penalty is intentionally outside
        // the isTransfer block. Transfer edges in this graph are self-loops
        // (toStationId == fromStationId) which Dijkstra never re-relaxes,
        // so they cannot carry effective penalties. Penalising ALL edges that
        // enter the avoided station forces Dijkstra to route around it entirely.
        if (prefs.avoidTransferStationIds.isNotEmpty &&
            prefs.avoidTransferStationIds.contains(edge.toStationId)) {
          edgeCost += RoutingPreferences._avoidTransferPenaltySecs;
        }

        final newCost = currentCost + edgeCost;
        if (newCost < (dist[edge.toStationId] ?? _infinity)) {
          dist[edge.toStationId] = newCost;
          prev[edge.toStationId] = _DijkstraNode(
            stationId: current,
            lineId: edge.lineId,
            isTransfer: edge.isTransfer,
          );
          _enqueue(pq, newCost, edge.toStationId);
        }
      }
    }

    if ((dist[end] ?? _infinity) == _infinity) return null;
    return _reconstructPath(start, end, prev, dist[end]!);
  }

  // ──────────────────────────────────────────────────────────
  // Path reconstruction
  // ──────────────────────────────────────────────────────────

  RouteResult _reconstructPath(
    String start,
    String end,
    Map<String, _DijkstraNode> prev,
    int totalCostSeconds,
  ) {
    // Walk backward from end → start
    final reversedPath = <String>[];
    final reversedLineIds = <String>[];
    var current = end;

    while (current != start) {
      reversedPath.add(current);
      final node = prev[current]!;
      reversedLineIds.add(node.lineId);
      current = node.stationId;
    }
    reversedPath.add(start);

    final stationPath = reversedPath.reversed.toList();
    final lineIdPath = reversedLineIds.reversed.toList();

    // Build segments (contiguous runs on the same line)
    final segments = <RouteSegment>[];
    if (stationPath.length > 1) {
      var segStart = 0;
      var segLine = lineIdPath[0];

      for (int i = 1; i < lineIdPath.length; i++) {
        if (lineIdPath[i] != segLine) {
          segments.add(_buildSegment(stationPath, segStart, i, segLine));
          segStart = i;
          segLine = lineIdPath[i];
        }
      }
      // Final segment
      segments.add(_buildSegment(stationPath, segStart, lineIdPath.length, segLine));
    }

    // Filter out zero-length transfer pseudo-segments
    final realSegments = segments
        .where((s) => !_isTransferPseudoSegment(s))
        .toList();

    final totalHops = stationPath.length - 1;
    final transfers = realSegments.isEmpty ? 0 : realSegments.length - 1;
    final fare = FareCalculator.calculate(totalHops);

    return RouteResult(
      stationIds: stationPath,
      segments: realSegments,
      totalStations: totalHops,
      transfers: transfers,
      estimatedTime: Duration(seconds: totalCostSeconds),
      fareEGP: fare,
    );
  }

  RouteSegment _buildSegment(
    List<String> path,
    int fromIdx,
    int toIdx,
    String lineId,
  ) {
    final segStations = path.sublist(fromIdx, toIdx + 1);
    return RouteSegment(
      lineId: lineId,
      fromStationId: segStations.first,
      toStationId: segStations.last,
      stationIds: segStations,
    );
  }

  bool _isTransferPseudoSegment(RouteSegment s) =>
      s.fromStationId == s.toStationId;

  // ──────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────

  static const int _infinity = 2147483647;

  void _enqueue(SplayTreeMap<int, Queue<String>> pq, int cost, String id) {
    pq.putIfAbsent(cost, () => Queue<String>()).add(id);
  }

  /// If [fromId] and [toId] are both on the same line, returns a [RouteResult]
  /// built by slicing that line's station list — no Dijkstra involved.
  /// Returns null when the two stations require at least one transfer.
  RouteResult? _directRouteOnSharedLine(String fromId, String toId) {
    for (final line in lines.values) {
      final fromIdx = line.stationIds.indexOf(fromId);
      final toIdx = line.stationIds.indexOf(toId);
      if (fromIdx == -1 || toIdx == -1) continue;

      // Ordered sublist: handle both directions of travel.
      final List<String> path;
      if (fromIdx <= toIdx) {
        path = line.stationIds.sublist(fromIdx, toIdx + 1);
      } else {
        path = line.stationIds.sublist(toIdx, fromIdx + 1).reversed.toList();
      }

      // Sum actual edge weights from the graph.
      int totalSeconds = 0;
      for (int i = 0; i < path.length - 1; i++) {
        final edge = graph.neighbors(path[i]).firstWhere(
          (e) => e.toStationId == path[i + 1] && e.lineId == line.id,
          orElse: () => MetroEdge(
            toStationId: path[i + 1],
            lineId: line.id,
            weightSeconds: 120,
          ),
        );
        totalSeconds += edge.weightSeconds;
      }

      final hops = path.length - 1;
      final segment = RouteSegment(
        lineId: line.id,
        fromStationId: fromId,
        toStationId: toId,
        stationIds: path,
      );

      return RouteResult(
        stationIds: path,
        segments: [segment],
        totalStations: hops,
        transfers: 0,
        estimatedTime: Duration(seconds: totalSeconds),
        fareEGP: FareCalculator.calculate(hops),
      );
    }
    return null; // no shared line — transfer required
  }

  bool _sameRoute(RouteResult candidate, List<RouteResult> existing) {
    return existing.any((r) {
      if (r.originStationId != candidate.originStationId) return false;
      if (r.destinationStationId != candidate.destinationStationId) return false;
      // Two routes are the same only if they transfer at exactly the same stations.
      // This allows routes like "transfer at Sadat" vs "transfer at El Shohadaa"
      // to both appear even if the hop count is equal.
      final rT = r.transferStationIds;
      final cT = candidate.transferStationIds;
      if (rT.length != cT.length) return false;
      for (int i = 0; i < rT.length; i++) {
        if (rT[i] != cT[i]) return false;
      }
      return true;
    });
  }
}

/// Internal node used during path reconstruction.
class _DijkstraNode {
  final String stationId;
  final String lineId;
  final bool isTransfer;

  const _DijkstraNode({
    required this.stationId,
    required this.lineId,
    required this.isTransfer,
  });
}

// Extension to add copyWith to RouteResult (keeps entity immutable)
extension RouteResultX on RouteResult {
  RouteResult copyWith({RouteSortType? sortType}) => RouteResult(
        stationIds: stationIds,
        segments: segments,
        totalStations: totalStations,
        transfers: transfers,
        estimatedTime: estimatedTime,
        fareEGP: fareEGP,
        sortType: sortType ?? this.sortType,
      );
}
