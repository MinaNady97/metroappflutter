import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../Constants/metro_stations.dart';
import '../services/destination_resolver_service.dart';
import '../services/favorites_service.dart';
import '../services/local_search_service.dart';
import '../services/location_service.dart';

List<String> metroLine1Stations = [];
List<String> metroLine2Stations = [];
List<String> metroLine3Branch1Stations = [];
List<String> metroLine3Branch2Stations = [];
List<String> lrtMainStations = [];
List<String> lrtNacBranchStations = [];
List<String> lrt10thBranchStations = [];

/// A recent departure→arrival pair saved for quick re-use.
class RecentRoute {
  final String dep;
  final String arr;
  RecentRoute({required this.dep, required this.arr});
}

class HomepageController extends GetxController {
  // ── Station selection state ──────────────────────────────────────────────────
  RxString depStation = ''.obs;
  RxString arrStation = ''.obs;
  RxString depStationSelection = ''.obs;
  RxString arrStationSelection = ''.obs;

  /// Locale-independent index into [allMetroStations]. Used for locale sync.
  int depStationIndex = -1;
  int arrStationIndex = -1;

  RxBool destinationButtonFlag = false.obs;
  RxBool nearestRouteButtonFlag = false.obs;
  final RxBool preferAccessible = false.obs;
  final RxDouble nearestDistanceM = 0.0.obs;
  final RxBool isLocatingNearest = false.obs;

  /// The station name found via GPS — never overwritten by route chip taps.
  /// Only updated by [updateUserLocation].
  final RxString nearestStationName = ''.obs;

  final RxString userDestination = ''.obs;

  late Position departureLocation;
  late Position userLocation;
  late Position arrivalLocation;
  late Position destinationLocation;

  /// Nullable version of [destinationLocation] — non-null only after a
  /// successful destination search.  Safe to read without try/catch.
  Position? destinationLocationOrNull;

  late double? screenWidth;
  late double? screenHeight;

  // Kept for backward compat with routecard.dart / routecardtwometro.dart
  Color primaryColor = const Color(0xFF008F8F);
  Color firstLineColor = const Color(0xFFAD1F52);
  Color secondLineColor = const Color(0xFFAD1F52);
  Color thirdLineColor = const Color(0xFFAD1F52);

  TextEditingController destinationController = TextEditingController();
  final FocusNode destinationFocusNode = FocusNode();

  List<String> allMetroStations = [];

  // ── Recent routes ────────────────────────────────────────────────────────────
  final RxList<RecentRoute> recentRoutes = <RecentRoute>[].obs;
  final RxList<RecentRoute> favoriteRoutes = <RecentRoute>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadPersistedRoutes();
  }

  Future<void> _loadPersistedRoutes() async {
    final svc = FavoritesService.instance;
    final recent = await svc.loadRecent();
    final favs = await svc.loadFavorites();
    recentRoutes.value =
        recent.map((r) => RecentRoute(dep: r.dep, arr: r.arr)).toList();
    favoriteRoutes.value =
        favs.map((r) => RecentRoute(dep: r.dep, arr: r.arr)).toList();
  }

  void saveRecentRoute(String dep, String arr) {
    if (dep.isEmpty || arr.isEmpty) return;
    recentRoutes.removeWhere((r) => r.dep == dep && r.arr == arr);
    recentRoutes.insert(0, RecentRoute(dep: dep, arr: arr));
    if (recentRoutes.length > 5) recentRoutes.removeLast();
    FavoritesService.instance.saveRecent(
      recentRoutes.map((r) => (dep: r.dep, arr: r.arr)).toList(),
    );
  }

  void removeRecentRoute(String dep, String arr) {
    recentRoutes.removeWhere((r) => r.dep == dep && r.arr == arr);
    FavoritesService.instance.saveRecent(
      recentRoutes.map((r) => (dep: r.dep, arr: r.arr)).toList(),
    );
  }

  bool isFavorite(String dep, String arr) =>
      favoriteRoutes.any((r) => r.dep == dep && r.arr == arr);

  void toggleFavorite(String dep, String arr) {
    if (dep.isEmpty || arr.isEmpty) return;
    if (isFavorite(dep, arr)) {
      favoriteRoutes.removeWhere((r) => r.dep == dep && r.arr == arr);
    } else {
      favoriteRoutes.insert(0, RecentRoute(dep: dep, arr: arr));
    }
    FavoritesService.instance.saveFavorites(
      favoriteRoutes.map((r) => (dep: r.dep, arr: r.arr)).toList(),
    );
  }

  // ── Search suggestion state ──────────────────────────────────────────────────
  final RxList<LandmarkResult> didYouMeanSuggestions = <LandmarkResult>[].obs;
  final RxList<LandmarkResult> autocompleteSuggestions = <LandmarkResult>[].obs;
  final RxBool isFetchingOnlineSuggestions = false.obs;
  final RxBool isInputArabic = false.obs;

  Timer? _autocompleteDebounce;

  // ── Station data loading ─────────────────────────────────────────────────────

  Future<void> getMetroStationsLists(BuildContext context) async {
    metroLine1Stations = getMetroLine1Stations(context);
    metroLine2Stations = getMetroLine2Stations(context);
    metroLine3Branch1Stations = getMetroLine3Branch1Stations(context);
    metroLine3Branch2Stations = getMetroLine3Branch2Stations(context);
    lrtMainStations = getLrtMainStations(context);
    lrtNacBranchStations = getLrtNacBranchStations(context);
    lrt10thBranchStations = getLrt10thBranchStations(context);
  }

  Future<void> updateArrivalLocation(BuildContext context) async {
    await updateArrivalFromInput(context, destinationController.text);
  }

  // ── Autocomplete (delegates to DestinationResolverService) ──────────────────

  @override
  void onClose() {
    _autocompleteDebounce?.cancel();
    super.onClose();
  }

  void onDestinationTextChanged(String value) {
    final q = value.trim();
    _autocompleteDebounce?.cancel();

    if (q.length < 2) {
      autocompleteSuggestions.clear();
      isFetchingOnlineSuggestions.value = false;
      isInputArabic.value = false;
      return;
    }

    final arabic = LocalSearchService.isArabic(q);
    isInputArabic.value = arabic;

    // Instant local results
    autocompleteSuggestions.value =
        LocalSearchService.instance.search(q, maxResults: 5, preferArabic: arabic);

    // Debounced online results
    isFetchingOnlineSuggestions.value = true;
    _autocompleteDebounce = Timer(const Duration(milliseconds: 500), () async {
      final merged =
          await DestinationResolverService.instance.fetchAutocompleteSuggestions(
        q,
        existing: autocompleteSuggestions.toList(),
        arabic: arabic,
      );
      autocompleteSuggestions.value = merged;
      isFetchingOnlineSuggestions.value = false;
    });
  }

  // ── Destination resolution (delegates to DestinationResolverService) ─────────

  Future<bool> updateArrivalFromInput(
      BuildContext context, String rawInput) async {
    final input = rawInput.trim();
    didYouMeanSuggestions.clear();
    autocompleteSuggestions.clear();

    if (input.isEmpty) {
      destinationButtonFlag.value = false;
      return false;
    }

    try {
      destinationController.text = input;

      final resolved =
          await DestinationResolverService.instance.resolve(input);

      if (resolved == null) {
        // Populate "Did You Mean?" suggestions
        final arabic = LocalSearchService.isArabic(input);
        final suggestions =
            LocalSearchService.instance.didYouMean(input, preferArabic: arabic);
        if (suggestions.isNotEmpty) {
          didYouMeanSuggestions.value = suggestions;
        }
        destinationButtonFlag.value = false;
        return false;
      }

      destinationLocation = resolved;
      destinationLocationOrNull = resolved;
      return await updateArrivalFromPosition(context, resolved);
    } catch (e) {
      destinationButtonFlag.value = false;
      return false;
    }
  }

  Future<bool> updateArrivalFromLandmark(
      BuildContext context, LandmarkResult landmark) async {
    autocompleteSuggestions.clear();
    didYouMeanSuggestions.clear();
    destinationController.text = landmark.name;
    final pos =
        LocationService.instance.makePosition(landmark.lat, landmark.lng);
    return updateArrivalFromPosition(context, pos);
  }

  Future<bool> updateArrivalFromPosition(
      BuildContext context, Position position) async {
    try {
      destinationLocation = position;
      destinationLocationOrNull = position;
      final nearestMap =
          await _findNearestStationFromCoords(position, context);
      final nearestStation = nearestMap['Station'] as String;
      if (nearestStation.isEmpty) {
        destinationButtonFlag.value = false;
        return false;
      }
      arrivalLocation = nearestMap['DepartureLocation'] as Position;
      arrStationSelection.value = nearestStation;
      arrStation.value = nearestStation;
      arrStationIndex = allMetroStations.indexOf(nearestStation);
      destinationButtonFlag.value = true;
      return true;
    } catch (e) {
      destinationButtonFlag.value = false;
      return false;
    }
  }

  // ── User location (delegates to LocationService) ─────────────────────────────

  Future<void> updateUserLocation(BuildContext context) async {
    isLocatingNearest.value = true;
    try {
      final pos = await LocationService.instance.getUserLocation();
      final nearestMap = await _findNearestStationFromCoords(pos, context);
      final nearestStation = nearestMap['Station'] as String;
      departureLocation = nearestMap['DepartureLocation'] as Position;
      nearestStationName.value = nearestStation;
      nearestRouteButtonFlag.value = nearestStation.isNotEmpty;
      userLocation = pos;
      if (nearestStation.isNotEmpty) {
        nearestDistanceM.value = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          departureLocation.latitude,
          departureLocation.longitude,
        );
      }
    } finally {
      isLocatingNearest.value = false;
    }
  }

  Future<Position> getUserLocation() =>
      LocationService.instance.getUserLocation();

  Future<void> launchUrl_(Position start, Position dest) async {
    await LocationService.instance.launchMapsDirections(start, dest);
  }

  // ── Internal nearest-station lookup (kept here to use localized station lists) ─

  /// Uses the old coordinate-list approach so that station names stay locale-
  /// consistent with [allMetroStations].
  Future<Map<String, dynamic>> _findNearestStationFromCoords(
      Position location, BuildContext context) async {
    try {
      final distances = [
        metroLine1StationsCoordinates,
        metroLine2StationsCoordinates,
        metroLine3Branch1StationsCoordinates,
        metroLine3Branch2StationsCoordinates,
        lrtMainStationsCoordinates,
        lrtNacBranchStationsCoordinates,
        lrt10thBranchStationsCoordinates,
      ]
          .map((coords) => coords
              .map((c) => Geolocator.distanceBetween(
                  location.latitude, location.longitude, c[0], c[1]))
              .toList())
          .toList();

      final minPerLine = distances
          .map((d) => d.reduce((a, b) => a < b ? a : b))
          .toList();
      final lineIdx =
          minPerLine.indexOf(minPerLine.reduce((a, b) => a < b ? a : b));

      final lists = [
        metroLine1Stations,
        metroLine2Stations,
        metroLine3Branch1Stations,
        metroLine3Branch2Stations,
        lrtMainStations,
        lrtNacBranchStations,
        lrt10thBranchStations,
      ];
      final coords = [
        metroLine1StationsCoordinates,
        metroLine2StationsCoordinates,
        metroLine3Branch1StationsCoordinates,
        metroLine3Branch2StationsCoordinates,
        lrtMainStationsCoordinates,
        lrtNacBranchStationsCoordinates,
        lrt10thBranchStationsCoordinates,
      ];

      final stationIdx = distances[lineIdx].indexOf(minPerLine[lineIdx]);
      final station = lists[lineIdx][stationIdx];
      final coord = coords[lineIdx][stationIdx];

      final depLocation = LocationService.instance.makePosition(coord[0], coord[1]);
      return {'Station': station, 'DepartureLocation': depLocation};
    } catch (e) {
      return {'Station': '', 'DepartureLocation': LocationService.instance.makePosition(0, 0)};
    }
  }

  /// Kept for backward compat — legacy callers in homepage.dart.
  Future<Map<String, dynamic>> findNearestStation(
      Position location, BuildContext context) async {
    return _findNearestStationFromCoords(location, context);
  }

  Position locationToPosition(location) =>
      LocationService.instance.locationToPosition(location);
}
