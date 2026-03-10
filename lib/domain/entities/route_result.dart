import 'package:flutter/foundation.dart';

/// A single continuous segment on one metro line between two stations.
@immutable
class RouteSegment {
  final String lineId;
  final String fromStationId;
  final String toStationId;
  final List<String> stationIds; // All stations including from & to
  final int stationCount;

  const RouteSegment({
    required this.lineId,
    required this.fromStationId,
    required this.toStationId,
    required this.stationIds,
  }) : stationCount = stationIds.length - 1;
}

/// A complete route result from origin to destination.
@immutable
class RouteResult {
  final List<String> stationIds;     // Complete ordered list of all stations
  final List<RouteSegment> segments; // One segment per line used
  final int totalStations;           // Number of station hops (not counting start)
  final int transfers;               // Number of line changes
  final Duration estimatedTime;
  final int fareEGP;
  final RouteSortType sortType;

  const RouteResult({
    required this.stationIds,
    required this.segments,
    required this.totalStations,
    required this.transfers,
    required this.estimatedTime,
    required this.fareEGP,
    this.sortType = RouteSortType.fastest,
  });

  /// Transfer station IDs (the station where a line change happens)
  List<String> get transferStationIds => segments.length > 1
      ? segments
          .take(segments.length - 1)
          .map((s) => s.toStationId)
          .toList()
      : [];

  String get originStationId => stationIds.first;
  String get destinationStationId => stationIds.last;

  @override
  String toString() =>
      'RouteResult($totalStations stations, $transfers transfers, ${estimatedTime.inMinutes}min, $fareEGP EGP)';
}

enum RouteSortType {
  fastest,
  fewestTransfers,
  accessible,
}
