import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:metroappflutter/Controllers/languagecontroller.dart';
import 'package:metroappflutter/Pages/homepage.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

// ── Entry-point helpers ───────────────────────────────────────────────────────

const _kDoneKey = 'onboarding_done';

Future<bool> isOnboardingDone() async {
  final p = await SharedPreferences.getInstance();
  return p.getBool(_kDoneKey) ?? false;
}

Future<void> markOnboardingDone() async {
  final p = await SharedPreferences.getInstance();
  await p.setBool(_kDoneKey, true);
}

// ── Language metadata ─────────────────────────────────────────────────────────

class _Lang {
  final String code;
  final String label;
  final String native;
  final String flag;
  const _Lang(this.code, this.label, this.native, this.flag);
}

const _langs = [
  _Lang('en', 'English', 'English', '🇬🇧'),
  _Lang('ar', 'Arabic', 'العربية', '🇪🇬'),
  _Lang('fr', 'French', 'Français', '🇫🇷'),
  _Lang('de', 'German', 'Deutsch', '🇩🇪'),
  _Lang('es', 'Spanish', 'Español', '🇪🇸'),
  _Lang('it', 'Italian', 'Italiano', '🇮🇹'),
  _Lang('pt', 'Portuguese', 'Português', '🇵🇹'),
  _Lang('ru', 'Russian', 'Русский', '🇷🇺'),
  _Lang('zh', 'Chinese', '中文', '🇨🇳'),
  _Lang('tr', 'Turkish', 'Türkçe', '🇹🇷'),
  _Lang('ja', 'Japanese', '日本語', '🇯🇵'),
];

// ── Page accent colors ────────────────────────────────────────────────────────

const _pageAccents = [
  AppTheme.primaryNile,
  AppTheme.line2,
  AppTheme.accentGold
];

// ── Main widget ───────────────────────────────────────────────────────────────

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _page = 0;
  double _pageOffset = 0.0;

  // Content entrance animation (restarts per page)
  late final AnimationController _enterCtrl;

  // Floating background animation (continuous loop)
  late final AnimationController _floatCtrl;

  // CTA glow pulse on last page
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pageCtrl.addListener(() {
      if (_pageCtrl.hasClients) {
        setState(() => _pageOffset = _pageCtrl.page ?? 0.0);
      }
    });

    // Fire the entrance animation after the first frame so the page
    // is laid out before any stagger animations play.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _enterCtrl.forward();
    });

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _enterCtrl.dispose();
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _next() {
    HapticFeedback.selectionClick();
    if (_page < 2) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 480),
        curve: Curves.easeOutQuint,
      );
      // enterCtrl is handled in onPageChanged after the transition settles.
    } else {
      _finish();
    }
  }

  void _finish() async {
    HapticFeedback.mediumImpact();
    await markOnboardingDone();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => Homepage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _showLanguagePicker() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _LanguagePicker(
        onSelected: (code) {
          Get.find<LanguageController>().switchLanguage(code);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ── Helpers ───────────────────────────────��──────────────────────���────────

  /// Smoothly interpolates the accent color between pages as the user swipes.
  Color _morphedAccent() {
    final base = _pageOffset.floor().clamp(0, 1);
    final next = (base + 1).clamp(0, 2);
    final t = (_pageOffset - base).clamp(0.0, 1.0);
    return Color.lerp(_pageAccents[base], _pageAccents[next], t)!;
  }

  /// Wraps [child] with a scale + opacity + vertical-drift transform so that
  /// pages animate with a "depth" feel as the user swipes: the departing page
  /// shrinks/fades into the background while the arriving page grows forward.
  Widget _depthWrap(int pageIdx, Widget child) {
    final delta = (_pageOffset - pageIdx).clamp(-1.0, 1.0);
    final t = delta.abs();
    final s = 1.0 - 0.07 * t;
    return Opacity(
      opacity: (1.0 - 0.68 * t).clamp(0.0, 1.0),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(s, s, 1.0)
          ..setTranslationRaw(0.0, 30.0 * t, 0.0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.locale == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Start/stop pulse on last page
    if (_page == 2 && !_pulseCtrl.isAnimating) {
      _pulseCtrl.repeat(reverse: true);
    } else if (_page != 2 && _pulseCtrl.isAnimating) {
      _pulseCtrl.stop();
      _pulseCtrl.reset();
    }

    final accent = _morphedAccent();

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.darkBackground : AppTheme.backgroundSand,
      body: Stack(
        children: [
          // ── Morphing background tint ─────────────────────────────────
          // A full-screen top-to-bottom gradient that shifts between page
          // accent colours as the user swipes, giving each page its own feel.
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    accent.withValues(alpha: isDark ? 0.07 : 0.10),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),

          // ── Animated background orbs ─────────────────────────────────
          _BackgroundOrbs(
            pageOffset: _pageOffset,
            floatAnim: _floatCtrl,
            isDark: isDark,
            morphedAccent: accent,
          ),

          // ── Content ──────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ── Top bar ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      _TopButton(
                        icon: Icons.translate_rounded,
                        label: l10n.onboardingLanguagePrompt,
                        onTap: _showLanguagePicker,
                        isDark: isDark,
                      ),
                      const Spacer(),
                      if (_page < 2)
                        _TopButton(
                          icon: null,
                          label: l10n.onboardingSkip,
                          onTap: _finish,
                          isDark: isDark,
                        ),
                    ],
                  ),
                ),

                // ── PageView ─────────────────────────────────────────────
                Expanded(
                  child: PageView(
                    controller: _pageCtrl,
                    onPageChanged: (p) {
                      setState(() => _page = p);
                      // Reset immediately so new-page content starts invisible
                      // while the slide transition is still finishing.
                      // onPageChanged fires at ~midpoint (240 ms); we then
                      // wait ~260 ms for the 480 ms slide to fully settle
                      // before playing the entrance once.
                      _enterCtrl.reset();
                      Future.delayed(const Duration(milliseconds: 260), () {
                        if (!mounted) return;
                        _enterCtrl.duration =
                            const Duration(milliseconds: 520);
                        _enterCtrl.forward();
                      });
                    },
                    children: [
                      _depthWrap(
                        0,
                        _OnboardingStep(
                          enterCtrl: _enterCtrl,
                          illustration:
                              _IllustrationRoute(enterCtrl: _enterCtrl),
                          title: l10n.onboardingTitle1,
                          subtitle: l10n.onboardingSubtitle1,
                          isAr: isAr,
                          isDark: isDark,
                        ),
                      ),
                      _depthWrap(
                        1,
                        _OnboardingStep(
                          enterCtrl: _enterCtrl,
                          illustration: _IllustrationLines(
                              l10n: l10n, enterCtrl: _enterCtrl),
                          title: l10n.onboardingTitle2,
                          subtitle: l10n.onboardingSubtitle2,
                          isAr: isAr,
                          isDark: isDark,
                        ),
                      ),
                      _depthWrap(
                        2,
                        _OnboardingStep(
                          enterCtrl: _enterCtrl,
                          illustration: _IllustrationFeatures(
                              l10n: l10n, enterCtrl: _enterCtrl),
                          title: l10n.onboardingTitle3,
                          subtitle: l10n.onboardingSubtitle3,
                          isAr: isAr,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Page indicators ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final isActive = _page == i;
                      // Use continuous interpolated colour for the active dot.
                      final dotColor = isActive
                          ? accent
                          : (isDark
                              ? AppTheme.darkBorder
                              : Colors.grey.shade300);
                      // Width animates based on how close this dot is to the
                      // current page offset (continuous, not just integer step).
                      final proximity =
                          (1.0 - (_pageOffset - i).abs()).clamp(0.0, 1.0);
                      final dotWidth = 8.0 + 22.0 * proximity;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: dotWidth,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: dotColor,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: accent.withValues(alpha: 0.45),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                ),

                // ── CTA button ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 6, 24, 28),
                  child: _CTAButton(
                    page: _page,
                    isAr: isAr,
                    isDark: isDark,
                    l10n: l10n,
                    pulseCtrl: _pulseCtrl,
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Background gradient orbs ─────────────────────────────────────────────────

class _BackgroundOrbs extends StatelessWidget {
  final double pageOffset;
  final AnimationController floatAnim;
  final bool isDark;
  final Color morphedAccent;

  const _BackgroundOrbs({
    required this.pageOffset,
    required this.floatAnim,
    required this.isDark,
    required this.morphedAccent,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: floatAnim,
      builder: (_, __) {
        final float = math.sin(floatAnim.value * math.pi) * 12;
        return Stack(
          children: [
            // Top-right orb — uses the continuously morphed accent colour
            Positioned(
              top: -60 + float,
              right: -40 - pageOffset * 60,
              child: _Orb(
                size: 300,
                color: morphedAccent
                    .withValues(alpha: isDark ? 0.09 : 0.13),
              ),
            ),
            // Bottom-left orb
            Positioned(
              bottom: size.height * 0.15 - float,
              left: -80 + pageOffset * 40,
              child: _Orb(
                size: 200,
                color:
                    AppTheme.accentGold.withValues(alpha: isDark ? 0.04 : 0.06),
              ),
            ),
            // Center accent orb
            Positioned(
              top: size.height * 0.25 + float * 0.5,
              left: size.width * 0.3 - pageOffset * 30,
              child: _Orb(
                size: 140,
                color: AppTheme.primaryNile
                    .withValues(alpha: isDark ? 0.03 : 0.05),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

// ── Staggered animation helpers ──────────────────────────────────────────────

Animation<double> _staggeredFade(AnimationController ctrl, int index) {
  final start = (index * 0.12).clamp(0.0, 0.6);
  final end = (start + 0.4).clamp(0.0, 1.0);
  return CurvedAnimation(
    parent: ctrl,
    curve: Interval(start, end, curve: Curves.easeOut),
  );
}

Animation<Offset> _staggeredSlide(AnimationController ctrl, int index) {
  final start = (index * 0.12).clamp(0.0, 0.6);
  final end = (start + 0.4).clamp(0.0, 1.0);
  return Tween<Offset>(
    begin: const Offset(0, 0.15),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: ctrl,
    curve: Interval(start, end, curve: Curves.easeOutCubic),
  ));
}

// ── Single onboarding step ──────────────────────────────────────────────────

class _OnboardingStep extends StatelessWidget {
  final AnimationController enterCtrl;
  final Widget illustration;
  final String title;
  final String subtitle;
  final bool isAr;
  final bool isDark;

  const _OnboardingStep({
    required this.enterCtrl,
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.isAr,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Text enters after illustration (index 4+)
    final titleFade = _staggeredFade(enterCtrl, 5);
    final titleSlide = _staggeredSlide(enterCtrl, 5);
    final subtitleFade = _staggeredFade(enterCtrl, 6);
    final subtitleSlide = _staggeredSlide(enterCtrl, 6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Illustration area
          Expanded(
            flex: 5,
            child: Center(child: illustration),
          ),
          // Text area
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                SlideTransition(
                  position: titleSlide,
                  child: FadeTransition(
                    opacity: titleFade,
                    child: Text(
                      title,
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppTheme.darkText
                            : AppTheme.lightTextPrimary,
                        height: 1.2,
                        letterSpacing: -0.5,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SlideTransition(
                  position: subtitleSlide,
                  child: FadeTransition(
                    opacity: subtitleFade,
                    child: Text(
                      subtitle,
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.7,
                        color: isDark
                            ? AppTheme.darkTextSub
                            : AppTheme.lightBodyText,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top bar button ───────────────────────────────────────────────────────────

class _TopButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _TopButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.darkElevated.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? AppTheme.darkBorder
                : AppTheme.primaryNile.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 15,
                  color: isDark ? AppTheme.darkTextSub : AppTheme.primaryNile),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkTextSub : AppTheme.primaryNile,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── CTA Button ───────────────────────────────────────────────────────────────

class _CTAButton extends StatelessWidget {
  final int page;
  final bool isAr;
  final bool isDark;
  final AppLocalizations l10n;
  final AnimationController pulseCtrl;
  final VoidCallback onTap;

  const _CTAButton({
    required this.page,
    required this.isAr,
    required this.isDark,
    required this.l10n,
    required this.pulseCtrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = page == 2;
    return AnimatedBuilder(
      animation: pulseCtrl,
      builder: (_, child) {
        final glowAlpha = isLast ? 0.15 + pulseCtrl.value * 0.15 : 0.0;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: isLast
                ? [
                    BoxShadow(
                      color: AppTheme.accentGold.withValues(alpha: glowAlpha),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: child,
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: DecoratedBox(
            key: ValueKey(page),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLast
                    ? [AppTheme.accentGold, const Color(0xFFF5C842)]
                    : [AppTheme.primaryNile, const Color(0xFF267A85)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: (isLast ? AppTheme.accentGold : AppTheme.primaryNile)
                      .withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(18),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLast
                            ? l10n.onboardingGetStarted
                            : l10n.onboardingNext,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isLast ? Colors.black87 : Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      if (!isLast) ...[
                        const SizedBox(width: 8),
                        Icon(
                          isAr
                              ? Icons.arrow_back_rounded
                              : Icons.arrow_forward_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                      if (isLast) ...[
                        const SizedBox(width: 8),
                        _AnimatedMetroIcon(pulseCtrl: pulseCtrl),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ILLUSTRATION 1: Route Planning
// ═══════════════════════════════════════════════════════════════════════════════

class _IllustrationRoute extends StatelessWidget {
  final AnimationController enterCtrl;
  const _IllustrationRoute({required this.enterCtrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final borderColor = isDark ? AppTheme.darkBorder : Colors.grey.shade100;

    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Mock route card ──────────────────────────────────────────
          SlideTransition(
            position: _staggeredSlide(enterCtrl, 0),
            child: FadeTransition(
              opacity: _staggeredFade(enterCtrl, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryNile
                          .withValues(alpha: isDark ? 0.10 : 0.14),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Top accent gradient bar
                    Container(
                      height: 4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryNile, Color(0xFF267A85)],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          // Departure row
                          _StationRow(
                            icon: Icons.radio_button_on_rounded,
                            color: AppTheme.primaryNile,
                            label: 'Adly Mansour',
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                          // Connector dots
                          Padding(
                            padding: const EdgeInsets.only(left: 19),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                3,
                                (i) => SlideTransition(
                                  position: _staggeredSlide(enterCtrl, 1),
                                  child: FadeTransition(
                                    opacity: _staggeredFade(enterCtrl, 1),
                                    child: Container(
                                      width: 2,
                                      height: 6,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppTheme.primaryNile
                                                .withValues(alpha: 0.6),
                                            AppTheme.line2
                                                .withValues(alpha: 0.6),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Arrival row
                          _StationRow(
                            icon: Icons.location_on_rounded,
                            color: AppTheme.line2,
                            label: 'Sadat',
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                          const SizedBox(height: 14),
                          // ── Badges row ────────────────────────────────
                          SlideTransition(
                            position: _staggeredSlide(enterCtrl, 2),
                            child: FadeTransition(
                              opacity: _staggeredFade(enterCtrl, 2),
                              child: Row(
                                children: [
                                  // "Best" badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppTheme.accentGold,
                                          Color(0xFFF5C842)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.accentGold
                                              .withValues(alpha: 0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star_rounded,
                                            size: 10, color: Colors.white),
                                        SizedBox(width: 3),
                                        Text(
                                          'Best',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // "Fastest" badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTheme.success
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppTheme.success
                                            .withValues(alpha: 0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.bolt_rounded,
                                            size: 10, color: AppTheme.success),
                                        const SizedBox(width: 2),
                                        Text(
                                          'Fastest',
                                          style: TextStyle(
                                            color: AppTheme.success,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // ── Summary chips ─────────────────────────────
                          SlideTransition(
                            position: _staggeredSlide(enterCtrl, 3),
                            child: FadeTransition(
                              opacity: _staggeredFade(enterCtrl, 3),
                              child: Row(
                                children: [
                                  _SummaryChip(
                                    icon: Icons.train_rounded,
                                    label: '14',
                                    color: AppTheme.primaryNile,
                                    isDark: isDark,
                                  ),
                                  const SizedBox(width: 8),
                                  _SummaryChip(
                                    icon: Icons.access_time_rounded,
                                    label: '42 min',
                                    color: AppTheme.line3,
                                    isDark: isDark,
                                  ),
                                  const SizedBox(width: 8),
                                  _SummaryChip(
                                    icon: Icons.payments_rounded,
                                    label: '10 EGP',
                                    color: AppTheme.accentGold,
                                    isDark: isDark,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StationRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool isDark;
  final Color borderColor;

  const _StationRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkElevated : const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ILLUSTRATION 2: Metro Lines
// ═══════════════════════════════════════════════════════════════════════════════

class _IllustrationLines extends StatelessWidget {
  final AppLocalizations l10n;
  final AnimationController enterCtrl;
  const _IllustrationLines({required this.l10n, required this.enterCtrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Line rows with staggered entrance
          _AnimatedLineRow(
            enterCtrl: enterCtrl,
            index: 0,
            color: AppTheme.line1,
            label: l10n.onboardingLine1,
            stations: 5,
            transferAt: -1,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _AnimatedLineRow(
            enterCtrl: enterCtrl,
            index: 1,
            color: AppTheme.line2,
            label: l10n.onboardingLine2,
            stations: 4,
            transferAt: 2,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _AnimatedLineRow(
            enterCtrl: enterCtrl,
            index: 2,
            color: AppTheme.line3,
            label: l10n.onboardingLine3,
            stations: 5,
            transferAt: 3,
            isDark: isDark,
          ),
          const SizedBox(height: 28),
          // Transfer legend
          SlideTransition(
            position: _staggeredSlide(enterCtrl, 4),
            child: FadeTransition(
              opacity: _staggeredFade(enterCtrl, 4),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.darkCard.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppTheme.darkBorder
                        : AppTheme.primaryNile.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppTheme.darkCard : Colors.white,
                        border: Border.all(
                          color: AppTheme.primaryNile.withValues(alpha: 0.6),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryNile.withValues(alpha: 0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.onboardingTransfer,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.darkTextSub
                            : AppTheme.lightBodyText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedLineRow extends StatelessWidget {
  final AnimationController enterCtrl;
  final int index;
  final Color color;
  final String label;
  final int stations;
  final int transferAt; // -1 = no transfer
  final bool isDark;

  const _AnimatedLineRow({
    required this.enterCtrl,
    required this.index,
    required this.color,
    required this.label,
    required this.stations,
    required this.transferAt,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _staggeredSlide(enterCtrl, index),
      child: FadeTransition(
        opacity: _staggeredFade(enterCtrl, index),
        child: Row(
          children: [
            // Metro line visualization
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.darkCard.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(alpha: 0.15),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Track line
                    Positioned(
                      left: 16,
                      right: 16,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Station dots
                    Positioned(
                      left: 12,
                      right: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(stations, (i) {
                          final isTransfer = i == transferAt;
                          if (isTransfer) {
                            return Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    isDark ? AppTheme.darkCard : Colors.white,
                                border: Border.all(color: color, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.35),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Line label badge
            Container(
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color.withValues(alpha: 0.25),
                  width: 0.5,
                ),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ILLUSTRATION 3: App Features
// ═══════════════════════════════════════════════════════════════════════════════

class _IllustrationFeatures extends StatelessWidget {
  final AppLocalizations l10n;
  final AnimationController enterCtrl;
  const _IllustrationFeatures({required this.l10n, required this.enterCtrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: 2 feature cards
          Row(
            children: [
              Expanded(
                child: _FeatureCard(
                  enterCtrl: enterCtrl,
                  index: 0,
                  icon: Icons.near_me_rounded,
                  label: l10n.nearestStationLabel,
                  color: AppTheme.primaryNile,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FeatureCard(
                  enterCtrl: enterCtrl,
                  index: 1,
                  icon: Icons.map_rounded,
                  label: l10n.metroMapLabel,
                  color: AppTheme.line3,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Bottom row: 2 feature cards (new features)
          Row(
            children: [
              Expanded(
                child: _FeatureCard(
                  enterCtrl: enterCtrl,
                  index: 2,
                  icon: Icons.accessible_rounded,
                  label: l10n.accessibleRoute,
                  color: const Color(0xFF5C6BC0),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FeatureCard(
                  enterCtrl: enterCtrl,
                  index: 3,
                  icon: Icons.swap_horiz_rounded,
                  label: l10n.onboardingTransfer,
                  color: AppTheme.accentGold,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final AnimationController enterCtrl;
  final int index;
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _FeatureCard({
    required this.enterCtrl,
    required this.index,
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _staggeredSlide(enterCtrl, index),
      child: FadeTransition(
        opacity: _staggeredFade(enterCtrl, index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color.withValues(alpha: 0.18),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isDark ? 0.08 : 0.10),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with gradient background
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.06),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
                  height: 1.3,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Animated metro icon (CTA button last page) ───────────────────────────────

class _AnimatedMetroIcon extends StatelessWidget {
  final AnimationController pulseCtrl;
  const _AnimatedMetroIcon({required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseCtrl,
      builder: (_, __) {
        final t = pulseCtrl.value; // 0 → 1 → 0 (reverse repeat)
        // Train oscillates slightly forward (right) on the beat
        final dx = t * 2.5;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Speed streak lines — grow and fade in sync with the pulse
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 8.0 + t * 5.0,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.black87.withValues(alpha: 0.35 + t * 0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  width: 5.0 + t * 3.5,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.black87.withValues(alpha: 0.25 + t * 0.2),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            // Metro/subway icon that glides forward on the beat
            Transform.translate(
              offset: Offset(dx, 0),
              child: const Icon(
                Icons.directions_subway_rounded,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Language picker sheet ────────────────────────────────────────────────────

class _LanguagePicker extends StatelessWidget {
  final ValueChanged<String> onSelected;
  const _LanguagePicker({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final current = l10n.locale;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
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
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 14, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBorder : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: [
                Icon(Icons.translate_rounded,
                    size: 20,
                    color:
                        isDark ? AppTheme.darkTextSub : AppTheme.primaryNile),
                const SizedBox(width: 8),
                Text(
                  l10n.onboardingLanguagePrompt,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppTheme.darkBorder : Colors.grey.shade200,
          ),
          // Language grid
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: Builder(builder: (ctx) {
              // Compute aspect ratio so cells are always at least 60 dp tall,
              // regardless of screen width. Accounts for sheet margins (24 dp),
              // grid padding (32 dp) and column gap (10 dp).
              final screenW = MediaQuery.sizeOf(ctx).width;
              final cellW = (screenW - 24 - 32 - 10) / 2;
              final ratio = (cellW / 62).clamp(1.8, 3.8);
              return GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: ratio,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _langs.length,
              itemBuilder: (_, i) {
                final lang = _langs[i];
                final isActive = lang.code == current;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelected(lang.code);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.primaryNile.withValues(alpha: 0.10)
                          : (isDark ? AppTheme.darkCard : Colors.grey.shade50),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive
                            ? AppTheme.primaryNile.withValues(alpha: 0.5)
                            : (isDark
                                ? AppTheme.darkBorder
                                : Colors.grey.shade200),
                        width: isActive ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(lang.flag, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                lang.native,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? AppTheme.primaryNile
                                      : (isDark
                                          ? AppTheme.darkText
                                          : AppTheme.lightTextPrimary),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                lang.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? AppTheme.darkTextTertiary
                                      : Colors.grey.shade500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isActive)
                          Icon(Icons.check_circle_rounded,
                              color: AppTheme.primaryNile, size: 18),
                      ],
                    ),
                  ),
                );
              },
            );   // end GridView.builder (Builder return)
            }),  // end Builder
          ),     // end ConstrainedBox child
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
