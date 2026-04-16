import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controllers/homepagecontroller.dart';
import '../Pages/routepage.dart';
import 'tour_keys.dart';
import 'tour_overlay.dart';
import 'tour_step.dart';

// SharedPreferences keys
const _kTourCompleted = 'tour_completed_v1';
const _kTourDismissed = 'tour_dismissed_v1';

// ─────────────────────────────────────────────────────────────────────────────
// Step definitions  (8 total: 0 = welcome, 1–7 = spotlight steps)
// ─────────────────────────────────────────────────────────────────────────────

// GlobalKeys are runtime objects so the list cannot be const.
final List<TourStep> _kSteps = [
  // 0 — Welcome modal (no spotlight)
  const TourStep(stepId: 'welcome'),

  // 1 — Nearest station card
  TourStep(
    stepId: 'nearestStation',
    targetKey: TourKeys.nearestStationCard,
    padding: 12,
  ),

  // 2 — Route planner card (description mentions swap button, no separate step)
  TourStep(
    stepId: 'routePlanner',
    targetKey: TourKeys.routePlannerCard,
    padding: 10,
  ),

  // 3 — Arrival finder card (below the fold — must scroll into view first)
  TourStep(
    stepId: 'arrivalFinder',
    targetKey: TourKeys.arrivalFinderCard,
    padding: 10,
    scrollToTarget: true,
  ),

  // 4 — Tourist guide card (also below the fold)
  TourStep(
    stepId: 'touristGuide',
    targetKey: TourKeys.touristGuideCard,
    padding: 10,
    scrollToTarget: true,
  ),

  // 5 — Search button (scroll back to top first, then auto-navigates to Routepage)
  TourStep(
    stepId: 'searchButton',
    targetKey: TourKeys.searchButton,
    padding: 10,
    scrollToTarget: true,
  ),

  // 6 — First route card (on Routepage)
  TourStep(
    stepId: 'routeCard',
    targetKey: TourKeys.firstRouteCard,
    padding: 10,
    forceBelow: true,
  ),

  // 7 — Directions card (fixed at bottom of Routepage — scroll list up to expose it)
  TourStep(
    stepId: 'directions',
    targetKey: TourKeys.directionsCard,
    padding: 12,
    scrollToTarget: true,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// TourController
// ─────────────────────────────────────────────────────────────────────────────

class TourController extends GetxController {
  // ── Public reactive state ─────────────────────────────────────────────────

  /// Current step index. −1 means the tour is not active.
  final currentStep = RxInt(-1);

  /// True while the overlay is visible.
  final isActive = RxBool(false);

  // ── Private ───────────────────────────────────────────────────────────────

  OverlayEntry? _overlayEntry;

  // ── Accessors ─────────────────────────────────────────────────────────────

  static List<TourStep> get steps => _kSteps;
  int get totalSteps => _kSteps.length;

  TourStep? get currentStepData {
    final i = currentStep.value;
    return (i >= 0 && i < _kSteps.length) ? _kSteps[i] : null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────────────────

  /// Call once from Homepage after the UI has settled.
  /// Starts the tour automatically for first-time users.
  Future<void> startTourIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_kTourCompleted) ?? false;
    final dismissed = prefs.getBool(_kTourDismissed) ?? false;
    if (!completed && !dismissed) startTour();
  }

  void startTour() {
    if (isActive.value) return;
    isActive.value = true;
    currentStep.value = 0;
    _insertOverlay();
  }

  /// Restart the tour from step 0 (e.g. from the info sheet).
  /// Scrolls the homepage back to the top first so every spotlight target
  /// is in its expected on-screen position before the overlay appears.
  Future<void> restartTour() async {
    // Clear dismissed/completed flags so the tour can be saved again.
    SharedPreferences.getInstance().then((p) {
      p.remove(_kTourCompleted);
      p.remove(_kTourDismissed);
    });

    // Scroll to top — gives widgets time to settle into their resting
    // positions before we measure their RenderBox bounds for the spotlight.
    final sc = Get.find<HomepageController>().scrollController;
    if (sc.hasClients && sc.offset > 0) {
      await sc.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
      // One extra frame so the SliverAppBar fully re-expands.
      await Future.delayed(const Duration(milliseconds: 80));
    }

    _removeOverlay();
    isActive.value = true;
    currentStep.value = 0;
    _insertOverlay();
  }

  /// Advance to the next step. Step 5 triggers the demo navigation.
  Future<void> next() async {
    HapticFeedback.selectionClick();
    final step = currentStep.value;

    if (step == 5) {
      // Special case: navigate to Routepage as a live demo.
      await _navigateForDemo();
      return;
    }

    if (step >= _kSteps.length - 1) {
      await _completeTour();
    } else {
      currentStep.value = step + 1;
    }
  }

  /// Dismiss the tour without completing it (user chose to skip).
  Future<void> skip() async {
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourDismissed, true);
    _endTour();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Fill the HomepageController with a demo route (if empty) and push
  /// Routepage with Cairo Tower as destination, then wait for the first
  /// route card to appear in the tree before advancing to step 6.
  Future<void> _navigateForDemo() async {
    final homeCtrl = Get.find<HomepageController>();
    final stations = homeCtrl.allMetroStations;

    String dep = homeCtrl.depStation.value;
    String arr = homeCtrl.arrStation.value;

    // Pre-fill only when fields are blank or both are the same station.
    if (dep.isEmpty || arr.isEmpty || dep == arr) {
      if (stations.length >= 20) {
        dep = stations.first;
        arr = stations[15];
      } else if (stations.length >= 2) {
        dep = stations.first;
        arr = stations.last;
      }
      homeCtrl.depStation.value = dep;
      homeCtrl.depStationIndex = stations.indexOf(dep);
      homeCtrl.arrStation.value = arr;
      homeCtrl.arrStationIndex = stations.indexOf(arr);
    }

    homeCtrl.saveRecentRoute(dep, arr);

    // Cairo Tower coordinates — pre-fills the destination so that both the
    // departure and arrival directions rows are visible in Routepage.
    Get.to(
      () => Routepage(),
      arguments: {
        'DepartureStation': dep,
        'ArrivalStation': arr,
        'SortType': '0',
        'PreferAccessible': '0',
        'DestLat': '30.0459',
        'DestLng': '31.2243',
        'DestName': 'Cairo Tower',
      },
    );

    // Poll until the first route card key is attached to a render object
    // (i.e. Routepage has finished building its list) — up to ~5 seconds.
    for (int i = 0; i < 50; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (TourKeys.firstRouteCard.currentContext != null) break;
    }

    // One extra frame so the widget is fully laid out and measurable.
    await Future.delayed(const Duration(milliseconds: 80));

    currentStep.value = 6;
  }

  Future<void> _completeTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourCompleted, true);
    _endTour();
    // Pop back to homepage (first route) after the tour ends.
    Get.until((route) => route.isFirst);
  }

  void _endTour() {
    isActive.value = false;
    currentStep.value = -1;
    _removeOverlay();
  }

  // ── OverlayEntry lifecycle ────────────────────────────────────────────────

  void _insertOverlay() {
    // Get.key is the GlobalKey<NavigatorState> that GetX owns.
    // NavigatorState.overlay is the root Overlay — it persists across
    // all route pushes, which is exactly what we need for the cross-screen tour.
    final overlay = Get.key.currentState?.overlay;
    if (overlay == null) return;
    _overlayEntry = OverlayEntry(
      builder: (_) => const TourOverlayWidget(),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  @override
  void onClose() {
    _removeOverlay();
    super.onClose();
  }
}
