import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';

// ── Transfer guidance data ────────────────────────────────────────────────────

/// One numbered step in the transfer walkthrough.
class _Step {
  final IconData icon;
  /// Called with the current [AppLocalizations] to get localized text.
  final String Function(AppLocalizations) text;

  const _Step(this.icon, this.text);
}

/// Full guidance block for a transfer at a specific station.
class _Guidance {
  final List<_Step> steps;
  final String Function(AppLocalizations) note;
  final int walkMinutes;

  const _Guidance({
    required this.steps,
    required this.note,
    required this.walkMinutes,
  });
}

// ── Station-specific guidance ─────────────────────────────────────────────────

const _commonExit = _Step(
    Icons.exit_to_app_rounded,
    _s1);
const _commonSigns = _Step(
    Icons.signpost_rounded,
    _s2);
const _commonCheck = _Step(
    Icons.arrow_circle_right_rounded,
    _s3);
const _commonBoard = _Step(
    Icons.train_rounded,
    _s4);
const _commonCorridor = _Step(
    Icons.swap_horiz_rounded,
    _s5);

String _s1(AppLocalizations l) => l.transferExitCarriage;
String _s2(AppLocalizations l) => l.transferFollowSigns;
String _s3(AppLocalizations l) => l.transferCheckDirection;
String _s4(AppLocalizations l) => l.transferBoardTrain;
String _s5(AppLocalizations l) => l.transferWalkCorridor;
String _s6(AppLocalizations l) => l.transferNoRevalidate;
String _s7(AppLocalizations l) => l.transferCheckBranch;
String _s8(AppLocalizations l) => l.transferExitSurface;

final _guidanceMap = <String, _Guidance>{
  // ── Sadat (L1 ↔ L2) ─────────────────────────────────────────────────────
  'sadat': _Guidance(
    steps: [
      _commonExit,
      _commonSigns,
      _commonCheck,
      _commonBoard,
      _Step(Icons.receipt_long_rounded, _s6),
    ],
    note: (l) => l.transferNoteSadat,
    walkMinutes: 3,
  ),

  // ── El Shohadaa / Ramses (L1 ↔ L2) ──────────────────────────────────────
  'shohadaa': _Guidance(
    steps: [
      _commonExit,
      _commonSigns,
      _commonCheck,
      _commonBoard,
      _Step(Icons.receipt_long_rounded, _s6),
    ],
    note: (l) => l.transferNoteElShohadaa,
    walkMinutes: 3,
  ),

  // ── Gamal Abd El Nasser (L1 ↔ L3) ───────────────────────────────────────
  'gamal': _Guidance(
    steps: [
      _commonExit,
      _commonCorridor,
      _commonSigns,
      _commonCheck,
      _commonBoard,
    ],
    note: (l) => l.transferNoteGamalNasser,
    walkMinutes: 5,
  ),

  // ── Ataba (L2 ↔ L3) ─────────────────────────────────────────────────────
  'ataba': _Guidance(
    steps: [
      _commonExit,
      _commonCorridor,
      _commonSigns,
      _commonCheck,
      _commonBoard,
    ],
    note: (l) => l.transferNoteAtaba,
    walkMinutes: 4,
  ),

  // ── Kit Kat (L3 trunk ↔ L3A / L3B) ──────────────────────────────────────
  'kit': _Guidance(
    steps: [
      _Step(Icons.account_tree_rounded, _s7),
      _commonSigns,
      _commonBoard,
      _Step(Icons.receipt_long_rounded, _s6),
    ],
    note: (l) => l.transferNoteKitKat,
    walkMinutes: 2,
  ),

  // ── Cairo University (L2 ↔ L3B) ─────────────────────────────────────────
  'cairo university': _Guidance(
    steps: [
      _commonExit,
      _Step(Icons.stairs_rounded, _s8),
      _commonSigns,
      _commonCheck,
      _commonBoard,
    ],
    note: (l) => l.transferNoteCairoUniversity,
    walkMinutes: 5,
  ),
};

/// Return guidance for [stationName] (display name, any locale), or null if
/// the station has no detailed data.
_Guidance? _lookupGuidance(String stationName) {
  final lower = stationName.toLowerCase();
  for (final entry in _guidanceMap.entries) {
    if (lower.contains(entry.key)) return entry.value;
  }
  return null;
}

// ── Widget ────────────────────────────────────────────────────────────────────

/// Expandable transfer-step card shown inside [RouteTimeline] between segments.
///
/// - Collapsed: shows station name, line swap, and estimated walk time.
/// - Expanded: shows numbered steps + a station-specific platform note.
class TransferGuidanceCard extends StatefulWidget {
  /// Display name of the transfer station (may be in any locale).
  final String stationName;

  /// Line being left (e.g. "Line 1").
  final String fromLine;

  /// Line being boarded (e.g. "Line 2").
  final String toLine;

  const TransferGuidanceCard({
    super.key,
    required this.stationName,
    required this.fromLine,
    required this.toLine,
  });

  @override
  State<TransferGuidanceCard> createState() => _TransferGuidanceCardState();
}

class _TransferGuidanceCardState extends State<TransferGuidanceCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _animCtrl;
  late final Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expandAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _animCtrl.forward();
    } else {
      _animCtrl.reverse();
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Color _lineColor(String name) {
    if (name.contains('1') || name.contains('الأول')) return AppTheme.line1;
    if (name.contains('2') || name.contains('الثاني')) return AppTheme.line2;
    if (name.contains('3') || name.contains('الثالث')) return AppTheme.line3;
    if (name.toLowerCase().contains('lrt') || name.contains('القطار')) {
      return AppTheme.lrt;
    }
    return AppTheme.accentGold;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final guidance = _lookupGuidance(widget.stationName);
    final fromColor = _lineColor(widget.fromLine);
    final toColor = _lineColor(widget.toLine);
    final accent = AppTheme.accentGold;

    final bg = isDark
        ? accent.withValues(alpha: 0.13)
        : accent.withValues(alpha: 0.07);
    final border = accent.withValues(alpha: isDark ? 0.3 : 0.2);
    final textSub = isDark ? AppTheme.darkTextSub : Colors.grey.shade600;

    return GestureDetector(
      onTap: guidance != null ? _toggle : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Collapsed header ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  // Line swap indicator
                  _LineSwapBadge(
                      fromColor: fromColor, toColor: toColor, accent: accent),
                  const SizedBox(width: 10),

                  // Station name + walk time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.transferStations} ${widget.stationName}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppTheme.darkText
                                : Colors.grey.shade800,
                          ),
                        ),
                        if (guidance != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.directions_walk_rounded,
                                  size: 10, color: textSub),
                              const SizedBox(width: 3),
                              Text(
                                '~${l10n.walkingTime(guidance.walkMinutes)}',
                                style:
                                    TextStyle(fontSize: 10, color: textSub),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Expand chevron (only when guidance exists)
                  if (guidance != null)
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 280),
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: 18,
                        color: accent,
                      ),
                    ),
                ],
              ),
            ),

            // ── Expanded body (animated) ─────────────────────────────────
            if (guidance != null)
              SizeTransition(
                sizeFactor: _expandAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                        height: 1,
                        color: border,
                        indent: 12,
                        endIndent: 12),
                    const SizedBox(height: 10),

                    // Steps
                    ...guidance.steps.asMap().entries.map((e) {
                      final idx = e.key;
                      final step = e.value;
                      return _StepRow(
                        index: idx + 1,
                        icon: step.icon,
                        text: step.text(l10n),
                        isLast: idx == guidance.steps.length - 1,
                        accent: accent,
                        isDark: isDark,
                      );
                    }),

                    const SizedBox(height: 8),

                    // Platform note
                    Container(
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 13, color: accent),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              guidance.note(l10n),
                              style: TextStyle(
                                fontSize: 11,
                                color: textSub,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
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

// ── Line swap badge ───────────────────────────────────────────────────────────

class _LineSwapBadge extends StatelessWidget {
  final Color fromColor;
  final Color toColor;
  final Color accent;

  const _LineSwapBadge({
    required this.fromColor,
    required this.toColor,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        children: [
          // From-line circle (top-left)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: fromColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: fromColor.withValues(alpha: 0.35),
                      blurRadius: 4),
                ],
              ),
            ),
          ),
          // To-line circle (bottom-right)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: toColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: toColor.withValues(alpha: 0.35),
                      blurRadius: 4),
                ],
              ),
            ),
          ),
          // Swap icon in center
          Center(
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.swap_horiz_rounded,
                  size: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single step row ───────────────────────────────────────────────────────────

class _StepRow extends StatelessWidget {
  final int index;
  final IconData icon;
  final String text;
  final bool isLast;
  final Color accent;
  final bool isDark;

  const _StepRow({
    required this.index,
    required this.icon,
    required this.text,
    required this.isLast,
    required this.accent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppTheme.darkTextSub : Colors.grey.shade700;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line + number
            Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: isDark ? 0.25 : 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: accent.withValues(alpha: 0.4), width: 1),
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: accent.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            // Step content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 10 : 14, top: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon,
                        size: 14,
                        color: accent.withValues(alpha: 0.7)),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
