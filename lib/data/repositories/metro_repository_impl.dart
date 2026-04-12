import 'dart:math' as math;

import '../../domain/entities/metro_line.dart';
import '../../domain/entities/route_result.dart';
import '../../domain/entities/station.dart';
import '../../domain/repositories/metro_repository.dart';
import '../../routing/dijkstra_engine.dart';
import '../../routing/metro_graph.dart';
import '../datasources/metro_local_datasource.dart';

/// Concrete implementation of [MetroRepository].
/// Lazy-initialises the routing graph on first use.
class MetroRepositoryImpl implements MetroRepository {
  final MetroLocalDatasource _datasource;

  MetroRepositoryImpl({required MetroLocalDatasource datasource})
      : _datasource = datasource;

  // ── Cached network state ────────────────────────────────────
  bool _initialized = false;
  late List<Station> _stations;
  late List<MetroLine> _lines;
  late Map<String, Station> _stationMap;    // id → Station  (O(1) lookup)
  late Map<String, MetroLine> _lineMap;     // id → MetroLine
  late MetroGraph _graph;
  late DijkstraEngine _engine;

  // ── Initialisation ──────────────────────────────────────────
  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    _stations = await _datasource.loadStations();
    _lines = await _datasource.loadLines();

    _stationMap = {for (final s in _stations) s.id: s};
    _lineMap = {for (final l in _lines) l.id: l};

    _graph = MetroGraph();
    _graph.build(_lines, _stationMap);

    _engine = DijkstraEngine(
      graph: _graph,
      stations: _stationMap,
      lines: _lineMap,
    );

    _initialized = true;
  }

  // ── MetroRepository ─────────────────────────────────────────
  @override
  Future<List<Station>> getAllStations() async {
    await _ensureInitialized();
    return List.unmodifiable(_stations);
  }

  @override
  Future<List<MetroLine>> getAllLines() async {
    await _ensureInitialized();
    return List.unmodifiable(_lines);
  }

  @override
  Future<Station?> getStationById(String id) async {
    await _ensureInitialized();
    return _stationMap[id];
  }

  @override
  Future<Station?> findNearestStation(double latitude, double longitude) async {
    await _ensureInitialized();
    Station? nearest;
    double minDist = double.infinity;

    for (final station in _stations) {
      final d = _haversineMeters(
        latitude, longitude,
        station.latitude, station.longitude,
      );
      if (d < minDist) {
        minDist = d;
        nearest = station;
      }
    }
    return nearest;
  }

  @override
  Future<List<Station>> searchStations(String query) async {
    await _ensureInitialized();
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return [];
    return _stations
        .where((s) =>
            s.nameEn.toLowerCase().contains(q) ||
            s.nameAr.contains(q))
        .toList();
  }

  @override
  Future<List<RouteResult>> findRoutes(
    String fromStationId,
    String toStationId, {
    int maxResults = 3,
    bool minimizeTransfers = false,
    bool preferAccessible = false,
  }) async {
    await _ensureInitialized();
    return _engine.findTopRoutes(
      fromStationId,
      toStationId,
      maxResults: maxResults,
      preferAccessible: preferAccessible,
      minimizeTransfers: minimizeTransfers,
    );
  }

  // ── Utilities ───────────────────────────────────────────────

  /// Haversine distance in metres between two GPS coordinates.
  static double _haversineMeters(
      double lat1, double lon1, double lat2, double lon2) {
    const r = 6371000.0; // Earth radius in metres
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return 2 * r * math.asin(math.sqrt(a));
  }

  static double _toRad(double deg) => deg * math.pi / 180.0;
}
