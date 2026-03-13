import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:metroappflutter/Controllers/homepagecontroller.dart';
import 'package:metroappflutter/Controllers/languagecontroller.dart';
import 'package:metroappflutter/Pages/metro_map_page.dart';
import 'package:metroappflutter/Pages/routepage.dart';
import 'package:metroappflutter/Pages/subscription_info.dart';
import 'package:metroappflutter/Pages/tourist_guide.dart';
import 'package:metroappflutter/Pages/station_explorer.dart';
import 'package:metroappflutter/Pages/station_facilities.dart';
import 'package:metroappflutter/Pages/location_picker_page.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/widgets/animated_search_bar.dart';
import 'package:metroappflutter/widgets/all_lines_modal.dart';
import 'package:metroappflutter/widgets/line_preview_card.dart';
import 'package:metroappflutter/widgets/metro_map_preview.dart';
import 'package:metroappflutter/widgets/quick_action_card.dart';

import '../Constants/metro_stations.dart';

// ── Promo price data (not translatable — currency amounts) ───────────────────

class _PromoPrice {
  final String price;
  final String original;
  final IconData icon;
  final List<Color> gradient;

  const _PromoPrice({
    required this.price,
    required this.original,
    required this.icon,
    required this.gradient,
  });
}

const _promoPrices = [
  _PromoPrice(
    price: 'EGP 250',
    original: 'EGP 350',
    icon: Icons.card_membership_rounded,
    gradient: [Color(0xFF1A535C), Color(0xFF0C3340)],
  ),
  _PromoPrice(
    price: 'EGP 4',
    original: 'EGP 8',
    icon: Icons.school_rounded,
    gradient: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
  ),
  _PromoPrice(
    price: 'EGP 180',
    original: 'EGP 280',
    icon: Icons.group_rounded,
    gradient: [Color(0xFF6A1B9A), Color(0xFF4A148C)],
  ),
];

// ── Recent search ─────────────────────────────────────────────────────────────

class _RecentSearch {
  final String dep;
  final String arr;
  _RecentSearch({required this.dep, required this.arr});
}

// ── Design tokens ─────────────────────────────────────────────────────────────
// Single source of truth for spacing and typography on this screen.

abstract class _Sp {
  static const double xxs = 4.0; // icon↔text gap, title↔subtitle gap
  static const double sm = 12.0; // between related cards (hero↔planner)
  static const double lg = 20.0; // between major sections (planner↔actions)
  // xs=8, md=16, xl=24, xxl=32 — add here as needed
}

abstract class _TS {
  // Secondary text — blueGrey.shade400 equivalent
  static const Color _secondary = Color(0xFF78909C);

  /// Welcome / hero card title
  static const heroTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppTheme.primaryNile,
    letterSpacing: -0.2,
  );

  /// Card headers (Plan Your Route, Find Station)
  static const cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppTheme.primaryNile,
    letterSpacing: -0.1,
  );

  /// Subtitles / secondary body text inside cards
  static const bodySecondary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: _secondary,
    height: 1.4,
  );

  /// Section headers (Quick Actions, Metro Lines)
  static const sectionHeader = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppTheme.primaryNile,
    letterSpacing: -0.1,
  );

  /// Small label/badge inside pills and chips
  static const label = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  /// Recent-search chip text
  static const chip = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppTheme.primaryNile,
  );

  /// Hint text for input fields
  static const hint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF9E9E9E),
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

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  final HomepageController _ctrl = Get.find<HomepageController>();
  final LanguageController _langCtrl = Get.find<LanguageController>();
  final TextEditingController _destCtrl = TextEditingController();
  final FocusNode _destFocus = FocusNode();

  late final AnimationController _fabAnim;
  late final Animation<double> _fabScale;

  bool _isLoading = true;
  int _promoPage = 0;
  final List<_RecentSearch> _recent = [];
  final RxBool _isLocating = false.obs;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _fabScale = Tween<double>(begin: 1.0, end: 1.10)
        .animate(CurvedAnimation(parent: _fabAnim, curve: Curves.easeInOut));
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void deactivate() {
    // Unfocus when navigating away so keyboard doesn't reopen on return
    _destFocus.unfocus();
    super.deactivate();
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    _destCtrl.dispose();
    _destFocus.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _saveRecent(String dep, String arr) {
    if (dep.isEmpty || arr.isEmpty) return;
    setState(() {
      _recent.removeWhere((s) => s.dep == dep && s.arr == arr);
      _recent.insert(0, _RecentSearch(dep: dep, arr: arr));
      if (_recent.length > 5) _recent.removeLast();
    });
  }

  void _snack(BuildContext ctx, String msg, {bool error = false}) {
    ScaffoldMessenger.maybeOf(ctx)?.showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? AppTheme.error : AppTheme.success,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _ctrl.allMetroStations = getAllMetroStations(context);
    _ctrl.getMetroStationsLists(context);
    final stationLineMap = getStationLineMap(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showExitDialog(context, l10n);
      },
      child: Scaffold(
      backgroundColor: AppTheme.backgroundSand,
      floatingActionButton: _buildFab(l10n),
      body: RefreshIndicator(
        color: AppTheme.primaryNile,
        onRefresh: _onRefresh,
        child: CustomScrollView(
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
                          _buildRoutePlanner(context, l10n),
                          const SizedBox(height: _Sp.sm),
                          _buildArrivalFinder(context, l10n),
                          const SizedBox(height: _Sp.lg),
                          _buildQuickActions(context, l10n),
                          const SizedBox(height: _Sp.lg),
                          _buildLinesSection(context, l10n),
                          const SizedBox(height: _Sp.lg),
                          _buildExploreAreaSection(context, l10n),
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
              color: Colors.white,
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
                            color: Colors.grey.shade600,
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
                                      color: Colors.grey.shade200,
                                      width: 1.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16)),
                                  backgroundColor: Colors.grey.shade50,
                                ),
                                child: Text(
                                  l10n.exitDialogStay,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
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
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_subway_rounded,
                    size: 17,
                    color: Colors.white,
                  ),
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

  // ═══════════════════════════════════════════════════════════════════════════
  // Hero intro card
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeroCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
              color: AppTheme.primaryNile,
              width: 4), // Professional accent line
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.welcomeTitle, style: _TS.heroTitle),
                    const SizedBox(height: _Sp.xxs),
                    Text(l10n.welcomeSubtitle, style: _TS.bodySecondary),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black12,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _buildPill(
                'Metro + LRT',
                Colors.amber.shade800,
                const Color(0xFFFFF8E1),
                icon: Icons.train_rounded,
              ),
              _buildPill(
                'AR / EN',
                AppTheme.primaryNile,
                AppTheme.primaryNile.withOpacity(0.08),
                icon: Icons.language,
              ),
              _buildPill(
                l10n.statusLiveLabel,
                AppTheme.success,
                const Color(0xFFE8F5E9),
                icon: Icons.circle,
                showPulse: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill(
    String text,
    Color fg,
    Color bg, {
    IconData? icon,
    bool showPulse = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.15), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            if (showPulse)
              _PulseDotSmall(color: fg)
            else
              Icon(icon, size: 10, color: fg),
            const SizedBox(width: 4),
          ],
          Text(text, style: _TS.label.copyWith(color: fg)),
        ],
      ),
    );
  }

  // Replace _buildHeroCard with this:

  Widget _buildWelcomeHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: AppTheme.primaryNile, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                    color: AppTheme.primaryNile,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.homepageSubtitle,
                  style: _TS.bodySecondary,
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
  // Route planner
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildRoutePlanner(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryNile.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.route,
                    color: AppTheme.primaryNile, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.planYourRoute, style: _TS.cardTitle),
                    const SizedBox(height: _Sp.xxs),
                    Text(
                      l10n.planYourRouteSubtitle,
                      style: _TS.bodySecondary,
                    ),
                  ],
                ),
              ),
              _DepartChip(l10n: l10n),
            ],
          ),
          const SizedBox(height: 18),

          // ── Search fields + connector + swap
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Vertical connector
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dot(AppTheme.primaryNile),
                  Container(
                    width: 2,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryNile.withOpacity(0.6),
                          AppTheme.accentGold.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  _dot(AppTheme.accentGold),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Obx(() => AnimatedSearchBar(
                          maxDropdownHeight: 280,
                          hint: l10n.departureStationHint,
                          icon: Icons.trip_origin,
                          suggestions: _ctrl.allMetroStations,
                          selectedText: _ctrl.depStation.value,
                          onSelected: (v) => _ctrl.depStation.value = v,
                          stationLines: getStationLineMap(context),
                        )),
                    const SizedBox(height: 8),
                    Obx(() => AnimatedSearchBar(
                          maxDropdownHeight: 280,
                          hint: l10n.arrivalStationHint,
                          icon: Icons.location_on,
                          suggestions: _ctrl.allMetroStations,
                          selectedText: _ctrl.arrStation.value,
                          onSelected: (v) => _ctrl.arrStation.value = v,
                          stationLines: getStationLineMap(context),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Swap button
              Obx(() {
                final both = _ctrl.depStation.value.isNotEmpty &&
                    _ctrl.arrStation.value.isNotEmpty;
                return Opacity(
                  opacity: both ? 1.0 : 0.28,
                  child: GestureDetector(
                    onTap: both
                        ? () {
                            HapticFeedback.selectionClick();
                            final tmp = _ctrl.depStation.value;
                            _ctrl.depStation.value = _ctrl.arrStation.value;
                            _ctrl.arrStation.value = tmp;
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryNile.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppTheme.primaryNile.withOpacity(0.18)),
                      ),
                      child: const Icon(
                        Icons.swap_vert_rounded,
                        color: AppTheme.primaryNile,
                        size: 20,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          // ── Recent searches
          if (_recent.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.history, size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  l10n.recentSearchesLabel,
                  style:
                      _TS.bodySecondary.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _recent.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) {
                  final s = _recent[i];
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _ctrl.depStation.value = s.dep;
                      _ctrl.arrStation.value = s.arr;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryNile.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppTheme.primaryNile.withOpacity(0.14)),
                      ),
                      child: Text('${s.dep}  →  ${s.arr}', style: _TS.chip),
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── Search button
          Obx(() {
            final valid = _ctrl.depStation.value.isNotEmpty &&
                _ctrl.arrStation.value.isNotEmpty &&
                _ctrl.depStation.value != _ctrl.arrStation.value;
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: valid
                    ? () {
                        HapticFeedback.mediumImpact();
                        _saveRecent(
                            _ctrl.depStation.value, _ctrl.arrStation.value);
                        Get.to(
                          () => Routepage(),
                          arguments: {
                            'DepartureStation': _ctrl.depStation.value,
                            'ArrivalStation': _ctrl.arrStation.value,
                            'SortType': '0',
                          },
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      valid ? AppTheme.primaryNile : Colors.grey.shade300,
                  foregroundColor: valid ? Colors.white : Colors.grey.shade600,
                  elevation: valid ? 2 : 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(valid ? Icons.directions_rounded : Icons.block,
                    size: 20),
                label: Text(
                  l10n.showRoutesButtonText,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // Arrival / destination finder
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildArrivalFinder(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Minimal header with subtle icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: Colors.grey.shade700,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(l10n.findNearestStation, style: _TS.cardTitle),
            ],
          ),

          const SizedBox(height: 16),

          // Search input with elegant design
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: TextField(
              controller: _destCtrl,
              focusNode: _destFocus,
              decoration: InputDecoration(
                hintText: '${l10n.destinationFieldLabel}',
                hintStyle: _TS.hint,
                prefixIcon: Icon(
                  Icons.place_outlined,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                suffixIcon: _destCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () {
                          _destCtrl.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _findByAddress(context, l10n),
            ),
          ),

          const SizedBox(height: 8),

          // Optional helper text for Google Maps link
          if (_destCtrl.text.contains('maps.google') ||
              _destCtrl.text.contains('goo.gl/maps'))
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 12,
                    color: AppTheme.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.googleMapsLinkDetected,
                    style:
                        _TS.bodySecondary.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Action buttons - clean and balanced
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _findByAddress(context, l10n),
                  icon: const Icon(Icons.search_rounded, size: 16),
                  label: Text(l10n.findButtonText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryNile,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickFromMap(context, l10n),
                  icon: Icon(Icons.map_outlined,
                      size: 16, color: AppTheme.primaryNile),
                  label: Text(
                    l10n.pickFromMapLabel,
                    style: TextStyle(color: AppTheme.primaryNile),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(
                        color: AppTheme.primaryNile.withOpacity(0.3)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Quick actions
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n) {
    final actions = [
      _QuickAction(
        icon: Icons.tour_rounded,
        label: l10n.touristGuideTitle,
        subtitle: l10n.nearbyAttractions,
        ctaLabel: l10n.viewDetails,
        color: AppTheme.line3,
        badge: 48,
        onTap: () => Get.to(() => TouristGuidePage()),
      ),
      _QuickAction(
        icon: Icons.credit_card_rounded,
        label: l10n.subscriptionInfoTitle,
        subtitle: l10n.viewPlansLabel,
        ctaLabel: l10n.learnMore,
        color: AppTheme.line1,
        onTap: () => Get.to(() => SubscriptionInfoPage()),
      ),
      // _QuickAction(
      //   icon: Icons.location_city_rounded,
      //   label: l10n.metroStations,
      //   subtitle: '88 ${l10n.stationsLabel}',
      //   ctaLabel: l10n.viewAllStations,
      //   color: AppTheme.accentGold,
      //   onTap: () => Get.to(() => const StationExplorerPage()),
      // ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            _sectionTitle(context, l10n.quickActionsTitle),
          ],
        ),
        const SizedBox(height: 10),
        ...actions.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildFeatureBannerCard(a),
            )),
      ],
    );
  }

  Widget _buildFeatureBannerCard(_QuickAction a) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        a.onTap();
      },
      child: Container(
        height: 100,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              a.color.withOpacity(0.11),
              a.color.withOpacity(0.03),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: a.color.withOpacity(0.18), width: 1),
        ),
        child: Stack(
          children: [
            // Watermark icon — large, faded, right side
            Positioned(
              right: -12,
              top: -12,
              child: Icon(a.icon, size: 115, color: a.color.withOpacity(0.07)),
            ),
            // Left accent strip
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 4, color: a.color),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 100, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title + badge
                  Row(
                    children: [
                      Text(
                        a.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: a.color,
                        ),
                      ),
                      if (a.badge > 0) ...[
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: a.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${a.badge}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Subtitle
                  Text(
                    a.subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  // CTA
                  Row(
                    children: [
                      Text(
                        a.ctaLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: a.color,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded,
                          size: 13, color: a.color),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Metro lines overview
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLinesSection(BuildContext context, AppLocalizations l10n) {
    final lines = [
      (
        id: '1',
        name: l10n.line1Name,
        color: AppTheme.line1,
        stations: 34,
        underConstruction: false
      ),
      (
        id: '2',
        name: l10n.line2Name,
        color: AppTheme.line2,
        stations: 20,
        underConstruction: false
      ),
      (
        id: '3',
        name: l10n.line3Name,
        color: AppTheme.line3,
        stations: 34,
        underConstruction: false
      ),
      (
        id: 'LRT',
        name: l10n.lrtLineName,
        color: AppTheme.lrt,
        stations: 19,
        underConstruction: false
      ),
      (
        id: '4',
        name: l10n.line4FullName,
        color: AppTheme.line4,
        stations: 24,
        underConstruction: true
      ),
      (
        id: 'ME',
        name: l10n.monorailEastName,
        color: AppTheme.monorail,
        stations: 22,
        underConstruction: true
      ),
      (
        id: 'MW',
        name: l10n.monorailWestName,
        color: const Color(0xFF7B1FA2),
        stations: 18,
        underConstruction: true
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: _sectionTitle(context, l10n.metroLinesTitle),
        ),
        const SizedBox(height: 10),
        ...lines.map((line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildLineRow(context, line.id, line.name, line.color,
                  line.stations, l10n, line.underConstruction),
            )),
      ],
    );
  }

  Widget _buildLineRow(
      BuildContext context,
      String id,
      String name,
      Color color,
      int stations,
      AppLocalizations l10n,
      bool underConstruction) {
    final meta = kLineMetadata[id];
    final cardColor = underConstruction ? Colors.grey.shade50 : Colors.white;
    final textColor =
        underConstruction ? Colors.grey.shade500 : Colors.grey.shade800;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        AllLinesModal.show(context, lineId: id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color: underConstruction ? color.withOpacity(0.4) : color,
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(underConstruction ? 0.04 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Line number circle
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: underConstruction ? color.withOpacity(0.35) : color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + chips
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                      if (underConstruction) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.orange.withOpacity(0.4),
                                width: 0.5),
                          ),
                          child: Text(
                            l10n.underConstructionLabel,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  // ── Terminus rail ──────────────────────────────────────
                  if (meta != null)
                    Row(
                      children: [
                        // Terminus dot + name left
                        _terminusDot(color, underConstruction),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            meta.terminus1,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: underConstruction
                                  ? Colors.grey.shade400
                                  : color,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        // Rail line
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child: CustomPaint(
                              size: const Size(double.infinity, 8),
                              painter: _DashedLinePainter(
                                color: underConstruction
                                    ? color.withOpacity(0.25)
                                    : color.withOpacity(0.45),
                              ),
                            ),
                          ),
                        ),
                        // Terminus name right + dot
                        Flexible(
                          child: Text(
                            meta.terminus2,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: underConstruction
                                  ? Colors.grey.shade400
                                  : color,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 4),
                        _terminusDot(color, underConstruction),
                      ],
                    ),
                  const SizedBox(height: 5),
                  // ── Bottom chips ───────────────────────────────────────
                  Row(
                    children: [
                      _miniChip(
                          Icons.place_rounded,
                          '$stations ${l10n.stationsLabel}',
                          underConstruction ? Colors.grey : color),
                      if (meta != null && !underConstruction) ...[
                        const SizedBox(width: 6),
                        _miniChip(Icons.schedule_rounded,
                            '${meta.firstTrain}–${meta.lastTrain}', color),
                        const SizedBox(width: 6),
                        _miniChip(Icons.straighten_rounded,
                            '${meta.distanceKm.toStringAsFixed(0)} km',
                            color),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: color.withOpacity(underConstruction ? 0.3 : 0.5),
                size: 20),
          ],
        ),
      ),
    );
  }

  Widget _miniChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color.withOpacity(0.7)),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _terminusDot(Color color, bool underConstruction) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: underConstruction ? color.withOpacity(0.3) : color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Explore Station Area
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildExploreAreaSection(BuildContext context, AppLocalizations l10n) {
    final isAr = l10n.locale == 'ar';

    // Featured stations with their facility counts
    final featured = <(String, String, int)>[
      (
        'SAFAA HEGAZI',
        isAr ? l10n.metroStationSAFAA_HEGAZI : 'SAFAA HEGAZI',
        82
      ),
      ('KIT KAT', isAr ? l10n.metroStationKIT_KAT : 'KIT KAT', 72),
      ('ABASIA', isAr ? l10n.metroStationABASIA : 'ABASIA', 70),
      ('ABDO BASHA', isAr ? l10n.metroStationABDO_BASHA : 'ABDO BASHA', 56),
      (
        'GAMAL ABD EL-NASSER',
        isAr ? l10n.metroStationGAMAL_ABD_EL_NASSER : 'GAMAL ABD EL-NASSER',
        54
      ),
      ('ATABA', isAr ? l10n.metroStationATABA : 'ATABA', 51),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                _sectionTitle(context, l10n.exploreAreaTitle),
              ],
            ),
            TextButton.icon(
              onPressed: () => Get.to(() => const StationExplorerPage()),
              icon: const Icon(Icons.explore_rounded, size: 14),
              label: Text(l10n.seeAll),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryNile,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            l10n.exploreAreaSubtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: featured.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final (jsonName, displayName, count) = featured[i];
              return _exploreCard(
                jsonName: jsonName,
                displayName: displayName,
                count: count,
                isAr: isAr,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _exploreCard({
    required String jsonName,
    required String displayName,
    required int count,
    required bool isAr,
  }) {
    final imagePath = 'assets/stations/line3/$jsonName.jpg';

    return GestureDetector(
      onTap: () => Get.to(() => StationFacilitiesPage(
            stationNameEN: jsonName,
            stationNameLang: displayName,
          )),
      child: Container(
        width: 140,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Station photo
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              cacheWidth: 280,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A535C), Color(0xFF0C3340)],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.train_rounded,
                      size: 40, color: Colors.white.withOpacity(0.2)),
                ),
              ),
            ),

            // Gradient overlay for text
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.transparent,
                    Colors.black.withOpacity(0.75),
                  ],
                ),
              ),
            ),

            // Top-right count badge
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.place_rounded,
                        size: 11, color: Colors.white),
                    const SizedBox(width: 3),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom station name + subtitle
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isAr ? 'اضغط للاستكشاف' : 'Tap to explore',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Promo carousel
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPromoCarousel(BuildContext context, AppLocalizations l10n) {
    final promos = [
      (
        title: l10n.promoMonthlyTitle,
        subtitle: l10n.promoMonthlySubtitle,
        tag: l10n.promoMonthlyTag,
        data: _promoPrices[0],
      ),
      (
        title: l10n.promoStudentTitle,
        subtitle: l10n.promoStudentSubtitle,
        tag: l10n.promoStudentTag,
        data: _promoPrices[1],
      ),
      (
        title: l10n.promoFamilyTitle,
        subtitle: l10n.promoFamilySubtitle,
        tag: l10n.promoFamilyTag,
        data: _promoPrices[2],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, l10n.subscriptionInfoTitle),
        const SizedBox(height: 12),
        CarouselSlider.builder(
          itemCount: promos.length,
          options: CarouselOptions(
            height: 158,
            viewportFraction: 0.93,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (i, _) => setState(() => _promoPage = i),
          ),
          itemBuilder: (_, i, __) => _PromoCard(
            title: promos[i].title,
            subtitle: promos[i].subtitle,
            tag: promos[i].tag,
            price: promos[i].data.price,
            originalPrice: promos[i].data.original,
            icon: promos[i].data.icon,
            gradient: promos[i].data.gradient,
            buyNowLabel: l10n.buyNowLabel,
            onTap: () => Get.to(() => SubscriptionInfoPage()),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            promos.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _promoPage == i ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _promoPage == i
                    ? AppTheme.primaryNile
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Shimmer skeleton
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
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
  // FAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildFab(AppLocalizations l10n) {
    return Builder(
      builder: (context) => Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isLocating.value
              ? _buildLocationLoadingFab(l10n)
              : _buildLocationFab(context, l10n),
        ),
      ),
    );
  }

  Widget _buildLocationFab(BuildContext context, AppLocalizations l10n) {
    return AnimatedBuilder(
      animation: _fabScale,
      builder: (_, child) =>
          Transform.scale(scale: _fabScale.value, child: child),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentGold.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: AppTheme.accentGold,
          foregroundColor: Colors.white,
          elevation: 6,
          mini: true, // This makes it smaller!
          onPressed: () => _locateMe(context, l10n),
          child: const Icon(Icons.my_location_rounded, size: 18),
        ),
      ),
    );
  }

  Widget _buildLocationLoadingFab(AppLocalizations l10n) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentGold.withOpacity(0.8),
            AppTheme.accentGold,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${l10n.locateMeLabel}...',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section title ────────────────────────────────────────────────────────

  Widget _sectionTitle(BuildContext context, String text) => Text(
        text,
        style: _TS.sectionHeader,
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

  Future<void> _locateMe(BuildContext context, AppLocalizations l10n) async {
    if (_isLocating.value) return;
    _isLocating.value = true;
    HapticFeedback.lightImpact();
    try {
      await _ctrl.updateUserLocation(context);
      final s = _ctrl.depStation.value;
      if (s.isEmpty || !context.mounted) return;
      _snack(context, '${l10n.nearestStationFound}: $s');
    } catch (e) {
      if (!context.mounted) return;
      final msg = e.toString();
      if (msg.contains('disabled')) {
        _snack(context, l10n.locationServicesDisabled, error: true);
      } else if (msg.contains('denied')) {
        _snack(context, l10n.locationPermissionDenied, error: true);
      } else {
        _snack(context, l10n.locationError, error: true);
      }
    } finally {
      _isLocating.value = false;
    }
  }

  Future<void> _findByAddress(
      BuildContext context, AppLocalizations l10n) async {
    HapticFeedback.selectionClick();
    final ok = await _ctrl.updateArrivalFromInput(context, _destCtrl.text);
    if (!context.mounted) return;
    if (!ok) {
      _snack(context, l10n.addressNotFound, error: true);
      return;
    }
    _snack(context, '${l10n.stationFound}: ${_ctrl.arrStation.value}');
  }

  Future<void> _pickFromMap(BuildContext context, AppLocalizations l10n) async {
    final picked = await Get.to<Position?>(() => const LocationPickerPage());
    if (picked == null || !context.mounted) return;
    final ok = await _ctrl.updateArrivalFromPosition(context, picked);
    if (!context.mounted) return;
    if (!ok) {
      _snack(context, l10n.addressNotFound, error: true);
      return;
    }
    _snack(context, '${l10n.stationFound}: ${_ctrl.arrStation.value}');
  }

  void _showInfo(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.appInfoTitle),
        content: Text(l10n.appInfoDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showLangPicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 14),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Text('EN',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
              title: const Text('English'),
              onTap: () {
                _langCtrl.switchLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFF9C4),
                child: Text('AR',
                    style: TextStyle(
                        color: Color(0xFFB8860B), fontWeight: FontWeight.bold)),
              ),
              title: const Text('العربية'),
              onTap: () {
                _langCtrl.switchLanguage('ar');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
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

class _PromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final String price;
  final String originalPrice;
  final IconData icon;
  final List<Color> gradient;
  final String buyNowLabel;
  final VoidCallback onTap;

  const _PromoCard({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.price,
    required this.originalPrice,
    required this.icon,
    required this.gradient,
    required this.buyNowLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.40),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.78),
                      fontSize: 11,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 9),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          originalPrice,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.white.withOpacity(0.45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white.withOpacity(0.25), size: 44),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.35)),
                  ),
                  child: Text(
                    '$buyNowLabel →',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Egyptian-inspired geometric background painter
// ═════════════════════════════════════════════════════════════════════════════

// ── Quick action data class ───────────────────────────────────────────────────

class _QuickAction {
  final IconData icon;
  final String label;
  final String subtitle;
  final String ctaLabel;
  final Color color;
  final VoidCallback onTap;
  final int badge;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.ctaLabel,
    required this.color,
    required this.onTap,
    this.badge = 0,
  });
}

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


// ── Dashed line painter for terminus rail ─────────────────────────────────────

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double x = 0;
    final y = size.height / 2;

    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter old) => old.color != color;
}
