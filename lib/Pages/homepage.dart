import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:metroappflutter/Controllers/homepagecontroller.dart';
import 'package:metroappflutter/Controllers/languagecontroller.dart';
import 'package:metroappflutter/Pages/metro_map_page.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/core/theme/theme_controller.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/widgets/metro_map_preview.dart';
import 'package:metroappflutter/widgets/home/route_planner_card.dart';
import 'package:metroappflutter/widgets/home/metro_lines_section.dart';
import 'package:metroappflutter/widgets/home/nearest_station_card.dart';
import 'package:metroappflutter/widgets/home/arrival_finder_card.dart';
import 'package:metroappflutter/widgets/home/quick_actions_section.dart';
import 'package:metroappflutter/widgets/home/explore_area_section.dart';

import '../Constants/metro_stations.dart';
import '../tour/tour_controller.dart';

// ── Promo price data (not translatable — currency amounts) ───────────────────


// ── Design tokens ─────────────────────────────────────────────────────────────
// Single source of truth for spacing and typography on this screen.

abstract class _Sp {
  static const double sm = 12.0; // between related cards
  static const double lg = 20.0; // between major sections
}

abstract class _TS {
  // Secondary text — blueGrey.shade400 equivalent
  static const Color _secondary = Color(0xFF78909C);

  /// Subtitles / secondary body text inside cards
  static const bodySecondary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: _secondary,
    height: 1.4,
  );

}

// ═════════════════════════════════════════════════════════════════════════════
// Homepage
// ═════════════════════════════════════════════════════════════════════════════

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final HomepageController _ctrl = Get.find<HomepageController>();
  final LanguageController _langCtrl = Get.find<LanguageController>();

  bool _isLoading = true;
  bool _tourTriggered = false;

  /// GetX worker that watches [HomepageController.isLocatingNearest].
  /// Disposed when GPS settles or when this widget is disposed.
  Worker? _gpsWorker;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Kick off the tour scheduling logic only after the skeleton clears,
      // so all GlobalKeys are attached to their widgets.
      _scheduleTour();
    });
  }

  @override
  void dispose() {
    _gpsWorker?.dispose();
    super.dispose();
  }

  // ── Tour scheduling ────────────────────────────────────────────────────────

  /// Starts the tour after two conditions are both true:
  ///   1. GPS flow is no longer running (covers the system permission dialog,
  ///      which blocks inside [HomepageController.updateUserLocation]).
  ///   2. No Flutter dialog/sheet is covering the homepage (covers the custom
  ///      "location disabled" / "permission denied" dialogs shown by
  ///      [NearestStationCard] after the GPS call throws).
  void _scheduleTour() {
    if (_tourTriggered) return;
    final homeCtrl = Get.find<HomepageController>();

    if (homeCtrl.isLocatingNearest.value) {
      // GPS is already running — subscribe and fire once when it finishes.
      _gpsWorker = ever(homeCtrl.isLocatingNearest, (bool locating) {
        if (!locating && !_tourTriggered) {
          _gpsWorker?.dispose();
          _gpsWorker = null;
          _startTourAfterDialogs();
        }
      });
    } else {
      // NearestStationCard triggers GPS via addPostFrameCallback one frame
      // after its own initState, so it may not have started yet.
      // Wait a short tick and check again.
      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted || _tourTriggered) return;
        if (homeCtrl.isLocatingNearest.value) {
          _scheduleTour(); // now it's running — watch it
        } else {
          _startTourAfterDialogs(); // no GPS activity — proceed directly
        }
      });
    }
  }

  /// Polls until this page is the top route (no dialog covering it), then
  /// triggers the tour with a small settle buffer.
  Future<void> _startTourAfterDialogs() async {
    if (!mounted || _tourTriggered) return;

    // Grace period: isLocatingNearest becomes false synchronously inside
    // HomepageController, but NearestStationCard's catch block (which calls
    // showLocationDialog) runs one microtask later.  Without this delay the
    // first poll fires before the dialog is pushed onto the route stack,
    // sees isCurrent == true, and lets the tour start while the dialog is
    // still appearing.  700 ms is safely longer than any dialog push.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted || _tourTriggered) return;

    // Poll every 200 ms, up to 8 seconds, until Homepage is the top route.
    // This handles permission-denied dialogs that are still open.
    for (int i = 0; i < 40; i++) {
      if (!mounted) return;
      if (ModalRoute.of(context)?.isCurrent ?? false) break;
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (!mounted || _tourTriggered) return;
    _tourTriggered = true;

    // Brief settle buffer so the UI is visually at rest before the overlay animates in.
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) Get.find<TourController>().startTourIfNeeded();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _ctrl.allMetroStations = getAllMetroStations(context);
    _ctrl.getMetroStationsLists(context);

    // Resync selected station names whenever the locale changes.
    // We store the index into allMetroStations as the locale-independent key,
    // then translate it back to the current-locale name after every rebuild.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stations = _ctrl.allMetroStations;
      if (_ctrl.depStationIndex >= 0 &&
          _ctrl.depStationIndex < stations.length &&
          _ctrl.depStation.value != stations[_ctrl.depStationIndex]) {
        _ctrl.depStation.value = stations[_ctrl.depStationIndex];
      }
      if (_ctrl.arrStationIndex >= 0 &&
          _ctrl.arrStationIndex < stations.length &&
          _ctrl.arrStation.value != stations[_ctrl.arrStationIndex]) {
        _ctrl.arrStation.value = stations[_ctrl.arrStationIndex];
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showExitDialog(context, l10n);
      },
      child: Scaffold(
      body: RefreshIndicator(
        color: AppTheme.primaryNile,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _ctrl.scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(context, l10n),
            SliverToBoxAdapter(
              child: _isLoading
                  ? _buildSkeleton()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(10, 14, 10, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeHeader(context, l10n),
                          const SizedBox(height: _Sp.sm),
                          const NearestStationCard(),
                          const SizedBox(height: _Sp.sm),
                          const RoutePlannerCard(),
                          const SizedBox(height: _Sp.sm),
                          const ArrivalFinderCard(),
                          const SizedBox(height: _Sp.lg),
                          const QuickActionsSection(),
                          const SizedBox(height: _Sp.lg),
                          const MetroLinesSection(),
                          const SizedBox(height: _Sp.lg),
                          const ExploreAreaSection(),
                          const SizedBox(height: _Sp.lg),
                          MetroMapPreview(onTap: () => _openMap(context, l10n)),
                          // const SizedBox(height: 22),
                          // _buildPromoCarousel(context, l10n),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  // ── Exit confirmation dialog ────────────────────────────────────────────────

  Future<void> _showExitDialog(
      BuildContext context, AppLocalizations l10n) async {
    HapticFeedback.mediumImpact();
    await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'dismiss',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 320),
      transitionBuilder: (_, anim, __, child) {
        final curved =
            CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: child,
          ),
        );
      },
      pageBuilder: (ctx, _, __) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Theme.of(ctx).brightness == Brightness.dark
                  ? AppTheme.darkSurface
                  : AppTheme.lightCard,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF184D56).withOpacity(0.22),
                  blurRadius: 48,
                  spreadRadius: -4,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            // ClipRRect so the gradient header respects the rounded corners
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Gradient header with icon
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A6B7A), Color(0xFF0C3340)],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Icon on white circle
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5),
                          ),
                          child: const Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.exitDialogTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Body
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                    child: Column(
                      children: [
                        Text(
                          l10n.exitDialogSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(ctx).brightness == Brightness.dark
                                ? AppTheme.darkTextSub
                                : Colors.grey.shade600,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // ── Buttons
                        Row(
                          children: [
                            // Stay
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15),
                                  side: BorderSide(
                                      color: Theme.of(ctx).brightness ==
                                              Brightness.dark
                                          ? AppTheme.darkBorder
                                          : Colors.grey.shade200,
                                      width: 1.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16)),
                                  backgroundColor:
                                      Theme.of(ctx).brightness ==
                                              Brightness.dark
                                          ? AppTheme.darkElevated
                                          : Colors.grey.shade50,
                                ),
                                child: Text(
                                  l10n.exitDialogStay,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Theme.of(ctx).brightness ==
                                            Brightness.dark
                                        ? AppTheme.darkTextSub
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Exit
                            Expanded(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1A6B7A),
                                      Color(0xFF0C3340)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF184D56)
                                          .withOpacity(0.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    SystemNavigator.pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                  child: Text(
                                    l10n.exitDialogExit,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // App Bar
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: AppTheme.primaryNile,
      // More modern continuous curve
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(48)),
      ),
      // ── Glassmorphism action buttons (blur backdrop) ─────────────────────
      actions: [
        _buildActionBtn(Icons.info_outline, () => _showInfo(context, l10n)),
        const SizedBox(width: 8),
        _buildActionBtn(Icons.language, () => _showLangPicker(context, l10n)),
        const SizedBox(width: 8),
        Obx(() {
          final themeCtrl = Get.find<ThemeController>();
          return _buildActionBtn(
            themeCtrl.isDark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            () => themeCtrl.toggleTheme(),
          );
        }),
        const SizedBox(width: 16),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (ctx, constraints) {
          // t = 1.0 fully expanded, 0.0 fully collapsed
          final minH = MediaQuery.of(ctx).padding.top + kToolbarHeight;
          final t = ((constraints.biggest.height - minH) / (220 - minH))
              .clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
            ],
            // Title glides inward as bar collapses so it never fights actions
            titlePadding: EdgeInsetsDirectional.only(
              start: lerpDouble(20, 30, 1 - t)!,
              bottom: 10,
            ),
            // ── Pinned title: icon circle + app name only (no badge) ──────
            title: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/metrologo.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.appTitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // 1. BG image
                Image.asset('assets/images/metroBG1.jpg', fit: BoxFit.cover),
                // 2. Geometric pattern overlay
                CustomPaint(painter: _DiamondGridPainter()),
                // 3. Two-layer gradient for legibility:
                //    - a subtle dark veil covers the full image so text
                //      always has contrast at every scroll position
                //    - the primaryNile wash strengthens toward the bottom
                //      where stats & title live
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.44),
                        AppTheme.primaryNile.withOpacity(0.32),
                        AppTheme.primaryNile.withOpacity(0.84),
                        AppTheme.primaryNile,
                      ],
                      stops: const [0.0, 0.30, 0.74, 1.0],
                    ),
                  ),
                ),
                // 4. Expanded info area — fades out smoothly while scrolling
                //    The SizedBox(height:62) at the bottom keeps this block
                //    above the title row with zero overlap.
                Opacity(
                  opacity: (t - 0.25).clamp(0.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Glassmorphism status badge with animated pulse dot
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.45),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const _PulseDot(),
                              const SizedBox(width: 6),
                              Text(
                                l10n.allOperationalLabel.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Network stats — scrollable so Arabic labels never clip
                        // L1(34)+L2(20)+L3(34)=88 stations, ~99 km metro network
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Row(
                            children: [
                              _statBadge('88', l10n.stationsLabel),
                              _vDivider(),
                              _statBadge('3', l10n.metroLinesTitle),
                              _vDivider(),
                              _statBadge('~99', 'KM'),
                              _vDivider(),
                              _statBadge('LRT', '& Mono'),
                            ],
                          ),
                        ),
                        // Reserve space for the title row below
                        const SizedBox(height: 62),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── App bar helpers ────────────────────────────────────────────────────────

  Widget _statBadge(String value, String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );

  Widget _vDivider() => Container(
        width: 1,
        height: 22,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        color: Colors.white.withOpacity(0.22),
      );

  Widget _buildActionBtn(
    IconData icon,
    VoidCallback onPressed, {
    double boxSize = 30,
    double iconSize = 20,
    double borderRadius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
  }) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: Container(
            color: Colors.white.withOpacity(0.13),
            child: IconButton(
              icon: Icon(icon, color: Colors.white, size: iconSize),
              onPressed: onPressed,
              padding: padding,
              constraints: BoxConstraints.tightFor(
                width: boxSize,
                height: boxSize,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
      );

  Widget _buildWelcomeHeader(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: AppTheme.primaryNile, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '👋 ${_getGreeting(l10n)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppTheme.darkPrimary : AppTheme.primaryNile,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.homepageSubtitle,
                  style: _TS.bodySecondary.copyWith(
                    color: isDark
                        ? AppTheme.darkTextSub
                        : const Color(0xFF78909C),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          //   decoration: BoxDecoration(
          //     color: AppTheme.primaryNile.withOpacity(0.08),
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       const Icon(Icons.train_rounded,
          //           size: 13, color: AppTheme.primaryNile),
          //       const SizedBox(width: 4),
          //       Text(
          //         '88 ${l10n.stationsLabel}',
          //         style: _TS.label.copyWith(color: AppTheme.primaryNile),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 17) return l10n.greetingAfternoon;
    if (hour < 21) return l10n.greetingEvening;
    return l10n.greetingNight;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Shimmer skeleton
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSkeleton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppTheme.darkCard : Colors.grey.shade300,
      highlightColor: isDark ? AppTheme.darkElevated : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(100, radius: 22),
            const SizedBox(height: 14),
            _shimmerBox(190, radius: 24),
            const SizedBox(height: 14),
            _shimmerBox(110, radius: 22),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _shimmerBox(88, radius: 20)),
                const SizedBox(width: 10),
                Expanded(child: _shimmerBox(88, radius: 20)),
                const SizedBox(width: 10),
                Expanded(child: _shimmerBox(88, radius: 20)),
              ],
            ),
            const SizedBox(height: 14),
            _shimmerBox(130, radius: 20),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(double h, {double radius = 14}) => Container(
        height: h,
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // Actions
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() => _isLoading = false);
  }

  void _showInfo(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 14, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ── App info section ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryNile.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.directions_subway_rounded,
                          color: AppTheme.primaryNile,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.appInfoTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black87,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.appInfoDescription,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: isDark
                                    ? Colors.white60
                                    : Colors.black54,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.shade200,
                ),

                // ── Replay tour row ───────────────────────────────────────
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Small delay so the sheet fully closes before the
                    // overlay re-inserts itself on top of the homepage.
                    Future.delayed(const Duration(milliseconds: 350), () {
                      Get.find<TourController>().restartTour();
                    });
                  },
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.accentGold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.tour_rounded,
                            color: AppTheme.accentGold,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.onboardingReplay,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black87,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.onboardingSubtitle1,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black38,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: isDark ? Colors.white30 : Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLangPicker(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const accent = Color(0xFF4A90D9);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      builder: (_) {
        final langs = [
          ('en', 'English',  '🇬🇧'),
          ('ar', 'العربية',  '🇪🇬'),
          ('fr', 'Français', '🇫🇷'),
          ('es', 'Español',  '🇪🇸'),
          ('de', 'Deutsch',  '🇩🇪'),
          ('ru', 'Русский',  '🇷🇺'),
          ('it', 'Italiano', '🇮🇹'),
          ('pt', 'Português','🇵🇹'),
          ('zh', '中文',      '🇨🇳'),
          ('tr', 'Türkçe',   '🇹🇷'),
          ('ja', '日本語',   '🇯🇵'),
        ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // drag handle
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(Icons.language_rounded,
                        color: accent, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      l10n.languageSwitchTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ...langs.map((lang) {
                  final isSelected =
                      _langCtrl.selectedLanguage.value == lang.$1;
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _langCtrl.switchLanguage(lang.$1);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 6),
                      child: Row(
                        children: [
                          Text(lang.$3,
                              style: const TextStyle(fontSize: 26)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              lang.$2,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? accent
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.black87),
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_rounded,
                                color: accent, size: 20),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openMap(BuildContext context, AppLocalizations l10n) {
    Get.to(
      () => const MetroMapPage(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 320),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Depart-when chip
// ═════════════════════════════════════════════════════════════════════════════

class _DepartChip extends StatefulWidget {
  final AppLocalizations l10n;
  const _DepartChip({required this.l10n});

  @override
  State<_DepartChip> createState() => _DepartChipState();
}

class _DepartChipState extends State<_DepartChip> {
  DateTime? _dt;

  @override
  Widget build(BuildContext context) {
    final label = _dt == null
        ? widget.l10n.leaveNowLabel
        : '${_dt!.hour.toString().padLeft(2, '0')}:${_dt!.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () async {
        HapticFeedback.selectionClick();
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 30)),
        );
        if (date == null || !context.mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time == null) return;
        setState(() => _dt =
            DateTime(date.year, date.month, date.day, time.hour, time.minute));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primaryNile.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryNile.withOpacity(0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time_rounded,
                size: 13, color: AppTheme.primaryNile),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.primaryNile,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Promo card
// ═════════════════════════════════════════════════════════════════════════════

// ── Animated pulsing dot for the "All Operational" status badge ──────────────

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: const Color(0xFF00E676).withOpacity(_anim.value),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E676).withOpacity(_anim.value * 0.55),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      );
}

class _PulseDotSmall extends StatefulWidget {
  final Color color;
  const _PulseDotSmall({required this.color});

  @override
  State<_PulseDotSmall> createState() => _PulseDotSmallState();
}

class _PulseDotSmallState extends State<_PulseDotSmall>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(_animation.value),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ── Diamond grid + lotus circles background painter ──────────────────────────

class _DiamondGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.045)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const step = 30.0;
    for (var x = -step; x < size.width + step; x += step) {
      for (var y = -step; y < size.height + step; y += step) {
        final path = Path()
          ..moveTo(x + step / 2, y)
          ..lineTo(x + step, y + step / 2)
          ..lineTo(x + step / 2, y + step)
          ..lineTo(x, y + step / 2)
          ..close();
        canvas.drawPath(path, linePaint);
      }
    }

    // Lotus-inspired concentric circles
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final cx = size.width * 0.84;
    final cy = size.height * 0.18;
    for (final r in [28.0, 46.0, 64.0]) {
      canvas.drawCircle(Offset(cx, cy), r, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
