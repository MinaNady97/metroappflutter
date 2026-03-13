import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../domain/entities/metro_line.dart';
import '../domain/entities/station.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

Color lineThemeColor(MetroLine line) {
  switch (line.id) {
    case 'L1':
      return AppTheme.line1;
    case 'L2':
      return AppTheme.line2;
    case 'L3':
    case 'L3A':
    case 'L3B':
      return AppTheme.line3;
    case 'LRT_MAIN':
    case 'LRT_BRANCH_NAC':
    case 'LRT_BRANCH_10TH':
      return AppTheme.lrt;
    default:
      return line.color;
  }
}

Color stationThemeColor(Station station) {
  for (final lid in station.lineIds) {
    switch (lid) {
      case 'L1':
        return AppTheme.line1;
      case 'L2':
        return AppTheme.line2;
      case 'L3':
      case 'L3A':
      case 'L3B':
        return AppTheme.line3;
      case 'LRT_MAIN':
      case 'LRT_BRANCH_NAC':
      case 'LRT_BRANCH_10TH':
        return AppTheme.lrt;
    }
  }
  return AppTheme.primaryNile;
}

String lineVisKey(MetroLine line) {
  if (line.id == 'L3A' || line.id == 'L3B') return 'L3';
  if (line.id.startsWith('LRT')) return 'LRT';
  return line.id;
}

bool isStationVisible(Station s, Set<String> vis) {
  return s.lineIds.any((lid) {
    if (lid.startsWith('LRT')) return vis.contains('LRT');
    if (lid == 'L3A' || lid == 'L3B') return vis.contains('L3');
    return vis.contains(lid);
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Bounds & projection — computed once, shared by everything
// ─────────────────────────────────────────────────────────────────────────────

class MapBounds {
  final double minLat, maxLat, minLng, maxLng;
  final double canvasW, canvasH;
  static const double padding = 180.0;

  MapBounds._({
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.canvasW,
    required this.canvasH,
  });

  factory MapBounds.fromStations(Iterable<Station> stations) {
    double mnLat = double.infinity, mxLat = -double.infinity;
    double mnLng = double.infinity, mxLng = -double.infinity;
    for (final s in stations) {
      if (s.latitude < mnLat) mnLat = s.latitude;
      if (s.latitude > mxLat) mxLat = s.latitude;
      if (s.longitude < mnLng) mnLng = s.longitude;
      if (s.longitude > mxLng) mxLng = s.longitude;
    }
    final latSpan = mxLat - mnLat;
    final lngSpan = mxLng - mnLng;
    final fMinLat = mnLat - latSpan * 0.10;
    final fMaxLat = mxLat + latSpan * 0.10;
    final fMinLng = mnLng - lngSpan * 0.10;
    final fMaxLng = mxLng + lngSpan * 0.10;
    return MapBounds._(
      minLat: fMinLat,
      maxLat: fMaxLat,
      minLng: fMinLng,
      maxLng: fMaxLng,
      canvasW: (fMaxLng - fMinLng) * 3600 + padding * 2,
      canvasH: (fMaxLat - fMinLat) * 3600 + padding * 2,
    );
  }

  Size get size => Size(canvasW, canvasH);

  Offset project(double lat, double lng) {
    final x =
        padding + ((lng - minLng) / (maxLng - minLng)) * (canvasW - padding * 2);
    final y = padding +
        ((1 - (lat - minLat) / (maxLat - minLat))) * (canvasH - padding * 2);
    return Offset(x, y);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pre-computed caches — built once after data loads
// ─────────────────────────────────────────────────────────────────────────────

/// Build Catmull-Rom spline path for a line from pre-computed station positions.
Path? buildLinePath(MetroLine line, Map<String, Offset> positions) {
  final points = <Offset>[];
  for (final sid in line.stationIds) {
    final pos = positions[sid];
    if (pos != null) points.add(pos);
  }
  if (points.length < 2) return null;

  final path = Path()..moveTo(points.first.dx, points.first.dy);
  if (points.length == 2) {
    path.lineTo(points.last.dx, points.last.dy);
  } else {
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i + 2 < points.length ? points[i + 2] : points[i + 1];
      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
  }
  return path;
}

/// Sample 101 equidistant positions along a path for O(1) train-dot lookup.
List<Offset> samplePathPositions(Path path, {int count = 101}) {
  final metrics = path.computeMetrics().toList();
  if (metrics.isEmpty) return const [];
  final total = metrics.fold<double>(0, (s, m) => s + m.length);
  if (total <= 0) return const [];

  final samples = <Offset>[];
  for (int i = 0; i < count; i++) {
    final dist = (i / (count - 1)) * total;
    double consumed = 0;
    for (final m in metrics) {
      if (consumed + m.length >= dist) {
        final pos = m.getTangentForOffset(dist - consumed)?.position;
        if (pos != null) samples.add(pos);
        break;
      }
      consumed += m.length;
    }
  }
  return samples;
}

// ─────────────────────────────────────────────────────────────────────────────
// STATIC PAINTER — grid, lines, stations, labels
//
// Only repaints when data/filters/entrance change.
// After entrance completes, this layer is frozen — zero per-frame cost.
// ─────────────────────────────────────────────────────────────────────────────

class MetroMapStaticPainter extends CustomPainter {
  final List<MetroLine> lines;
  final Map<String, Station> stationMap;
  final Map<String, Offset> stationPositions;
  final Map<String, Path> linePaths;
  final String languageCode;
  final Set<String> visibleLineIds;
  final double entranceProgress;
  final Size canvasSize;

  MetroMapStaticPainter({
    required this.lines,
    required this.stationMap,
    required this.stationPositions,
    required this.linePaths,
    required this.languageCode,
    required this.visibleLineIds,
    required this.entranceProgress,
    required this.canvasSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas);
    _drawLineGlows(canvas);
    _drawLineStrokes(canvas);
    _drawStationDots(canvas);
    _drawLabels(canvas);
  }

  // ── Grid ─────────────────────────────────────────────────────────────────

  void _drawGrid(Canvas canvas) {
    final gridPaint = Paint()
      ..color = const Color(0x06FFFFFF)
      ..strokeWidth = 1;
    const step = 160.0;
    for (double x = 0; x < canvasSize.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, canvasSize.height), gridPaint);
    }
    for (double y = 0; y < canvasSize.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(canvasSize.width, y), gridPaint);
    }
  }

  // ── Line glows ───────────────────────────────────────────────────────────

  void _drawLineGlows(Canvas canvas) {
    for (final line in lines) {
      if (!visibleLineIds.contains(lineVisKey(line))) continue;
      final path = linePaths[line.id];
      if (path == null) continue;
      final c = lineThemeColor(line);
      final paint = Paint()
        ..color = Color.fromRGBO(c.red, c.green, c.blue, 0.20)
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      final trimmed = _trimPath(path, entranceProgress);
      if (trimmed != null) canvas.drawPath(trimmed, paint);
    }
  }

  // ── Line strokes ─────────────────────────────────────────────────────────

  void _drawLineStrokes(Canvas canvas) {
    for (final line in lines) {
      if (!visibleLineIds.contains(lineVisKey(line))) continue;
      final path = linePaths[line.id];
      if (path == null) continue;
      final c = lineThemeColor(line);
      final isLrt = line.id.startsWith('LRT');
      final isBranch = line.id == 'L3A' ||
          line.id == 'L3B' ||
          line.id == 'LRT_BRANCH_NAC' ||
          line.id == 'LRT_BRANCH_10TH';
      final paint = Paint()
        ..color = c
        ..strokeWidth = isLrt ? 4.0 : (isBranch ? 4.5 : 6.0)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final trimmed = _trimPath(path, entranceProgress);
      if (trimmed != null) canvas.drawPath(trimmed, paint);
    }
  }

  Path? _trimPath(Path path, double fraction) {
    if (fraction >= 1.0) return path;
    if (fraction <= 0.0) return null;
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return null;
    final total = metrics.fold<double>(0, (s, m) => s + m.length);
    final target = total * fraction;
    final trimmed = Path();
    double consumed = 0;
    for (final m in metrics) {
      if (consumed >= target) break;
      final remain = target - consumed;
      trimmed.addPath(
        m.extractPath(0, remain >= m.length ? m.length : remain),
        Offset.zero,
      );
      consumed += m.length;
    }
    return trimmed;
  }

  // ── Station dots ─────────────────────────────────────────────────────────

  void _drawStationDots(Canvas canvas) {
    if (entranceProgress < 0.3) return;
    final dotAlpha = ((entranceProgress - 0.3) / 0.3).clamp(0.0, 1.0);

    final terminusIds = <String>{};
    for (final line in lines) {
      if (!visibleLineIds.contains(lineVisKey(line))) continue;
      terminusIds.add(line.terminusAId);
      terminusIds.add(line.terminusBId);
    }

    final whitePaint = Paint()..color = Color.fromRGBO(255, 255, 255, dotAlpha);

    for (final s in stationMap.values) {
      if (!isStationVisible(s, visibleLineIds)) continue;
      final pos = stationPositions[s.id];
      if (pos == null) continue;
      final c = stationThemeColor(s);
      final cPaint = Paint()..color = Color.fromRGBO(c.red, c.green, c.blue, dotAlpha);

      if (s.isTransfer) {
        canvas.drawCircle(pos, 11, whitePaint);
        canvas.drawCircle(
            pos,
            8,
            Paint()
              ..color = Color.fromRGBO(c.red, c.green, c.blue, dotAlpha)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3);
        canvas.drawCircle(pos, 3.5, cPaint);
      } else {
        final isEnd = terminusIds.contains(s.id);
        canvas.drawCircle(pos, isEnd ? 8.0 : 6.5, whitePaint);
        canvas.drawCircle(pos, isEnd ? 5.5 : 4.5, cPaint);
      }
    }
  }

  // ── Labels with collision avoidance ──────────────────────────────────────

  void _drawLabels(Canvas canvas) {
    if (entranceProgress < 0.5) return;
    final labelAlpha = ((entranceProgress - 0.5) / 0.5).clamp(0.0, 1.0);

    final terminusIds = <String>{};
    for (final line in lines) {
      if (!visibleLineIds.contains(lineVisKey(line))) continue;
      terminusIds.add(line.terminusAId);
      terminusIds.add(line.terminusBId);
    }

    final labels = <_LabelEntry>[];
    for (final s in stationMap.values) {
      if (!isStationVisible(s, visibleLineIds)) continue;
      final isImportant = s.isTransfer || terminusIds.contains(s.id);
      labels.add(_LabelEntry(
        station: s,
        pos: stationPositions[s.id]!,
        isImportant: isImportant,
        priority: isImportant ? 0 : 1,
      ));
    }
    labels.sort((a, b) => a.priority.compareTo(b.priority));

    final placedRects = <Rect>[];
    final textDir =
        languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    final bgPaint = Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.6 * labelAlpha);
    final shadowColor = Color.fromRGBO(0, 0, 0, 0.85 * labelAlpha);
    final labelColor = Color.fromRGBO(255, 255, 255, labelAlpha);

    for (final entry in labels) {
      final name = entry.station.localizedName(languageCode);
      final fontSize = entry.isImportant ? 11.0 : 8.5;
      final fontWeight =
          entry.isImportant ? FontWeight.w700 : FontWeight.w500;

      final tp = TextPainter(
        text: TextSpan(
          text: name,
          style: TextStyle(
            color: labelColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: 0.2,
            shadows: [Shadow(color: shadowColor, blurRadius: 4)],
          ),
        ),
        textDirection: textDir,
        maxLines: 1,
      )..layout(maxWidth: 200);

      final gap = entry.isImportant ? 16.0 : 11.0;
      final gapV = entry.isImportant ? 20.0 : 14.0;
      final gapVB = entry.isImportant ? 16.0 : 10.0;
      final offsets = [
        Offset(entry.pos.dx + gap, entry.pos.dy - tp.height / 2),
        Offset(entry.pos.dx - tp.width - gap, entry.pos.dy - tp.height / 2),
        Offset(entry.pos.dx - tp.width / 2, entry.pos.dy - gapV),
        Offset(entry.pos.dx - tp.width / 2, entry.pos.dy + gapVB),
      ];

      Offset? best;
      for (final off in offsets) {
        final rect =
            Rect.fromLTWH(off.dx - 3, off.dy - 2, tp.width + 6, tp.height + 4);
        if (!_overlapsAny(rect, placedRects)) {
          best = off;
          placedRects.add(rect);
          break;
        }
      }
      if (best == null) {
        if (!entry.isImportant) continue;
        best = offsets[0];
        placedRects.add(
            Rect.fromLTWH(best.dx - 3, best.dy - 2, tp.width + 6, tp.height + 4));
      }

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              best.dx - 5, best.dy - 3, tp.width + 10, tp.height + 6),
          const Radius.circular(5),
        ),
        bgPaint,
      );
      tp.paint(canvas, best);
    }
  }

  bool _overlapsAny(Rect rect, List<Rect> others) {
    for (final o in others) {
      if (rect.overlaps(o)) return true;
    }
    return false;
  }

  @override
  bool shouldRepaint(covariant MetroMapStaticPainter old) {
    return old.entranceProgress != entranceProgress ||
        old.languageCode != languageCode ||
        !setEquals(old.visibleLineIds, visibleLineIds) ||
        !identical(old.stationMap, stationMap) ||
        !identical(old.linePaths, linePaths);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED PAINTER — train dots, selection ring, user location
//
// Super lightweight — only draws a handful of circles per frame.
// ─────────────────────────────────────────────────────────────────────────────

class MetroMapAnimPainter extends CustomPainter {
  final double trainProgress;
  final Map<String, List<Offset>> trainSamples;
  final List<MetroLine> lines;
  final Set<String> visibleLineIds;
  final String? selectedStationId;
  final Offset? selectedStationPos;
  final Color? selectedStationColor;
  final double selectionAnimValue;
  final Offset? userLocation;
  final double userLocPulse;

  MetroMapAnimPainter({
    required this.trainProgress,
    required this.trainSamples,
    required this.lines,
    required this.visibleLineIds,
    this.selectedStationId,
    this.selectedStationPos,
    this.selectedStationColor,
    this.selectionAnimValue = 0.0,
    this.userLocation,
    this.userLocPulse = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawTrainDots(canvas);
    if (userLocation != null) _drawUserLocation(canvas);
    if (selectedStationPos != null) _drawSelectionRing(canvas);
  }

  void _drawTrainDots(Canvas canvas) {
    final whitePaint = Paint()..color = Colors.white;

    for (final line in lines) {
      if (!visibleLineIds.contains(lineVisKey(line))) continue;
      final samples = trainSamples[line.id];
      if (samples == null || samples.length < 2) continue;
      final c = lineThemeColor(line);
      final cPaint = Paint()..color = c;
      final last = samples.length - 1;

      for (int t = 0; t < 2; t++) {
        final progress = (trainProgress + t * 0.5) % 1.0;
        final directed = t == 0 ? progress : 1.0 - progress;
        final idx = (directed * last).round().clamp(0, last);
        final pos = samples[idx];
        canvas.drawCircle(pos, 4.5, whitePaint);
        canvas.drawCircle(pos, 3, cPaint);
      }
    }
  }

  void _drawUserLocation(Canvas canvas) {
    final pos = userLocation!;
    final pulseR = 24.0 + userLocPulse * 18.0;
    final pulseA = (0.35 - userLocPulse * 0.3).clamp(0.0, 1.0);
    canvas.drawCircle(
        pos,
        pulseR,
        Paint()
          ..color = Color.fromRGBO(33, 150, 243, pulseA)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawCircle(pos, 10, Paint()..color = Colors.white);
    canvas.drawCircle(pos, 7, Paint()..color = const Color(0xFF4285F4));
    canvas.drawCircle(Offset(pos.dx - 2, pos.dy - 2), 2.5,
        Paint()..color = const Color(0x80FFFFFF));
  }

  void _drawSelectionRing(Canvas canvas) {
    final pos = selectedStationPos!;
    final c = selectedStationColor ?? AppTheme.primaryNile;
    for (int i = 0; i < 2; i++) {
      final p = ((selectionAnimValue + i * 0.4) % 1.0);
      final r = 22.0 + p * 14.0;
      final a = ((0.6 - p * 0.5)).clamp(0.0, 1.0);
      canvas.drawCircle(
          pos,
          r,
          Paint()
            ..color = Color.fromRGBO(c.red, c.green, c.blue, a)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5 - i * 0.5);
    }
    canvas.drawCircle(
        pos,
        18,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
  }

  @override
  bool shouldRepaint(covariant MetroMapAnimPainter old) => true;
}

// ─────────────────────────────────────────────────────────────────────────────

class _LabelEntry {
  final Station station;
  final Offset pos;
  final bool isImportant;
  final int priority;
  _LabelEntry({
    required this.station,
    required this.pos,
    required this.isImportant,
    required this.priority,
  });
}
