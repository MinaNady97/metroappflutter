import '../entities/station.dart';
import '../entities/metro_line.dart';
import '../entities/route_result.dart';

/// Abstract contract for all metro data access.
/// No BuildContext dependency — pure business logic interface.
abstract interface class MetroRepository {
  /// Returns all stations (unordered).
  Future<List<Station>> getAllStations();

  /// Returns all metro lines with ordered station lists.
  Future<List<MetroLine>> getAllLines();

  /// Returns a station by its stable ID, or null if not found.
  Future<Station?> getStationById(String id);

  /// Finds the nearest metro station to the given GPS coordinates.
  Future<Station?> findNearestStation(double latitude, double longitude);

  /// Finds all stations whose name contains [query] (case-insensitive, both languages).
  Future<List<Station>> searchStations(String query);

  /// Returns up to [maxResults] optimal routes from [fromId] to [toId].
  Future<List<RouteResult>> findRoutes(
    String fromStationId,
    String toStationId, {
    int maxResults = 3,
    bool minimizeTransfers = false,
    bool preferAccessible = false,
  });
}
