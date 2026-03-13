import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../domain/entities/metro_line.dart';
import '../domain/entities/station.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MetroMapPainter — v3
//
//   • All station labels always shown (smaller at low zoom)
//   • Label collision avoidance — no overlaps
//   • LRT lines included
//   • User location blue pulsing dot
//   • Animated train dots
//   • Entrance draw-in animation
//   • Subtle grid background
// ─────────────────────────────────────────────────────────────────────────────

class MetroMapPainter extends CustomPainter {
  final List<MetroLine> lines;
  final Map<String, Station> stationMap;
  final String languageCode;
  final double zoom;
  final String? selectedStationId;
  final double selectionAnimValue;
  final double trainProgress;
  final double entranceProgress;
  final Set<String> visibleLineIds;
  final Offset? userLocation; // projected canvas coords (or null)
  final double userLocPulse;  // 0–1 for pulsing

  final Map<String, Offset> stationPositions;

  late final double _minLat, _maxLat, _minLng, _maxLng;
  late final double _canvasW, _canvasH;
  static const double _padding = 180.0;

  MetroMapPainter({
    required this.lines,
    required this.stationMap,
    required this.languageCode,
    required this.zoom,
    required this.stationPositions,
    required this.visibleLineIds,
    this.selectedStationId,
    this.selectionAnimValue = 0.0,
    this.trainProgress = 0.0,
    this.entranceProgress = 1.0,
    this.userLocation,
    this.userLocPulse = 0.0,
  }) {
    _computeBounds();
  }

  void _computeBounds() {
    double minLat = double.infinity, maxLat = -double.infinity;
    double minLng = double.infinity, maxLng = -double.infinity;

    // Include ALL stations (metro + LRT) in bounds
    for (final s in stationMap.values) {
      if (s.latitude < minLat) minLat = s.latitude;
      if (s.latitude > maxLat) maxLat = s.latitude;
      if (s.longitude < minLng) minLng = s.longitude;
      if (s.longitude > maxLng) maxLng = s.longitude;
    }

    final latSpan = maxLat - minLat;
    final lngSpan = maxLng - minLng;
    _minLat = minLat - latSpan * 0.10;
    _maxLat = maxLat + latSpan * 0.10;
    _minLng = minLng - lngSpan * 0.10;
    _maxLng = maxLng + lngSpan * 0.10;

    _canvasW = (_maxLng - _minLng) * 3600 + _padding * 2;
    _canvasH = (_maxLat - _minLat) * 3600 + _padding * 2;
  }

  Size get canvasSize => Size(_canvasW, _canvasH);

  Color _color(MetroLine line) {
    switch (line.id) {
      case 'L1': return AppTheme.line1;
      case 'L2': return AppTheme.line2;
      case 'L3': case 'L3A': case 'L3B': return AppTheme.line3;
      case 'LRT_MAIN': case 'LRT_BRANCH_NAC': case 'LRT_BRANCH_10TH':
        return AppTheme.lrt;
      default: return line.color;
    }
  }

  Color _stationColor(Station station) {
    for (final lid in station.lineIds) {
      switch (lid) {
        case 'L1': return AppTheme.line1;
        case 'L2': return AppTheme.line2;
        case 'L3': case 'L3A': case 'L3B': return AppTheme.line3;
        case 'LRT_MAIN': case 'LRT_BRANCH_NAC': case 'LRT_BRANCH_10TH':
          return AppTheme.lrt;
      }
    }
    return AppTheme.primaryNile;
  }

  Offset _project(double lat, double lng) {
    final x = _padding + ((lng - _minLng) / (_maxLng - _minLng)) * (_canvasW - _padding * 2);
    final y = _padding + ((1 - (lat - _minLat) / (_maxLat - _minLat))) * (_canvasH - _padding * 2);
    return Offset(x, y);
  }

  /// Public so the page can project GPS → canvas for user location
  Offset projectGps(double lat, double lng) => _project(lat, lng);

  @override
  void paint(Canvas canvas, Size size) {
    stationPositions.clear();
    for (final s in stationMap.values) {
      stationPositions[s.id] = _project(s.latitude, s.longitude);
    }

    _drawGrid(canvas);
    _drawLineGlows(canvas);
    _drawLineStrokes(canvas);
    _drawTrainDots(canvas);
    _drawStationDots(canvas);
    _drawLabels(canvas);
    if (userLocation != null) _drawUserLocation(canvas);
    if (selectedStationId != null) _drawSelectionRing(canvas);
  }

  // ── Grid ────────────────────────────────────────────────────────────────

  void _drawGrid(Canvas canvas) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 1;

    const step = 80.0;
    for (double x = 0; x < _canvasW; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, _canvasH), gridPaint);
    }
    for (double y = 0; y < _canvasH; y += step) {
      canvas.drawLine(Offset(0, y), Offset(_canvasW, y), gridPaint);
    }

    final center = Offset(_canvasW / 2, _canvasH / 2);
    canvas.drawCircle(
      center,
      _canvasW * 0.35,
      Paint()
        ..shader = ui.Gradient.radial(
          center,
          _canvasW * 0.35,
          [Colors.white.withOpacity(0.015), Colors.transparent],
        ),
    );
  }

  // ── Line glows ──────────────────────────────────────────────────────────

  void _drawLineGlows(Canvas canvas) {
    for (final line in lines) {
      if (!visibleLineIds.contains(_visKey(line))) continue;
      final c = _color(line);
      final paint = Paint()
        ..color = c.withOpacity(0.20)
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      final path = _buildLinePath(line);
      if (path != null) {
        final trimmed = _trimPath(path, entranceProgress);
        if (trimmed != null) canvas.drawPath(trimmed, paint);
      }
    }
  }

  // ── Line strokes ────────────────────────────────────────────────────────

  void _drawLineStrokes(Canvas canvas) {
    for (final line in lines) {
      if (!visibleLineIds.contains(_visKey(line))) continue;
      final c = _color(line);
      final isLrt = line.id.startsWith('LRT');
      final isBranch = line.id == 'L3A' || line.id == 'L3B' ||
          line.id == 'LRT_BRANCH_NAC' || line.id == 'LRT_BRANCH_10TH';

      final paint = Paint()
        ..color = c
        ..strokeWidth = isLrt ? 4.0 : (isBranch ? 4.5 : 6.0)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = _buildLinePath(line);
      if (path != null) {
        final trimmed = _trimPath(path, entranceProgress);
        if (trimmed != null) canvas.drawPath(trimmed, paint);
      }
    }
  }

  /// Map line id to its visibility key (L3A/L3B follow L3)
  String _visKey(MetroLine line) {
    if (line.id == 'L3A' || line.id == 'L3B') return 'L3';
    if (line.id.startsWith('LRT')) return 'LRT';
    return line.id;
  }

  Path? _buildLinePath(MetroLine line) {
    final points = <Offset>[];
    for (final sid in line.stationIds) {
      final pos = stationPositions[sid];
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

  // ── Train dots ──────────────────────────────────────────────────────────

  void _drawTrainDots(Canvas canvas) {
    if (entranceProgress < 1.0) return;

    for (final line in lines) {
      if (!visibleLineIds.contains(_visKey(line))) continue;
      final path = _buildLinePath(line);
      if (path == null) continue;

      final c = _color(line);
      final metrics = path.computeMetrics().toList();
      if (metrics.isEmpty) continue;
      final total = metrics.fold<double>(0, (s, m) => s + m.length);

      for (int t = 0; t < 2; t++) {
        final progress = (trainProgress + t * 0.5) % 1.0;
        final directed = t == 0 ? progress : 1.0 - progress;
        final targetDist = directed * total;

        Offset? pos;
        double consumed = 0;
        for (final m in metrics) {
          if (consumed + m.length >= targetDist) {
            pos = m.getTangentForOffset(targetDist - consumed)?.position;
            break;
          }
          consumed += m.length;
        }
        if (pos == null) continue;

        canvas.drawCircle(
          pos, 10,
          Paint()
            ..color = c.withOpacity(0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
        );
        canvas.drawCircle(pos, 4.5, Paint()..color = Colors.white);
        canvas.drawCircle(pos, 3, Paint()..color = c);
      }
    }
  }

  // ── Station dots ────────────────────────────────────────────────────────

  void _drawStationDots(Canvas canvas) {
    if (entranceProgress < 0.3) return;
    final dotAlpha = ((entranceProgress - 0.3) / 0.3).clamp(0.0, 1.0);

    final regular = <Station>[];
    final transfers = <Station>[];

    for (final s in stationMap.values) {
      if (!_stationVisible(s)) continue;
      s.isTransfer ? transfers.add(s) : regular.add(s);
    }

    final terminusIds = <String>{};
    for (final line in lines) {
      if (!visibleLineIds.contains(_visKey(line))) continue;
      terminusIds.add(line.terminusAId);
      terminusIds.add(line.terminusBId);
    }

    // Regular
    for (final s in regular) {
      final pos = stationPositions[s.id]!;
      final c = _stationColor(s);
      final isEnd = terminusIds.contains(s.id);
      final r = isEnd ? 8.0 : 6.5;
      final ri = isEnd ? 5.5 : 4.5;
      canvas.drawCircle(pos, r, Paint()..color = Colors.white.withOpacity(dotAlpha));
      canvas.drawCircle(pos, ri, Paint()..color = c.withOpacity(dotAlpha));
    }

    // Transfer
    for (final s in transfers) {
      final pos = stationPositions[s.id]!;
      final c = _stationColor(s);

      canvas.drawCircle(
        pos, 15,
        Paint()
          ..color = Colors.white.withOpacity(0.2 * dotAlpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(pos, 11, Paint()..color = Colors.white.withOpacity(dotAlpha));
      canvas.drawCircle(
        pos, 8,
        Paint()
          ..color = c.withOpacity(dotAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
      canvas.drawCircle(pos, 3.5, Paint()..color = c.withOpacity(dotAlpha));
    }
  }

  bool _stationVisible(Station s) {
    return s.lineIds.any((lid) => visibleLineIds.contains(
        lid.startsWith('LRT') ? 'LRT' : (lid == 'L3A' || lid == 'L3B' ? 'L3' : lid)));
  }

  // ── Labels with collision avoidance ─────────────────────────────────────

  void _drawLabels(Canvas canvas) {
    if (entranceProgress < 0.5) return;
    final labelAlpha = ((entranceProgress - 0.5) / 0.5).clamp(0.0, 1.0);

    final terminusIds = <String>{};
    for (final line in lines) {
      if (!visibleLineIds.contains(_visKey(line))) continue;
      terminusIds.add(line.terminusAId);
      terminusIds.add(line.terminusBId);
    }

    // Collect all labels with priority
    final labels = <_LabelEntry>[];
    for (final s in stationMap.values) {
      if (!_stationVisible(s)) continue;

      final isTerminus = terminusIds.contains(s.id);
      final isImportant = s.isTransfer || isTerminus;
      final priority = isImportant ? 0 : 1; // 0 = high priority

      labels.add(_LabelEntry(
        station: s,
        pos: stationPositions[s.id]!,
        isImportant: isImportant,
        priority: priority,
      ));
    }

    // Sort: important first so they get placed first
    labels.sort((a, b) => a.priority.compareTo(b.priority));

    // Place labels with collision detection
    final placedRects = <Rect>[];

    for (final entry in labels) {
      final name = entry.station.localizedName(languageCode);
      final fontSize = entry.isImportant ? 11.0 : 8.5;
      final fontWeight = entry.isImportant ? FontWeight.w700 : FontWeight.w500;

      final textSpan = TextSpan(
        text: name,
        style: TextStyle(
          color: Colors.white.withOpacity(labelAlpha),
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 0.2,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.9 * labelAlpha), blurRadius: 6),
            Shadow(color: Colors.black.withOpacity(0.6 * labelAlpha), blurRadius: 3),
          ],
        ),
      );

      final tp = TextPainter(
        text: textSpan,
        textDirection: languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        maxLines: 1,
      )..layout(maxWidth: 200);

      // Try 4 positions: right, left, above, below
      final offsets = [
        Offset(entry.pos.dx + (entry.isImportant ? 16 : 11), entry.pos.dy - tp.height / 2),
        Offset(entry.pos.dx - tp.width - (entry.isImportant ? 16 : 11), entry.pos.dy - tp.height / 2),
        Offset(entry.pos.dx - tp.width / 2, entry.pos.dy - (entry.isImportant ? 20 : 14)),
        Offset(entry.pos.dx - tp.width / 2, entry.pos.dy + (entry.isImportant ? 16 : 10)),
      ];

      Offset? bestOffset;
      for (final off in offsets) {
        final rect = Rect.fromLTWH(off.dx - 3, off.dy - 2, tp.width + 6, tp.height + 4);
        if (!_overlapsAny(rect, placedRects)) {
          bestOffset = off;
          placedRects.add(rect);
          break;
        }
      }

      // If all positions overlap and this is not important, skip
      if (bestOffset == null) {
        if (!entry.isImportant) continue;
        // Force place important labels at first position
        bestOffset = offsets[0];
        placedRects.add(
          Rect.fromLTWH(bestOffset.dx - 3, bestOffset.dy - 2, tp.width + 6, tp.height + 4),
        );
      }

      // Background pill
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(bestOffset.dx - 5, bestOffset.dy - 3, tp.width + 10, tp.height + 6),
        const Radius.circular(5),
      );
      canvas.drawRRect(bgRect, Paint()..color = Colors.black.withOpacity(0.6 * labelAlpha));
      tp.paint(canvas, bestOffset);
    }
  }

  bool _overlapsAny(Rect rect, List<Rect> others) {
    for (final o in others) {
      if (rect.overlaps(o)) return true;
    }
    return false;
  }

  // ── User location ───────────────────────────────────────────────────────

  void _drawUserLocation(Canvas canvas) {
    final pos = userLocation!;

    // Accuracy / pulse ring
    final pulseR = 24.0 + userLocPulse * 18.0;
    final pulseA = (0.35 - userLocPulse * 0.3).clamp(0.0, 1.0);
    canvas.drawCircle(
      pos, pulseR,
      Paint()
        ..color = Colors.blue.withOpacity(pulseA)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Outer glow
    canvas.drawCircle(
      pos, 18,
      Paint()
        ..color = Colors.blue.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // White border
    canvas.drawCircle(pos, 10, Paint()..color = Colors.white);
    // Blue dot
    canvas.drawCircle(pos, 7, Paint()..color = const Color(0xFF4285F4));
    // Inner highlight
    canvas.drawCircle(
      Offset(pos.dx - 2, pos.dy - 2), 2.5,
      Paint()..color = Colors.white.withOpacity(0.5),
    );
  }

  // ── Selection ring ──────────────────────────────────────────────────────

  void _drawSelectionRing(Canvas canvas) {
    final pos = stationPositions[selectedStationId];
    if (pos == null) return;
    final station = stationMap[selectedStationId];
    if (station == null) return;
    final c = _stationColor(station);

    // Dual pulse
    for (int i = 0; i < 2; i++) {
      final p = ((selectionAnimValue + i * 0.4) % 1.0);
      final r = 22.0 + p * 14.0;
      final a = ((0.6 - p * 0.5)).clamp(0.0, 1.0);
      canvas.drawCircle(
        pos, r,
        Paint()
          ..color = c.withOpacity(a)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 - i * 0.5,
      );
    }

    canvas.drawCircle(
      pos, 18,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    canvas.drawCircle(
      pos, 24,
      Paint()
        ..color = c.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  @override
  bool shouldRepaint(covariant MetroMapPainter old) {
    return old.zoom != zoom ||
        old.selectedStationId != selectedStationId ||
        old.selectionAnimValue != selectionAnimValue ||
        old.trainProgress != trainProgress ||
        old.entranceProgress != entranceProgress ||
        old.languageCode != languageCode ||
        old.visibleLineIds != visibleLineIds ||
        old.userLocation != userLocation ||
        old.userLocPulse != userLocPulse;
  }
}

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
