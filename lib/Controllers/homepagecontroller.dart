import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../Constants/metro_stations.dart';

List<String> metroLine1Stations = [];
List<String> metroLine2Stations = [];
List<String> metroLine3Branch1Stations = [];
List<String> metroLine3Branch2Stations = [];
List<String> lrtMainStations = [];
List<String> lrtNacBranchStations = [];
List<String> lrt10thBranchStations = [];

class HomepageController extends GetxController {
  RxString depStation = "".obs;
  RxString arrStation = "".obs;
  RxString depStationSelection = "".obs;
  RxString arrStationSelection = "".obs;
  // Station indices in allMetroStations — locale-independent identity
  int depStationIndex = -1;
  int arrStationIndex = -1;
  RxBool destinationButtonFlag = false.obs;
  RxBool nearestRouteButtonFlag = false.obs;
  final RxString userDestination = "".obs;
  late Position departureLocation;
  late Position userLocation;
  late Position arrivalLocation;
  late Position destinationLocation;
  late double? screenWidth;
  late double? screenHeight;
  TextEditingController destinationController = TextEditingController();
  final FocusNode destinationFocusNode = FocusNode();
  List<String> allMetroStations = [];

  Color primaryColor = Color(0xFF008F8F);
  Color firstLineColor = Color(0xFFAD1F52);
  Color secondLineColor = Color(0xFFAD1F52);
  Color thirdLineColor = Color(0xFFAD1F52);
  static const String _searchLogTag = '[AddressSearch]';

  Future<void> getMetroStationsLists(BuildContext context) async {
    // Adding station info for departure and arrival stations
    metroLine1Stations = getMetroLine1Stations(context);
    metroLine2Stations = getMetroLine2Stations(
        context); // Assuming you have a similar function for Line 2
    metroLine3Branch1Stations =
        getMetroLine3Branch1Stations(context); // And for Branch 1
    metroLine3Branch2Stations =
        getMetroLine3Branch2Stations(context); // And for Branch 2
    lrtMainStations = getLrtMainStations(context);
    lrtNacBranchStations = getLrtNacBranchStations(context);
    lrt10thBranchStations = getLrt10thBranchStations(context);
  }

  Future<void> updateArrivalLocation(BuildContext context) async {
    await updateArrivalFromInput(context, destinationController.text);
  }

  Future<bool> updateArrivalFromInput(
      BuildContext context, String rawInput) async {
    final input = rawInput.trim();
    print('$_searchLogTag raw input="$rawInput"');
    print('$_searchLogTag normalized input="$input"');
    if (input.isEmpty) {
      print('$_searchLogTag input is empty -> abort');
      destinationButtonFlag.value = false;
      return false;
    }

    try {
      destinationController.text = input;
      Position? resolvedPosition;
      final coords = _extractLatLng(input);
      print('$_searchLogTag parsed direct coords=${coords ?? "none"}');

      if (coords != null) {
        resolvedPosition = Position(
          latitude: coords[0],
          longitude: coords[1],
          timestamp: DateTime.now(),
          altitude: 0.0,
          accuracy: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
        print(
            '$_searchLogTag using parsed coords lat=${resolvedPosition.latitude}, lng=${resolvedPosition.longitude}');
      }

      if (resolvedPosition == null) {
        print('$_searchLogTag trying device geocoder...');
        resolvedPosition = await _geocodeWithDevice(input);
        print(
            '$_searchLogTag device geocoder result=${resolvedPosition == null ? "null" : "${resolvedPosition.latitude},${resolvedPosition.longitude}"}');
      }

      if (resolvedPosition == null) {
        print('$_searchLogTag trying nominatim geocoder...');
        resolvedPosition = await _geocodeWithNominatim(input);
        print(
            '$_searchLogTag nominatim result=${resolvedPosition == null ? "null" : "${resolvedPosition.latitude},${resolvedPosition.longitude}"}');
      }

      if (resolvedPosition == null) {
        // Try extracting human-readable "q=" text from maps URL, then geocode it.
        final uri = _tryParseUriLenient(input);
        final queryText =
            uri?.queryParameters['q'] ?? uri?.queryParameters['query'];
        print('$_searchLogTag url queryText=${queryText ?? "none"}');
        if (queryText != null && queryText.trim().isNotEmpty) {
          print('$_searchLogTag retry geocoding with queryText="$queryText"');
          resolvedPosition = await _geocodeWithDevice(queryText.trim());
          resolvedPosition ??= await _geocodeWithNominatim(queryText.trim());
          print(
              '$_searchLogTag queryText result=${resolvedPosition == null ? "null" : "${resolvedPosition.latitude},${resolvedPosition.longitude}"}');
        }
      }

      if (resolvedPosition == null) {
        print('$_searchLogTag all geocoding attempts failed');
        destinationButtonFlag.value = false;
        return false;
      }

      destinationLocation = resolvedPosition;
      print(
          '$_searchLogTag resolved final position lat=${resolvedPosition.latitude}, lng=${resolvedPosition.longitude}');
      return await updateArrivalFromPosition(context, resolvedPosition);
    } catch (e) {
      print('$_searchLogTag EXCEPTION in updateArrivalFromInput: $e');
      destinationButtonFlag.value = false;
      return false;
    }
  }

  Future<bool> updateArrivalFromPosition(
      BuildContext context, Position position) async {
    try {
      print(
          '$_searchLogTag updateArrivalFromPosition lat=${position.latitude}, lng=${position.longitude}');
      destinationLocation = position;
      final nearestStationlist =
          await findNearestStation(destinationLocation, context);
      final nearestStation = nearestStationlist["Station"].toString();
      print('$_searchLogTag nearest station candidate="$nearestStation"');
      if (nearestStation.isEmpty) {
        print('$_searchLogTag nearest station empty -> fail');
        destinationButtonFlag.value = false;
        return false;
      }
      arrivalLocation = nearestStationlist["DepartureLocation"];
      arrStationSelection.value = nearestStation;
      arrStation.value = nearestStation;
      arrStationIndex = allMetroStations.indexOf(nearestStation);
      destinationButtonFlag.value = true;
      print('$_searchLogTag success -> arrStation="$nearestStation"');
      return true;
    } catch (e) {
      print('$_searchLogTag EXCEPTION in updateArrivalFromPosition: $e');
      destinationButtonFlag.value = false;
      return false;
    }
  }

  Future<Position?> _geocodeWithDevice(String input) async {
    try {
      final locations =
          await locationFromAddress(input).timeout(const Duration(seconds: 8));
      if (locations.isEmpty) return null;
      print(
          '$_searchLogTag device geocoder first result lat=${locations.first.latitude}, lng=${locations.first.longitude}');
      return locationToPosition(locations.first);
    } catch (e) {
      print('$_searchLogTag device geocoder error: $e');
      return null;
    }
  }

  Future<Position?> _geocodeWithNominatim(String input) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': input,
        'format': 'json',
        'limit': '1',
      });
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'metroappflutter/1.0 (Cairo Metro Guide)',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 8));
      print('$_searchLogTag nominatim status=${response.statusCode}');

      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      if (data is! List || data.isEmpty) return null;
      final item = data.first;
      final lat = double.tryParse(item['lat']?.toString() ?? '');
      final lng = double.tryParse(item['lon']?.toString() ?? '');
      if (lat == null || lng == null) return null;
      print('$_searchLogTag nominatim parsed lat=$lat, lng=$lng');

      return Position(
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
    } catch (e) {
      print('$_searchLogTag nominatim error: $e');
      return null;
    }
  }

  List<double>? _extractLatLng(String input) {
    final decoded = _safeDecode(input);
    final normalized = decoded.replaceAll('+', ' ');

    final atPattern = RegExp(r'@(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)');
    final directPattern = RegExp(r'(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)');

    RegExpMatch? match = atPattern.firstMatch(normalized);
    match ??= directPattern.firstMatch(normalized);

    if (match != null) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null && lat.abs() <= 90 && lng.abs() <= 180) {
        print('$_searchLogTag _extractLatLng matched lat=$lat, lng=$lng');
        return [lat, lng];
      }
    }

    final uri = _tryParseUriLenient(normalized);
    if (uri != null) {
      final q = uri.queryParameters['q'] ?? uri.queryParameters['query'];
      if (q != null && q.isNotEmpty) {
        print('$_searchLogTag _extractLatLng recursing into q="$q"');
        return _extractLatLng(q);
      }
    }

    return null;
  }

  Uri? _tryParseUriLenient(String value) {
    final direct = Uri.tryParse(value);
    if (direct != null) return direct;
    final decoded = _safeDecode(value);
    if (decoded == value) return null;
    return Uri.tryParse(decoded);
  }

  String _safeDecode(String value) {
    try {
      return Uri.decodeFull(value);
    } catch (_) {
      return value;
    }
  }

  Future<void> updateUserLocation(BuildContext context) async {
    final userLocation = await getUserLocation();
    Map<String, dynamic>? nearestStationlist =
        await findNearestStation(userLocation, context);
    String nearestStation = nearestStationlist["Station"].toString();
    departureLocation = nearestStationlist["DepartureLocation"];
    depStationSelection.value = nearestStation;
    nearestRouteButtonFlag.value = nearestStation.isNotEmpty;
    depStation.value = depStationSelection.value;
    depStationIndex = allMetroStations.indexOf(nearestStation);
  }

  Future<void> launchUrl_(Position start, Position dest) async {
    final Uri _url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&origin=${start.latitude},${start.longitude}&destination=${dest.latitude},${dest.longitude}&travelmode=driving");

    try {
      // Attempt to launch the URL
      await launchUrl(_url);
    } catch (e) {
      // Handle any exceptions that occur
      print('Error: $e');
      // You might want to show a message to the user or handle it in another way
    }
  }

  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied.');
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print("Error getting location: $e");
      return Future.error('Error getting location');
    }
  }

  Future<Map<String, dynamic>> findNearestStation(
      Position location, BuildContext context) async {
    try {
      // Calculate distances for each metro line
      List<double> metroLine1StationsDistance = metroLine1StationsCoordinates
          .map((coord) => Geolocator.distanceBetween(
                location.latitude,
                location.longitude,
                coord[0],
                coord[1],
              ))
          .toList();

      List<double> metroLine2StationsDistance = metroLine2StationsCoordinates
          .map((coord) => Geolocator.distanceBetween(
                location.latitude,
                location.longitude,
                coord[0],
                coord[1],
              ))
          .toList();

      List<double> metroLine3Branch1StationsDistance =
          metroLine3Branch1StationsCoordinates
              .map((coord) => Geolocator.distanceBetween(
                    location.latitude,
                    location.longitude,
                    coord[0],
                    coord[1],
                  ))
              .toList();

      List<double> metroLine3Branch2StationsDistance =
          metroLine3Branch2StationsCoordinates
              .map((coord) => Geolocator.distanceBetween(
                    location.latitude,
                    location.longitude,
                    coord[0],
                    coord[1],
                  ))
              .toList();

      List<double> lrtMainStationsDistance = lrtMainStationsCoordinates
          .map((coord) => Geolocator.distanceBetween(
                location.latitude,
                location.longitude,
                coord[0],
                coord[1],
              ))
          .toList();

      List<double> lrtNacBranchStationsDistance =
          lrtNacBranchStationsCoordinates
              .map((coord) => Geolocator.distanceBetween(
                    location.latitude,
                    location.longitude,
                    coord[0],
                    coord[1],
                  ))
              .toList();

      List<double> lrt10thBranchStationsDistance =
          lrt10thBranchStationsCoordinates
              .map((coord) => Geolocator.distanceBetween(
                    location.latitude,
                    location.longitude,
                    coord[0],
                    coord[1],
                  ))
              .toList();

      // Find minimum distances for each metro line
      List<double> minDistance = [
        metroLine1StationsDistance.reduce((a, b) => a < b ? a : b),
        metroLine2StationsDistance.reduce((a, b) => a < b ? a : b),
        metroLine3Branch1StationsDistance.reduce((a, b) => a < b ? a : b),
        metroLine3Branch2StationsDistance.reduce((a, b) => a < b ? a : b),
        lrtMainStationsDistance.reduce((a, b) => a < b ? a : b),
        lrtNacBranchStationsDistance.reduce((a, b) => a < b ? a : b),
        lrt10thBranchStationsDistance.reduce((a, b) => a < b ? a : b),
      ];

      int indexMin =
          minDistance.indexOf(minDistance.reduce((a, b) => a < b ? a : b));

      String station;
      List<double> depLocationCoordinates;

      switch (indexMin) {
        case 0:
          station = metroLine1Stations[
              metroLine1StationsDistance.indexOf(minDistance[0])];
          depLocationCoordinates = metroLine1StationsCoordinates[
              metroLine1StationsDistance.indexOf(minDistance[0])];
          break;
        case 1:
          station = metroLine2Stations[
              metroLine2StationsDistance.indexOf(minDistance[1])];
          depLocationCoordinates = metroLine2StationsCoordinates[
              metroLine2StationsDistance.indexOf(minDistance[1])];
          break;
        case 2:
          station = metroLine3Branch1Stations[
              metroLine3Branch1StationsDistance.indexOf(minDistance[2])];
          depLocationCoordinates = metroLine3Branch1StationsCoordinates[
              metroLine3Branch1StationsDistance.indexOf(minDistance[2])];
          break;
        case 3:
          station = metroLine3Branch2Stations[
              metroLine3Branch2StationsDistance.indexOf(minDistance[3])];
          depLocationCoordinates = metroLine3Branch2StationsCoordinates[
              metroLine3Branch2StationsDistance.indexOf(minDistance[3])];
          break;
        case 4:
          station =
              lrtMainStations[lrtMainStationsDistance.indexOf(minDistance[4])];
          depLocationCoordinates = lrtMainStationsCoordinates[
              lrtMainStationsDistance.indexOf(minDistance[4])];
          break;
        case 5:
          station = lrtNacBranchStations[
              lrtNacBranchStationsDistance.indexOf(minDistance[5])];
          depLocationCoordinates = lrtNacBranchStationsCoordinates[
              lrtNacBranchStationsDistance.indexOf(minDistance[5])];
          break;
        case 6:
          station = lrt10thBranchStations[
              lrt10thBranchStationsDistance.indexOf(minDistance[6])];
          depLocationCoordinates = lrt10thBranchStationsCoordinates[
              lrt10thBranchStationsDistance.indexOf(minDistance[6])];
          break;
        default:
          return {
            "Station": "",
            "DepartureLocation": [0, 0]
          };
      }

      Position depLocation = Position(
        latitude: depLocationCoordinates[0],
        longitude: depLocationCoordinates[1],
        timestamp: DateTime.now(),
        altitude: 0.0,
        accuracy: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      return {"Station": station, "DepartureLocation": depLocation};
    } catch (e) {
      print("Error finding nearest station: $e");
      return {
        "Station": "",
        "DepartureLocation": [0, 0]
      };
    }
  }

  Position locationToPosition(Location location) {
    return Position(
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
  }
}
