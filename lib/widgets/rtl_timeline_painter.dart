import 'package:flutter/material.dart';

class RTLTimelinePainter extends CustomPainter {
  final bool isRTL;
  final List<Offset> points;
  final Color lineColor;

  RTLTimelinePainter({
    required this.isRTL,
    required this.points,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (isRTL) {
      for (int i = points.length - 1; i >= 0; i--) {
        if (i == points.length - 1) {
          path.moveTo(points[i].dx, points[i].dy);
        } else {
          path.lineTo(points[i].dx, points[i].dy);
        }
      }
    } else {
      path.addPolygon(points, false);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
