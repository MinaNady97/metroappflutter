import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/repositories/metro_repository.dart';
import '../domain/entities/station.dart';
import 'package:get/get.dart';

/// Pure GPS + navigation service.
/// Handles permission checks, current position, and Maps deep-links.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Request permission and return the current GPS [Position].
  /// Throws a [String] error message on failure.
  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return Geolocator.getCurrentPosition();
  }

  /// Find the nearest [Station] to [latitude]/[longitude] using
  /// the routing graph in [MetroRepository].
  Future<Station?> findNearestStation(double latitude, double longitude) async {
    try {
      final repo = Get.find<MetroRepository>();
      return repo.findNearestStation(latitude, longitude);
    } catch (e) {
      return null;
    }
  }

  /// Open Google Maps driving directions from [start] to [dest].
  Future<void> launchMapsDirections(Position start, Position dest) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${start.latitude},${start.longitude}'
      '&destination=${dest.latitude},${dest.longitude}'
      '&travelmode=driving',
    );
    try {
      await launchUrl(uri);
    } catch (e) {
      // Non-fatal
    }
  }

  /// Convert a [Location] (from geocoding package) to a [Position].
  Position locationToPosition(Location location) => Position(
        latitude: location.latitude,
        longitude: location.longitude,
        timestamp: DateTime.now(),
        altitude: 0.0,
        accuracy: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

  /// Create a minimal [Position] from raw coordinates.
  Position makePosition(double lat, double lng) => Position(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
        altitude: 0.0,
        accuracy: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
}
