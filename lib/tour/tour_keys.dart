import 'package:flutter/widgets.dart';

/// Central registry of [GlobalKey]s used by the guided tour.
abstract class TourKeys {
  TourKeys._();

  // ── Homepage ───────────────────────────────────────────────────────────────
  static final GlobalKey nearestStationCard =
      GlobalKey(debugLabel: 'tour_nearestStation');

  static final GlobalKey routePlannerCard =
      GlobalKey(debugLabel: 'tour_routePlanner');

  static final GlobalKey swapButton =
      GlobalKey(debugLabel: 'tour_swap');

  static final GlobalKey searchButton =
      GlobalKey(debugLabel: 'tour_search');

  static final GlobalKey arrivalFinderCard =
      GlobalKey(debugLabel: 'tour_arrivalFinder');

  static final GlobalKey touristGuideCard =
      GlobalKey(debugLabel: 'tour_touristGuide');

  // ── Routepage ──────────────────────────────────────────────────────────────
  static final GlobalKey firstRouteCard =
      GlobalKey(debugLabel: 'tour_firstRoute');

  static final GlobalKey directionsCard =
      GlobalKey(debugLabel: 'tour_directions');
}
