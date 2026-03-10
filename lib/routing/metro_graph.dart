import '../domain/entities/metro_line.dart';
import '../domain/entities/station.dart';

/// Directed weighted edge in the metro graph.
class MetroEdge {
  /// Destination station ID.
  final String toStationId;

  /// The line this edge belongs to.
  final String lineId;

  /// Travel time in seconds (used as edge weight in Dijkstra).
  final int weightSeconds;

  /// True for pseudo-edges that represent transferring between lines
  /// at the same physical station.
  final bool isTransfer;

  const MetroEdge({
    required this.toStationId,
    required this.lineId,
    required this.weightSeconds,
    this.isTransfer = false,
  });
}

/// Bidirectional adjacency-list graph of the Cairo Metro network.
///
/// Nodes  = station IDs (stable, locale-independent strings).
/// Edges  = travel connections between adjacent stations on a line,
///          plus zero-distance transfer edges between lines at shared stations.
class MetroGraph {
  static const int _avgTravelSeconds = 120; // ~2 min between adjacent stations
  static const int _transferSeconds = 300;  // 5 min platform change penalty

  final Map<String, List<MetroEdge>> _adj = {};

  /// Builds the graph from [lines] and [stations].
  /// Call once at startup; the resulting graph is read-only.
  void build(List<MetroLine> lines, Map<String, Station> stationMap) {
    _adj.clear();

    // Step 1: Create travel edges between adjacent stations on each line.
    for (final line in lines) {
      final ids = line.stationIds;
      for (int i = 0; i < ids.length - 1; i++) {
        final a = ids[i];
        final b = ids[i + 1];
        final weight = _edgeWeight(stationMap[a], stationMap[b]);

        _addEdge(a, MetroEdge(
          toStationId: b,
          lineId: line.id,
          weightSeconds: weight,
        ));
        _addEdge(b, MetroEdge(
          toStationId: a,
          lineId: line.id,
          weightSeconds: weight,
        ));
      }
    }

    // Step 2: Create transfer edges at stations served by multiple lines.
    final stationLines = <String, Set<String>>{};
    for (final line in lines) {
      for (final stationId in line.stationIds) {
        stationLines.putIfAbsent(stationId, () => {}).add(line.id);
      }
    }

    for (final entry in stationLines.entries) {
      if (entry.value.length < 2) continue;
      final lineList = entry.value.toList();
      for (int i = 0; i < lineList.length; i++) {
        for (int j = i + 1; j < lineList.length; j++) {
          // Bidirectional transfer edge (same station, different line context)
          _addEdge(entry.key, MetroEdge(
            toStationId: entry.key, // stays at same station
            lineId: lineList[j],
            weightSeconds: _transferSeconds,
            isTransfer: true,
          ));
          _addEdge(entry.key, MetroEdge(
            toStationId: entry.key,
            lineId: lineList[i],
            weightSeconds: _transferSeconds,
            isTransfer: true,
          ));
        }
      }
    }
  }

  /// Returns all outgoing edges from [stationId].
  List<MetroEdge> neighbors(String stationId) => _adj[stationId] ?? const [];

  /// Whether the graph contains a node for [stationId].
  bool contains(String stationId) => _adj.containsKey(stationId);

  Set<String> get allStationIds => _adj.keys.toSet();

  void _addEdge(String from, MetroEdge edge) {
    _adj.putIfAbsent(from, () => []).add(edge);
  }

  /// Estimates travel time between two adjacent stations based on their
  /// haversine distance (faster for longer inter-station gaps on outer lines).
  int _edgeWeight(Station? a, Station? b) {
    if (a == null || b == null) return _avgTravelSeconds;
    final distKm = _haversineKm(a.latitude, a.longitude, b.latitude, b.longitude);
    // Metro averages ~35 km/h including deceleration/acceleration
    final seconds = ((distKm / 35.0) * 3600).round();
    // Clamp between 60 s and 300 s per hop
    return seconds.clamp(60, 300);
  }

  /// Haversine distance in km between two lat/lng points.
  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = _sin2(dLat / 2) +
        _cos(_rad(lat1)) * _cos(_rad(lat2)) * _sin2(dLon / 2);
    return 2 * r * _asin(_sqrt(a));
  }

  // Pure math helpers (avoid dart:math import for tree-shaking cleanliness)
  double _rad(double deg) => deg * 3.14159265358979 / 180.0;
  double _sin2(double x) => _sin(x) * _sin(x);
  double _sin(double x) {
    // Taylor series sufficient for small angles
    return x - (x * x * x) / 6.0 + (x * x * x * x * x) / 120.0;
  }
  double _cos(double x) {
    return 1.0 - (x * x) / 2.0 + (x * x * x * x) / 24.0;
  }
  double _asin(double x) => x + (x * x * x) / 6.0 + 3 * (x * x * x * x * x) / 40.0;
  double _sqrt(double x) {
    if (x <= 0) return 0;
    double z = x;
    for (int i = 0; i < 10; i++) { z = (z + x / z) / 2; }
    return z;
  }
}
