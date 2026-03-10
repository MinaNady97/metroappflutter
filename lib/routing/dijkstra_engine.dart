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

  final bool minimizeTransfers;
  final bool preferAccessible;

  const RoutingPreferences({
    this.minimizeTransfers = false,
    this.preferAccessible = false,
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
  /// Internally runs Dijkstra three times with different preference weights.
  List<RouteResult> findTopRoutes(
    String fromId,
    String toId, {
    int maxResults = 3,
  }) {
    if (fromId == toId) return [];
    if (!graph.contains(fromId) || !graph.contains(toId)) return [];

    final results = <RouteResult>[];

    // Route 1: Pure fastest (time-optimal)
    final fastest = _dijkstra(fromId, toId, const RoutingPreferences());
    if (fastest != null) results.add(fastest);

    // Route 2: Fewest transfers (transfer-penalty boosted)
    final fewest = _dijkstra(
      fromId,
      toId,
      const RoutingPreferences(minimizeTransfers: true),
    );
    if (fewest != null && !_sameRoute(fewest, results)) {
      results.add(fewest.copyWith(sortType: RouteSortType.fewestTransfers));
    }

    // Route 3: Accessible preference
    if (results.length < maxResults) {
      final accessible = _dijkstra(
        fromId,
        toId,
        const RoutingPreferences(preferAccessible: true),
      );
      if (accessible != null && !_sameRoute(accessible, results)) {
        results.add(accessible.copyWith(sortType: RouteSortType.accessible));
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

  bool _sameRoute(RouteResult candidate, List<RouteResult> existing) {
    return existing.any((r) =>
        r.stationIds.length == candidate.stationIds.length &&
        r.originStationId == candidate.originStationId &&
        r.destinationStationId == candidate.destinationStationId &&
        r.transfers == candidate.transfers);
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
