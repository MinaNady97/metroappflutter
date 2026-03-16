import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

// ─── Data models ────────────────────────────────────────────────────────────

enum CrowdLevel { calm, moderate, busy }

enum LineStatus { operational, maintenance, disruption }

class LineMetadata {
  final String terminus1;
  final String terminus2;
  final double distanceKm;
  final int travelMinutes;
  final int transferCount;
  final String firstTrain;
  final String lastTrain;
  final CrowdLevel crowdLevel;
  final LineStatus status;

  const LineMetadata({
    required this.terminus1,
    required this.terminus2,
    required this.distanceKm,
    required this.travelMinutes,
    required this.transferCount,
    required this.firstTrain,
    required this.lastTrain,
    required this.crowdLevel,
    this.status = LineStatus.operational,
  });
}

// ─── Pre-defined metadata for each line ─────────────────────────────────────

const Map<String, LineMetadata> kLineMetadata = {
  '1': LineMetadata(
    terminus1: 'Helwan',
    terminus2: 'El-Marg',
    distanceKm: 43.5,
    travelMinutes: 72,
    transferCount: 2,
    firstTrain: '05:00',
    lastTrain: '00:00',
    crowdLevel: CrowdLevel.busy,
  ),
  '2': LineMetadata(
    terminus1: 'El-Mounib',
    terminus2: 'Shubra El-Kheima',
    distanceKm: 20.2,
    travelMinutes: 35,
    transferCount: 2,
    firstTrain: '05:30',
    lastTrain: '23:30',
    crowdLevel: CrowdLevel.moderate,
  ),
  '3': LineMetadata(
    terminus1: 'Rod El-Farag Axis',
    terminus2: 'Cairo Airport',
    distanceKm: 35.1,
    travelMinutes: 58,
    transferCount: 3,
    firstTrain: '05:00',
    lastTrain: '23:00',
    crowdLevel: CrowdLevel.moderate,
  ),
  'LRT': LineMetadata(
    terminus1: 'Adly Mansour',
    terminus2: '10th of Ramadan',
    distanceKm: 90.0,
    travelMinutes: 60,
    transferCount: 1,
    firstTrain: '06:00',
    lastTrain: '22:00',
    crowdLevel: CrowdLevel.calm,
    status: LineStatus.operational,
  ),
  '4': LineMetadata(
    terminus1: 'Hadayek Al-Ashgar',
    terminus2: 'New Cairo',
    distanceKm: 19.0,
    travelMinutes: 30,
    transferCount: 2,
    firstTrain: '—',
    lastTrain: '—',
    crowdLevel: CrowdLevel.calm,
    status: LineStatus.operational,
  ),
  'ME': LineMetadata(
    terminus1: 'Stadium',
    terminus2: 'New Capital',
    distanceKm: 56.5,
    travelMinutes: 52,
    transferCount: 1,
    firstTrain: '—',
    lastTrain: '—',
    crowdLevel: CrowdLevel.calm,
    status: LineStatus.operational,
  ),
  'MW': LineMetadata(
    terminus1: 'New October',
    terminus2: 'Wadi El-Nil',
    distanceKm: 42.0,
    travelMinutes: 40,
    transferCount: 1,
    firstTrain: '—',
    lastTrain: '—',
    crowdLevel: CrowdLevel.calm,
    status: LineStatus.operational,
  ),
};

// ─── Widget ──────────────────────────────────────────────────────────────────

class LinePreviewCard extends StatefulWidget {
  final String lineNumber;
  final String lineName;
  final Color color;
  final int stations;
  final VoidCallback onTap;
  final LineMetadata? metadata;

  const LinePreviewCard({
    super.key,
    required this.lineNumber,
    required this.lineName,
    required this.color,
    required this.stations,
    required this.onTap,
    this.metadata,
  });

  @override
  State<LinePreviewCard> createState() => _LinePreviewCardState();
}

class _LinePreviewCardState extends State<LinePreviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  LineMetadata? get _meta =>
      widget.metadata ?? kLineMetadata[widget.lineNumber];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final meta = _meta;
    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isDark
                    ? AppTheme.darkBorder
                    : Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(isDark ? 0.25 : 0.12),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(meta),
              if (meta != null) ...[
                const SizedBox(height: 10),
                _buildTerminusRail(meta),
                const SizedBox(height: 10),
                _buildStatsRow(meta, isDark),
                const SizedBox(height: 8),
                _buildFooter(meta, isDark),
              ] else ...[
                const Spacer(),
                Text(
                  '${widget.stations} stations',
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.darkTextSub
                        : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(LineMetadata? meta) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              widget.lineNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.lineName,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (meta != null) _buildStatusBadge(meta.status),
      ],
    );
  }

  Widget _buildStatusBadge(LineStatus status) {
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (status) {
      LineStatus.operational => ('●  ${l10n?.statusLiveLabel ?? 'Live'}', const Color(0xFF00A86B)),
      LineStatus.maintenance => ('⚙  ${l10n?.statusMaintenanceLabel ?? 'Maint.'}', Colors.orange),
      LineStatus.disruption => ('⚠  ${l10n?.statusDisruptionLabel ?? 'Delay'}', Colors.red),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Visual colored rail from terminus1 → terminus2
  Widget _buildTerminusRail(LineMetadata meta) {
    return Row(
      children: [
        _dot(widget.color),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color, widget.color.withOpacity(0.4)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        _dot(widget.color.withOpacity(0.55)),
      ],
    );
  }

  Widget _dot(Color color) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.5), blurRadius: 4),
          ],
        ),
      );

  Widget _buildStatsRow(LineMetadata meta, bool isDark) {
    return Row(
      children: [
        _statChip(Icons.straighten, '${meta.distanceKm.toStringAsFixed(0)}km',
            isDark),
        const SizedBox(width: 6),
        _statChip(Icons.schedule, '${meta.travelMinutes}m', isDark),
        const SizedBox(width: 6),
        _statChip(Icons.sync_alt, '${meta.transferCount}x', isDark),
      ],
    );
  }

  Widget _statChip(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkElevated : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 10,
              color: isDark ? AppTheme.darkTextSub : Colors.grey.shade600),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
                fontSize: 10,
                color:
                    isDark ? AppTheme.darkTextSub : Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(LineMetadata meta, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final crowdColor = switch (meta.crowdLevel) {
      CrowdLevel.calm => const Color(0xFF00A86B),
      CrowdLevel.moderate => Colors.orange,
      CrowdLevel.busy => Colors.red,
    };
    final crowdLabel = switch (meta.crowdLevel) {
      CrowdLevel.calm => l10n?.crowdCalmLabel ?? 'Calm',
      CrowdLevel.moderate => l10n?.crowdModerateLabel ?? 'Moderate',
      CrowdLevel.busy => l10n?.crowdBusyLabel ?? 'Busy',
    };

    return Row(
      children: [
        Icon(Icons.access_time,
            size: 11,
            color:
                isDark ? AppTheme.darkTextTertiary : Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(
          '${meta.firstTrain}–${meta.lastTrain}',
          style: TextStyle(
              fontSize: 10,
              color:
                  isDark ? AppTheme.darkTextSub : Colors.grey.shade600),
        ),
        const Spacer(),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: crowdColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          crowdLabel,
          style: TextStyle(
            fontSize: 10,
            color: crowdColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
