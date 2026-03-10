import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/Pages/stationspage.dart';

class RouteTimeline extends StatefulWidget {
  final Map<String, dynamic> routeData;
  final List<List<List<int>>> serializedData;
  final bool isFirst;

  const RouteTimeline({
    super.key,
    required this.routeData,
    required this.serializedData,
    this.isFirst = false,
  });

  @override
  State<RouteTimeline> createState() => _RouteTimelineState();
}

class _RouteTimelineState extends State<RouteTimeline> {
  bool _showAllStops = false;

  @override
  Widget build(BuildContext context) {
    final routeType =
        int.tryParse(widget.routeData['Route type']?.toString() ?? '1') ?? 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isFirst
              ? AppTheme.accentGold.withOpacity(0.5)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          if (routeType == 1) ..._singleLine(context),
          if (routeType == 2) ..._twoLine(),
          if (routeType == 3) ..._threeLine(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Get.to(() =>
                        Stationspage(serializedData: widget.serializedData));
                  },
                  icon: const Icon(Icons.map_outlined),
                  label: Text(AppLocalizations.of(context)!.viewFullMap),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.locale == 'ar';
    final stops = widget.routeData['No. of stations']?.toString() ?? '-';
    final time = widget.routeData['Estimated travel time']?.toString() ?? '-';
    final fare = widget.routeData['Ticket Price']?.toString() ?? '-';
    final chips = Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.end,
      children: [
        _infoChip(
          icon: Icons.train,
          label: '${isAr ? 'محطات' : 'Stops'} $stops',
        ),
        _infoChip(
          icon: Icons.access_time,
          label: '${isAr ? 'وقت' : 'Time'} $time',
        ),
        _infoChip(
          icon: Icons.payments_outlined,
          label: '${isAr ? 'سعر' : 'Fare'} $fare',
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isFirst)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Best',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        if (widget.isFirst) const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: chips,
        ),
      ],
    );
  }

  Widget _infoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _singleLine(BuildContext context) {
    final dep = widget.routeData['Departure']?.toString() ?? '';
    final arr = widget.routeData['Arrival']?.toString() ?? '';
    final line = widget.routeData['Take']?.toString() ?? '';
    final stations =
        (widget.routeData['Intermediate Stations'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList();
    final color = _lineColor(line);
    final hiddenStops = stations.length > 2
        ? stations.sublist(1, stations.length - 1)
        : <String>[];
    final isAr = AppLocalizations.of(context)!.locale == 'ar';

    return [
      Text(line, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      _point(dep, true, color),
      if (hiddenStops.isNotEmpty)
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          firstChild: _hiddenStopsPreview(hiddenStops.length, color),
          secondChild: Column(
            children: [
              for (final s in hiddenStops) _point(s, false, color),
            ],
          ),
          crossFadeState: _showAllStops
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      if (hiddenStops.isNotEmpty)
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => setState(() => _showAllStops = !_showAllStops),
            icon: Icon(
              _showAllStops ? Icons.expand_less : Icons.more_horiz,
              size: 18,
            ),
            label: Text(
              _showAllStops
                  ? (isAr ? 'إخفاء المحطات' : 'Hide stops')
                  : '${isAr ? 'عرض المحطات' : 'Show stops'} (${hiddenStops.length})',
            ),
          ),
        ),
      _point(arr, true, color),
    ];
  }

  Widget _hiddenStopsPreview(int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(color),
                const SizedBox(height: 3),
                _dot(color.withOpacity(0.75)),
                const SizedBox(height: 3),
                _dot(color.withOpacity(0.55)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$count stops hidden',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  List<Widget> _twoLine() {
    final first = widget.routeData['First take']?.toString() ?? '';
    final second = widget.routeData['Second take']?.toString() ?? '';
    final firstStations =
        (widget.routeData['First Intermediate Stations'] as List<dynamic>? ??
                [])
            .map((e) => e.toString())
            .toList();
    final secondStations =
        (widget.routeData['Second Intermediate Stations'] as List<dynamic>? ??
                [])
            .map((e) => e.toString())
            .toList();
    final changeAt = widget.routeData['You will change at']?.toString() ?? '';
    return [
      Text(first, style: const TextStyle(fontWeight: FontWeight.w600)),
      if (firstStations.isNotEmpty)
        _point(firstStations.first, true, _lineColor(first)),
      if (changeAt.isNotEmpty) _transfer(changeAt, first, second),
      Text(second, style: const TextStyle(fontWeight: FontWeight.w600)),
      if (secondStations.isNotEmpty)
        _point(secondStations.last, true, _lineColor(second)),
    ];
  }

  List<Widget> _threeLine() {
    final first = widget.routeData['First take']?.toString() ?? '';
    final second = widget.routeData['Second take']?.toString() ?? '';
    final third = widget.routeData['Third take']?.toString() ?? '';
    final firstStations =
        (widget.routeData['First Intermediate Stations'] as List<dynamic>? ??
                [])
            .map((e) => e.toString())
            .toList();
    final secondStations =
        (widget.routeData['Second Intermediate Stations'] as List<dynamic>? ??
                [])
            .map((e) => e.toString())
            .toList();
    final thirdStations =
        (widget.routeData['Third Intermediate Stations'] as List<dynamic>? ??
                [])
            .map((e) => e.toString())
            .toList();
    return [
      Text(first, style: const TextStyle(fontWeight: FontWeight.w600)),
      if (firstStations.isNotEmpty)
        _point(firstStations.first, true, _lineColor(first)),
      if (secondStations.isNotEmpty)
        _transfer(secondStations.first, first, second),
      Text(second, style: const TextStyle(fontWeight: FontWeight.w600)),
      if (thirdStations.isNotEmpty)
        _transfer(thirdStations.first, second, third),
      Text(third, style: const TextStyle(fontWeight: FontWeight.w600)),
      if (thirdStations.isNotEmpty)
        _point(thirdStations.last, true, _lineColor(third)),
    ];
  }

  Widget _point(String station, bool major, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: major ? 12 : 8,
            height: major ? 12 : 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(station)),
        ],
      ),
    );
  }

  Widget _transfer(String at, String from, String to) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('Transfer at $at ($from → $to)',
          style: const TextStyle(fontSize: 12)),
    );
  }

  Color _lineColor(String lineName) {
    if (lineName.contains('1') || lineName.contains('الأول'))
      return AppTheme.line1;
    if (lineName.contains('2') || lineName.contains('الثاني'))
      return AppTheme.line2;
    if (lineName.contains('3') || lineName.contains('الثالث'))
      return AppTheme.line3;
    if (lineName.toLowerCase().contains('lrt') || lineName.contains('القطار'))
      return AppTheme.lrt;
    return AppTheme.primaryNile;
  }
}
