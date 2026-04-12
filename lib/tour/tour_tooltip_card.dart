import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/languagecontroller.dart';
import '../core/theme/app_theme.dart';
import 'tour_l10n.dart';
import 'tour_step.dart';

// ── Layout constants ──────────────────────────────────────────────────────────

const double _kHPad = 16.0;
const double _kGap = 14.0;
const double _kArrowW = 22.0;
const double _kArrowH = 9.0;

/// Floating tooltip card positioned above or below the spotlit widget.
///
/// Positioning logic:
///   • If enough space BELOW the spotlight  → card appears below with an
///     upward-pointing arrow.
///   • Otherwise                            → card appears above with a
///     downward-pointing arrow.
///   • Welcome step (no target)             → card centred vertically.
class TourTooltipCard extends StatelessWidget {
  final TourStep step;

  /// 0-based step index (0 = welcome, 1..N = real steps).
  final int stepIndex;
  final int totalSteps;

  /// Current animated spotlight rectangle in global coordinates.
  final Rect spotRect;
  final Size screenSize;
  final EdgeInsets safeArea;

  final VoidCallback onNext;
  final VoidCallback onSkip;

  const TourTooltipCard({
    super.key,
    required this.step,
    required this.stepIndex,
    required this.totalSteps,
    required this.spotRect,
    required this.screenSize,
    required this.safeArea,
    required this.onNext,
    required this.onSkip,
  });

  // Estimated card height for placement decision (generous upper bound).
  static const double _estimatedCardH = 210.0;

  bool get _placeBelow {
    if (step.isWelcome) return false;
    if (step.forceBelow) return true;
    final spaceBelow = screenSize.height - spotRect.bottom - safeArea.bottom;
    return spaceBelow >= _estimatedCardH + _kGap + _kArrowH + 20;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Vertical positioning ────────────────────────────────────────────────
    double? top;
    double? bottom;

    if (step.isWelcome) {
      top = (screenSize.height - _estimatedCardH) / 2 - 30;
      top = top.clamp(safeArea.top + 12, screenSize.height - _estimatedCardH - 12);
    } else if (_placeBelow) {
      top = spotRect.bottom + _kGap;
      top = top.clamp(safeArea.top + 8, screenSize.height - _estimatedCardH - safeArea.bottom - 8);
    } else {
      // Place above: anchor from bottom so the card grows upward and fits
      // regardless of its actual height.
      bottom = screenSize.height - spotRect.top + _kGap;
      bottom = bottom.clamp(safeArea.bottom + 8, screenSize.height - safeArea.top - 8);
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: _kHPad,
      right: _kHPad,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Arrow pointer above card (when card is below spotlight)
          if (!step.isWelcome && _placeBelow)
            _ArrowWidget(pointsUp: true, isDark: isDark),

          _CardBody(
            step: step,
            stepIndex: stepIndex,
            totalSteps: totalSteps,
            isDark: isDark,
            onNext: onNext,
            onSkip: onSkip,
          ),

          // Arrow pointer below card (when card is above spotlight)
          if (!step.isWelcome && !_placeBelow)
            _ArrowWidget(pointsUp: false, isDark: isDark),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card body
// ─────────────────────────────────────────────────────────────────────────────

class _CardBody extends StatelessWidget {
  final TourStep step;
  final int stepIndex;
  final int totalSteps;
  final bool isDark;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _CardBody({
    required this.step,
    required this.stepIndex,
    required this.totalSteps,
    required this.isDark,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final textColor = isDark ? AppTheme.darkText : AppTheme.lightTextPrimary;
    final subColor = isDark ? AppTheme.darkTextSub : const Color(0xFF607D8B);
    final isWelcome = step.isWelcome;
    final isLast = stepIndex == totalSteps - 1;

    // Resolve localised strings from TourL10n.
    final locale = Get.find<LanguageController>().selectedLanguage.value;
    final titleText = TourL10n.title(step.stepId, locale);
    final descText = TourL10n.description(step.stepId, locale);
    final isRtl = locale == 'ar';
    final arrow = isRtl ? ' ←' : '  →';

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1120).withValues(alpha:isDark ? 0.55 : 0.16),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppTheme.primaryNile.withValues(alpha:isDark ? 0.12 : 0.06),
            blurRadius: 20,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top gradient accent strip ────────────────────────────────
            Container(
              height: 3.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryNile, AppTheme.line3],
                  stops: [0.0, 1.0],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Step counter + skip link ─────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isWelcome)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryNile.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            TourL10n.stepLabel(
                                stepIndex, totalSteps - 1, locale),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryNile,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onSkip,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Text(
                            TourL10n.ui('skip', locale),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: subColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Welcome icon ──────────────────────────────────────
                  if (isWelcome) ...[
                    Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryNile, AppTheme.line3],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryNile.withValues(alpha:0.32),
                              blurRadius: 18,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.directions_subway_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ── Title ─────────────────────────────────────────────
                  Text(
                    titleText,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ── Description ───────────────────────────────────────
                  Text(
                    descText,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.55,
                      color: subColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Progress dots + action button ─────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isWelcome)
                        _ProgressDots(
                          currentStep: stepIndex,
                          totalSteps: totalSteps,
                        )
                      else
                        // Subtle brand label on welcome step
                        Text(
                          'Cairo Metro Navigator',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppTheme.primaryNile.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      const Spacer(),
                      _ActionButton(
                        label: isWelcome
                            ? '${TourL10n.ui('start', locale)}$arrow'
                            : isLast
                                ? '${TourL10n.ui('done', locale)}  ✓'
                                : '${TourL10n.ui('next', locale)}$arrow',
                        onTap: onNext,
                      ),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated progress dots (pill-shaped active, circle inactive)
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressDots extends StatelessWidget {
  /// 1-based index of the current visible step (step 0 = welcome, hidden).
  final int currentStep;
  final int totalSteps;

  const _ProgressDots({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    final count = totalSteps - 1; // exclude welcome step from dots
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = (i + 1) == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(right: 5),
          width: active ? 20.0 : 6.0,
          height: 6.0,
          decoration: BoxDecoration(
            color: active
                ? AppTheme.primaryNile
                : AppTheme.primaryNile.withValues(alpha:0.18),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CTA button
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryNile, Color(0xFF1B8A96)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryNile.withValues(alpha:0.38),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Directional arrow connecting card to spotlight
// ─────────────────────────────────────────────────────────────────────────────

class _ArrowWidget extends StatelessWidget {
  final bool pointsUp;
  final bool isDark;

  const _ArrowWidget({required this.pointsUp, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(_kArrowW, _kArrowH),
      painter: _ArrowPainter(
        pointsUp: pointsUp,
        color: isDark ? AppTheme.darkCard : Colors.white,
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final bool pointsUp;
  final Color color;

  const _ArrowPainter({required this.pointsUp, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (pointsUp) {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ArrowPainter old) =>
      old.pointsUp != pointsUp || old.color != color;
}
