import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'homepage.dart';
import 'onboarding_page.dart';

class SplashPage extends StatefulWidget {
  final bool onboardingDone;
  const SplashPage({super.key, required this.onboardingDone});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _glowCtrl;
  late final AnimationController _lineCtrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _lineWidth;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _textCtrl = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _glowCtrl = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _lineCtrl = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: const Interval(0.0, 0.4)),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));
    _lineWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lineCtrl, curve: Curves.easeOut),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    FlutterNativeSplash.remove();
    await Future.delayed(const Duration(milliseconds: 150));
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 750));
    _textCtrl.forward();
    _lineCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1600));
    _navigate();
  }

  void _navigate() {
    if (!mounted) return;
    Get.off(
      () => widget.onboardingDone ? Homepage() : const OnboardingPage(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _glowCtrl.dispose();
    _lineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B33),
      body: Stack(
        children: [
          // Egyptian-themed background
          SizedBox.expand(
            child: AnimatedBuilder(
              animation: _glowCtrl,
              builder: (_, __) => CustomPaint(
                painter: _BackgroundPainter(_glowCtrl.value),
              ),
            ),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing logo
                AnimatedBuilder(
                  animation: Listenable.merge([_logoCtrl, _glowCtrl]),
                  builder: (_, __) {
                    final glow = 0.3 + 0.15 * _glowCtrl.value;
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value.clamp(0.0, 1.0),
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00D4FF).withOpacity(glow),
                                blurRadius: 50,
                                spreadRadius: 8,
                              ),
                              BoxShadow(
                                color: const Color(0xFFF4A11D).withOpacity(glow * 0.5),
                                blurRadius: 80,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/transparent_enhanced_logo_v1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 36),

                // App name + subtitle
                AnimatedBuilder(
                  animation: _textCtrl,
                  builder: (_, __) => SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          // English title
                          const Text(
                            'CAIRO METRO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Arabic subtitle
                          const Text(
                            'مترو القاهرة',
                            style: TextStyle(
                              color: Color(0xFF4DD0E1),
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Animated gold divider line
                          AnimatedBuilder(
                            animation: _lineWidth,
                            builder: (_, __) => Container(
                              width: 140 * _lineWidth.value,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFFF4A11D),
                                    Color(0xFFFFD54F),
                                    Color(0xFFF4A11D),
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom branding
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _textCtrl,
              builder: (_, __) => FadeTransition(
                opacity: _textOpacity,
                child: const Text(
                  'Your guide through the city',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4A6080),
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Background painter ────────────────────────────────────────────────────────

class _BackgroundPainter extends CustomPainter {
  final double t; // 0..1 animated value
  _BackgroundPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Soft radial glow from center
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.9,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF00BCD4).withOpacity(0.07 + 0.03 * t),
            const Color(0xFF0C1B33).withOpacity(0.0),
          ],
          radius: 0.55,
        ).createShader(
            Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.9)),
    );

    // Pyramid silhouettes (bottom)
    final goldFaint = Paint()
      ..color = const Color(0xFFF4A11D).withOpacity(0.055)
      ..style = PaintingStyle.fill;

    _drawPyramid(canvas, size.width * 0.12, size.height, size.width * 0.28,
        size.height * 0.78, size.width * 0.44, size.height, goldFaint);
    _drawPyramid(canvas, size.width * 0.56, size.height, size.width * 0.73,
        size.height * 0.80, size.width * 0.90, size.height, goldFaint);

    // Teal horizontal metro lines (top area, subtle)
    final linePaint = Paint()
      ..color = const Color(0xFF00BCD4).withOpacity(0.07)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 4; i++) {
      final y = size.height * (0.05 + i * 0.04);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Twinkling star dots
    final dotPaint = Paint()
      ..color = const Color(0xFF4DD0E1)
          .withOpacity(0.12 + 0.08 * math.sin(t * math.pi));

    const positions = [
      [0.08, 0.12], [0.92, 0.10], [0.05, 0.60],
      [0.95, 0.65], [0.18, 0.40], [0.82, 0.38],
      [0.50, 0.08], [0.30, 0.88], [0.70, 0.86],
    ];
    for (final p in positions) {
      canvas.drawCircle(
          Offset(size.width * p[0], size.height * p[1]), 2.5, dotPaint);
    }

    // Corner ankh-inspired cross marks (very faint)
    final crossPaint = Paint()
      ..color = const Color(0xFFF4A11D).withOpacity(0.06)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    _drawAnkhCross(canvas, Offset(size.width * 0.07, size.height * 0.10),
        16, crossPaint);
    _drawAnkhCross(canvas, Offset(size.width * 0.93, size.height * 0.10),
        16, crossPaint);
  }

  void _drawPyramid(Canvas canvas, double x1, double y1, double tipX,
      double tipY, double x2, double y2, Paint paint) {
    canvas.drawPath(
      Path()
        ..moveTo(x1, y1)
        ..lineTo(tipX, tipY)
        ..lineTo(x2, y2)
        ..close(),
      paint,
    );
  }

  void _drawAnkhCross(Canvas canvas, Offset center, double size, Paint paint) {
    // Vertical bar
    canvas.drawLine(center.translate(0, -size), center.translate(0, size / 2),
        paint);
    // Horizontal bar
    canvas.drawLine(
        center.translate(-size / 2, -size / 3),
        center.translate(size / 2, -size / 3),
        paint);
    // Circle at top
    canvas.drawCircle(center.translate(0, -size * 0.7), size * 0.3, paint);
  }

  @override
  bool shouldRepaint(_BackgroundPainter old) => old.t != t;
}
