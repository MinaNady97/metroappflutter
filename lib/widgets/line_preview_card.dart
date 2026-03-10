import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.12),
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
                _buildStatsRow(meta),
                const SizedBox(height: 8),
                _buildFooter(meta),
              ] else ...[
                const Spacer(),
                Text(
                  '${widget.stations} stations',
                  style: TextStyle(
                    color: Colors.grey.shade600,
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
    final (label, color) = switch (status) {
      LineStatus.operational => ('●  Live', const Color(0xFF00A86B)),
      LineStatus.maintenance => ('⚙  Maint.', Colors.orange),
      LineStatus.disruption => ('⚠  Delay', Colors.red),
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

  Widget _buildStatsRow(LineMetadata meta) {
    return Row(
      children: [
        _statChip(Icons.straighten, '${meta.distanceKm.toStringAsFixed(0)}km'),
        const SizedBox(width: 6),
        _statChip(Icons.schedule, '${meta.travelMinutes}m'),
        const SizedBox(width: 6),
        _statChip(Icons.sync_alt, '${meta.transferCount}x'),
      ],
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.grey.shade600),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(LineMetadata meta) {
    final crowdColor = switch (meta.crowdLevel) {
      CrowdLevel.calm => const Color(0xFF00A86B),
      CrowdLevel.moderate => Colors.orange,
      CrowdLevel.busy => Colors.red,
    };
    final crowdLabel = switch (meta.crowdLevel) {
      CrowdLevel.calm => 'Calm',
      CrowdLevel.moderate => 'Moderate',
      CrowdLevel.busy => 'Busy',
    };

    return Row(
      children: [
        Icon(Icons.access_time, size: 11, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(
          '${meta.firstTrain}–${meta.lastTrain}',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
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
