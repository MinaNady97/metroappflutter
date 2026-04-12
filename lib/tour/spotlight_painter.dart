import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Paints a full-screen dark overlay with a rounded-rect spotlight cutout.
///
/// The cutout is created by subtracting the spotlight rectangle from the
/// full-screen rectangle using [PathOperation.difference]. Two rings are then
/// drawn over the cutout edge: a blurred outer glow and a crisp inner border —
/// giving the spotlight a premium "lit" appearance.
class SpotlightPainter extends CustomPainter {
  final Rect spotRect;
  final double borderRadius;

  /// Opacity of the dark overlay outside the spotlight [0.0–1.0].
  final double overlayOpacity;

  const SpotlightPainter({
    required this.spotRect,
    this.borderRadius = 18.0,
    this.overlayOpacity = 0.74,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ── 1. Dark overlay with rounded-rect cutout ──────────────────────────
    final overlayPaint = Paint()
      ..color = const Color(0xFF0B1120).withValues(alpha: overlayOpacity);

    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(spotRect, Radius.circular(borderRadius)),
      );

    canvas.drawPath(
      Path.combine(PathOperation.difference, fullPath, holePath),
      overlayPaint,
    );

    // ── 2. Blurred outer glow ring (teal brand colour) ────────────────────
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          spotRect.inflate(4), Radius.circular(borderRadius + 4)),
      Paint()
        ..color = const Color(0xFF2EACBA).withValues(alpha: 0.20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );

    // ── 3. Crisp inner border ────────────────────────────────────────────
    canvas.drawRRect(
      RRect.fromRectAndRadius(spotRect, Radius.circular(borderRadius)),
      Paint()
        ..color = const Color(0xFF2EACBA).withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
  }

  @override
  bool shouldRepaint(SpotlightPainter old) =>
      old.spotRect != spotRect || old.overlayOpacity != overlayOpacity;
}

/// Paints an expanding pulse ring that radiates outward from the spotlight edge.
/// Used as a repeating animation layer above the spotlight to draw the user's eye.
class PulseRingPainter extends CustomPainter {
  final Rect rect;
  final double progress; // 0.0 → 1.0 (repeating)
  final double borderRadius;

  const PulseRingPainter({
    required this.rect,
    required this.progress,
    this.borderRadius = 18.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = 1.0 + progress * 0.09;
    final opacity = (1.0 - progress) * 0.40;

    final scaledRect = Rect.fromCenter(
      center: rect.center,
      width: rect.width * scale,
      height: rect.height * scale,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(scaledRect, Radius.circular(borderRadius + 6)),
      Paint()
        ..color = const Color(0xFF2EACBA).withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(PulseRingPainter old) =>
      old.progress != progress || old.rect != rect;
}
