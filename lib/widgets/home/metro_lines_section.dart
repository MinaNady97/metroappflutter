import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../all_lines_modal.dart';
import '../line_preview_card.dart' show kLineMetadata;

// ── Section title style ───────────────────────────────────────────────────────
const _sectionHeaderStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w800,
  letterSpacing: -0.1,
);

/// Displays the metro + LRT lines overview section.
/// Pure display widget — no controller dependencies.
class MetroLinesSection extends StatelessWidget {
  const MetroLinesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          child: Text(
            l10n.metroLinesTitle,
            style: _sectionHeaderStyle.copyWith(
              color: isDark ? AppTheme.darkPrimary : AppTheme.primaryNile,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...lines.map((line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _LineRow(
                id: line.id,
                name: line.name,
                color: line.color,
                stations: line.stations,
                underConstruction: line.underConstruction,
              ),
            )),
      ],
    );
  }
}

// ── Single line row ───────────────────────────────────────────────────────────

class _LineRow extends StatelessWidget {
  final String id;
  final String name;
  final Color color;
  final int stations;
  final bool underConstruction;

  const _LineRow({
    required this.id,
    required this.name,
    required this.color,
    required this.stations,
    required this.underConstruction,
  });

  @override
  Widget build(BuildContext context) {
    final meta = kLineMetadata[id];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final cardColor = underConstruction
        ? (isDark ? AppTheme.darkBackground : Colors.grey.shade50)
        : (isDark ? AppTheme.darkCard : AppTheme.lightCard);
    final textColor = underConstruction
        ? (isDark ? AppTheme.darkTextTertiary : Colors.grey.shade500)
        : (isDark ? AppTheme.darkText : Colors.grey.shade800);

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
            // Line number badge
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
                  // Terminus rail
                  if (meta != null)
                    Row(
                      children: [
                        _TerminusDot(color: color, faded: underConstruction),
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
                        _TerminusDot(color: color, faded: underConstruction),
                      ],
                    ),
                  const SizedBox(height: 5),
                  // Bottom chips
                  Row(
                    children: [
                      _MiniChip(
                        icon: Icons.place_rounded,
                        label: '$stations ${l10n.stationsLabel}',
                        color: underConstruction ? Colors.grey : color,
                      ),
                      if (meta != null && !underConstruction) ...[
                        const SizedBox(width: 6),
                        _MiniChip(
                          icon: Icons.schedule_rounded,
                          label: '${meta.firstTrain}–${meta.lastTrain}',
                          color: color,
                        ),
                        const SizedBox(width: 6),
                        _MiniChip(
                          icon: Icons.straighten_rounded,
                          label: '${meta.distanceKm.toStringAsFixed(0)} km',
                          color: color,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color.withOpacity(underConstruction ? 0.3 : 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small helpers ─────────────────────────────────────────────────────────────

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MiniChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color.withOpacity(0.7)),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppTheme.darkTextSub : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _TerminusDot extends StatelessWidget {
  final Color color;
  final bool faded;
  const _TerminusDot({required this.color, required this.faded});

  @override
  Widget build(BuildContext context) => Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: faded ? color.withOpacity(0.3) : color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
      );
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
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
