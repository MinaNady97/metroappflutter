import 'package:flutter/material.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';

/// Metro line indicator(s) for a place (e.g. "1", "2/3").
Widget touristGuideLineBadges(String line) {
  if (line.isEmpty) return const SizedBox.shrink();
  final parts = line.split('/');
  if (parts.length == 1) {
    return _singleLineBadge(parts[0]);
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: parts
        .map((p) => Padding(
              padding: const EdgeInsets.only(right: 3),
              child: _singleLineBadge(p),
            ))
        .toList(),
  );
}

Widget _singleLineBadge(String l) {
  final color = switch (l.trim()) {
    '1' => AppTheme.line1,
    '2' => AppTheme.line2,
    '3' => AppTheme.line3,
    _ => AppTheme.primaryNile,
  };
  return Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Center(
      child: Text(
        l.trim(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
  );
}
