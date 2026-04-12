import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'spotlight_painter.dart';
import 'tour_controller.dart';
import 'tour_step.dart';
import 'tour_tooltip_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TourOverlayWidget
//
// Injected via OverlayEntry at the ROOT overlay level, so it survives
// navigator push/pop transitions (e.g. Homepage → Routepage demo).
//
// Animation breakdown:
//   _spotCtrl  — spotlight rect morphing between steps (380 ms, easeInOutCubic)
//   _tipCtrl   — tooltip entrance: fade + upward slide (290 ms, easeOut)
//   _pulseCtrl — repeating pulse ring radiating from spotlight edge (1 600 ms)
// ─────────────────────────────────────────────────────────────────────────────

class TourOverlayWidget extends StatefulWidget {
  const TourOverlayWidget({super.key});

  @override
  State<TourOverlayWidget> createState() => _TourOverlayWidgetState();
}

class _TourOverlayWidgetState extends State<TourOverlayWidget>
    with TickerProviderStateMixin {
  // ── Animation controllers ────────────────────────────────────────────────
  late final AnimationController _spotCtrl;
  late final CurvedAnimation _spotCurve;

  late final AnimationController _tipCtrl;
  late final CurvedAnimation _tipCurve;

  late final AnimationController _pulseCtrl;

  // ── Spotlight rect tracking ───────────────────────────────────────────────
  Rect _fromRect = Rect.zero;
  Rect _toRect = Rect.zero;

  // Cached screen size — updated on every build() call.
  Size _screenSize = Size.zero;

  // ── Tooltip visibility ────────────────────────────────────────────────────
  bool _showTooltip = false;

  /// The step index that is currently being rendered (may lag behind
  /// [TourController.currentStep] during the spotlight morph animation).
  int _displayedStep = 0;

  late final TourController _ctrl;

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<TourController>();

    _spotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _spotCurve = CurvedAnimation(
      parent: _spotCtrl,
      curve: Curves.easeInOutCubic,
    );

    _tipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 290),
    );
    _tipCurve = CurvedAnimation(
      parent: _tipCtrl,
      curve: Curves.easeOut,
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    // React to every step change from the controller.
    ever(_ctrl.currentStep, _onStepChanged);

    // Kick-off the first step after the first frame so that widget keys
    // are already attached (findRenderObject works).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _ctrl.currentStep.value >= 0) {
        _onStepChanged(_ctrl.currentStep.value);
      }
    });
  }

  @override
  void dispose() {
    _spotCtrl.dispose();
    _spotCurve.dispose();
    _tipCtrl.dispose();
    _tipCurve.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Step transition
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onStepChanged(int stepIndex) async {
    if (!mounted || stepIndex < 0) return;

    final step = TourController.steps[stepIndex];

    // ── Scroll to bring the target widget into view ────────────────────────
    if (step.scrollToTarget && step.targetKey?.currentContext != null) {
      // Clear the previous spotlight immediately so no stale border is visible
      // while the page scrolls.
      setState(() {
        _showTooltip = false;
        _fromRect = Rect.zero;
        _toRect = Rect.zero;
      });

      // Small pause so the cleared overlay repaints before the scroll starts.
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;

      try {
        // alignment: 0.45 → widget's top lands at ~45 % of the viewport,
        // i.e. in the lower half.  That leaves enough room above for the
        // tooltip card, which _placeBelow will then position above the
        // spotlight rather than below it.
        await Scrollable.ensureVisible(
          step.targetKey!.currentContext!,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeInOut,
          alignment: 0.45,
        );
      } catch (_) {
        // Widget may not be inside a Scrollable — ignore.
      }
      if (!mounted) return;
      // One extra frame so the layout is stable after scrolling.
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
    }

    final newRect = _computeRect(step);

    // For the very first spotlight step (0 → 1), "grow" the spotlight out of
    // the target's centre rather than sweeping in from the screen corner.
    final Rect startRect = (_toRect == Rect.zero && !step.isWelcome && newRect != Rect.zero)
        ? Rect.fromCenter(center: newRect.center, width: 0, height: 0)
        : _toRect;

    setState(() {
      _fromRect = startRect;
      _toRect = newRect;
      _showTooltip = false;
      _displayedStep = stepIndex;
    });

    // 1. Morph the spotlight.
    _spotCtrl.forward(from: 0);

    // 2. Slide in the tooltip after the morph is nearly complete.
    Future.delayed(const Duration(milliseconds: 430), () {
      if (mounted) {
        setState(() => _showTooltip = true);
        _tipCtrl.forward(from: 0);
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  Rect _computeRect(TourStep step) {
    if (step.isWelcome) return Rect.zero;
    final renderBox =
        step.targetKey!.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return Rect.zero;
    final offset = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;

    // Cap the spotlight height so the tooltip can always fit below the cutout.
    if (step.maxSpotHeight != null && size.height > step.maxSpotHeight!) {
      size = Size(size.width, step.maxSpotHeight!);
    }

    final inflated = (offset & size).inflate(step.padding);

    // Clamp to screen bounds so the border is never clipped by the edge.
    // Use a small inset (4 px) so the stroke is fully inside the canvas.
    const edge = 4.0;
    final sw = _screenSize.width;
    final sh = _screenSize.height;
    if (sw == 0 || sh == 0) return inflated;
    return Rect.fromLTRB(
      inflated.left.clamp(edge, sw - edge),
      inflated.top.clamp(edge, sh - edge),
      inflated.right.clamp(edge, sw - edge),
      inflated.bottom.clamp(edge, sh - edge),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_ctrl.isActive.value || _ctrl.currentStep.value < 0) {
        return const SizedBox.shrink();
      }

      if (_displayedStep >= TourController.steps.length) {
        return const SizedBox.shrink();
      }

      final step = TourController.steps[_displayedStep];
      final mediaQuery = MediaQuery.of(context);
      final screenSize = mediaQuery.size;
      final safeArea = mediaQuery.padding;
      _screenSize = screenSize; // keep in sync for _computeRect

      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // ── Layer 1: Full-screen tap absorber ────────────────────────
            // Placed first so it only catches taps that the tooltip (layer 4)
            // does not consume.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {}, // absorb silently
                child: const SizedBox.expand(),
              ),
            ),

            // ── Layer 2: Spotlight overlay (visual, ignores pointer) ──────
            IgnorePointer(
              child: step.isWelcome
                  ? _buildWelcomeOverlay()
                  : _buildSpotlightOverlay(screenSize),
            ),

            // ── Layer 3: Pulse ring (visual, ignores pointer) ─────────────
            if (!step.isWelcome && _toRect != Rect.zero)
              IgnorePointer(
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, __) => CustomPaint(
                    painter: PulseRingPainter(
                      rect: _toRect,
                      progress: _pulseCtrl.value,
                    ),
                    size: screenSize,
                  ),
                ),
              ),

            // ── Layer 4: Tooltip card (top — receives taps first) ─────────
            if (_showTooltip)
              AnimatedBuilder(
                animation: _tipCurve,
                builder: (_, child) => Opacity(
                  opacity: _tipCurve.value,
                  child: Transform.translate(
                    offset: Offset(0, 14 * (1 - _tipCurve.value)),
                    child: child,
                  ),
                ),
                child: TourTooltipCard(
                  step: step,
                  stepIndex: _displayedStep,
                  totalSteps: TourController.steps.length,
                  // Use the final target rect so the tooltip is always
                  // positioned relative to the fully-morphed spotlight.
                  spotRect: _toRect,
                  screenSize: screenSize,
                  safeArea: safeArea,
                  onNext: _ctrl.next,
                  onSkip: _ctrl.skip,
                ),
              ),
          ],
        ),
      );
    });
  }

  // ── Welcome step: full-screen fade-in overlay ─────────────────────────────

  Widget _buildWelcomeOverlay() {
    return AnimatedBuilder(
      animation: _spotCurve,
      builder: (_, __) => Container(
        color: const Color(0xFF0B1120).withValues(alpha: 0.78 * _spotCurve.value),
      ),
    );
  }

  // ── Spotlight overlay with animated rect morph ────────────────────────────

  Widget _buildSpotlightOverlay(Size screenSize) {
    return AnimatedBuilder(
      animation: _spotCurve,
      builder: (_, __) {
        // When _toRect is zero (widget not yet in tree), show a plain dark overlay.
        if (_toRect == Rect.zero) {
          return Container(
            color: const Color(0xFF0B1120).withValues(alpha: 0.74),
          );
        }

        final animRect =
            RectTween(begin: _fromRect, end: _toRect).lerp(_spotCurve.value)!;

        return CustomPaint(
          painter: SpotlightPainter(spotRect: animRect),
          size: screenSize,
        );
      },
    );
  }
}
