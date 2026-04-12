import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:metroappflutter/Controllers/routecontroller.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/Pages/stationspage.dart';
import 'package:metroappflutter/services/timetable_service.dart';
import 'package:metroappflutter/widgets/transfer_guidance_card.dart';

class RouteTimeline extends StatefulWidget {
  final Map<String, dynamic> routeData;
  final List<List<List<int>>> serializedData;
  final bool isFirst;
  /// Called when user taps the star. Null = hide the button.
  final VoidCallback? onFavorite;
  /// True = star is filled (already favorited).
  final bool isFavorite;

  const RouteTimeline({
    super.key,
    required this.routeData,
    required this.serializedData,
    this.isFirst = false,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  State<RouteTimeline> createState() => _RouteTimelineState();
}

class _RouteTimelineState extends State<RouteTimeline> {
  bool _showAllStops = false;

  // ── Extract per-segment station name lists from routeData ──────────────────
  List<List<String>> _buildStationNames() {
    final rd = widget.routeData;
    final routeType = int.tryParse(rd['Route type']?.toString() ?? '1') ?? 1;

    List<String> _parse(String key) =>
        (rd[key] as List<dynamic>? ?? []).map((e) => e.toString()).toList();

    if (routeType == 1) {
      return [_parse('Intermediate Stations')];
    } else if (routeType == 2) {
      return [
        _parse('First Intermediate Stations'),
        _parse('Second Intermediate Stations'),
      ];
    } else {
      return [
        _parse('First Intermediate Stations'),
        _parse('Second Intermediate Stations'),
        _parse('Third Intermediate Stations'),
      ];
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final routeType =
        int.tryParse(widget.routeData['Route type']?.toString() ?? '1') ?? 1;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.isFirst
                ? AppTheme.accentGold.withOpacity(0.18)
                : Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: widget.isFirst ? 24 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top accent bar — clipped cleanly by card's own border radius
          if (widget.isFirst)
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFF5D76E)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGold.withOpacity(0.45),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, l10n),
                const SizedBox(height: 14),
                if (routeType == 1) ..._singleLine(context),
                if (routeType == 2) ..._twoLine(context),
                if (routeType == 3) ..._threeLine(context),
                const SizedBox(height: 14),
                _buildMapButton(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stops = widget.routeData['No. of stations']?.toString() ?? '-';
    final time = widget.routeData['Estimated travel time']?.toString() ?? '-';
    final fare = widget.routeData['Ticket Price']?.toString() ?? '-';
    final firstLineId =
        widget.routeData['_firstLineId'] as String? ?? '';

    // Route type badge
    final sortType = widget.routeData['_sortType'] as String? ?? '';

    // Timetable hint
    final nextMin = firstLineId.isNotEmpty
        ? TimetableService.instance.nextTrainMinutes(firstLineId)
        : null;
    final inService = firstLineId.isNotEmpty
        ? TimetableService.instance.isInService(firstLineId)
        : true;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.isFirst) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.accentGold, Color(0xFFF5C842)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 11, color: Colors.white),
                        const SizedBox(width: 2),
                        Text(
                          l10n.bestRoute,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                // Route type badge (non-first routes)
                if (!widget.isFirst && sortType.isNotEmpty)
                  ...[
                    _routeTypeBadge(context, sortType, l10n),
                    const SizedBox(width: 6),
                  ],
                _chip(context, Icons.train_rounded,
                    '${l10n.sortStops} $stops'),
                const SizedBox(width: 5),
                _chip(context, Icons.access_time_rounded,
                    '${l10n.sortTime} $time min'),
                const SizedBox(width: 5),
                _chip(context, Icons.payments_rounded,
                    '${l10n.sortFare} $fare EGP'),
                const SizedBox(width: 5),
                // Timetable hint chip
                if (!inService)
                  _tintedChip(context, Icons.schedule_rounded,
                      l10n.outsideServiceHours, Colors.orange)
                else if (nextMin != null)
                  _tintedChip(
                    context,
                    Icons.directions_transit_rounded,
                    l10n.nextTrainIn(nextMin),
                    AppTheme.success,
                  ),
              ],
            ),
          ),
        ),
        // Favorite star button
        if (widget.onFavorite != null)
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              widget.onFavorite!();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  key: ValueKey(widget.isFavorite),
                  size: 20,
                  color: widget.isFavorite
                      ? AppTheme.accentGold
                      : (isDark
                          ? AppTheme.darkTextTertiary
                          : Colors.grey.shade400),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _routeTypeBadge(
      BuildContext context, String sortType, AppLocalizations l10n) {
    final (label, icon, color) = switch (sortType) {
      'fastest' => (l10n.routeTypeFastest, Icons.bolt_rounded, AppTheme.success),
      'accessible' => (
        l10n.routeTypeAccessible,
        Icons.accessible_rounded,
        const Color(0xFF5C6BC0)
      ),
      'fewestTransfers' => (
        l10n.routeTypeFewestTransfers,
        Icons.swap_horiz_rounded,
        const Color(0xFFFF8F00)
      ),
      'alternativeRoute' => (
        l10n.routeTypeAlternative,
        Icons.alt_route_rounded,
        const Color(0xFF8D6E63)
      ),
      _ => (sortType, Icons.route_rounded, Colors.grey),
    };
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkElevated : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 12,
              color: isDark ? AppTheme.darkTextSub : Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppTheme.darkTextSub : Colors.grey.shade700,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tintedChip(
      BuildContext context, IconData icon, String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Timeline ───────────────────────────────────────────────────────────────

  List<Widget> _singleLine(BuildContext context) {
    final dep = widget.routeData['Departure']?.toString() ?? '';
    final arr = widget.routeData['Arrival']?.toString() ?? '';
    final line = widget.routeData['Take']?.toString() ?? '';
    final dir = _resolveDirection(context, line, dep, arr);
    final stations =
        (widget.routeData['Intermediate Stations'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList();
    final color = _lineColor(line);

    // hidden = all stops except first and last
    final hiddenStops = stations.length > 2
        ? stations.sublist(1, stations.length - 1)
        : <String>[];

    return [
      _lineLabel(line, color),
      _directionTag(dir, color),
      const SizedBox(height: 8),
      _point(dep, true, color),
      if (hiddenStops.isNotEmpty)
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          firstChild: _collapsedPreview(hiddenStops.length, color),
          secondChild: Column(
            children: [for (final s in hiddenStops) _point(s, false, color)],
          ),
          crossFadeState: _showAllStops
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      if (hiddenStops.isNotEmpty)
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            ),
            onPressed: () => setState(() => _showAllStops = !_showAllStops),
            icon: Icon(
              _showAllStops
                  ? Icons.expand_less_rounded
                  : Icons.more_horiz_rounded,
              size: 16,
            ),
            label: Text(
              _showAllStops
                  ? AppLocalizations.of(context)!.hideStops
                  : '${AppLocalizations.of(context)!.showLabel} ${hiddenStops.length} ${AppLocalizations.of(context)!.stopsWord}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      _point(arr, true, color),
    ];
  }

  List<Widget> _twoLine(BuildContext context) {
    final first = widget.routeData['First take']?.toString() ?? '';
    final second = widget.routeData['Second take']?.toString() ?? '';
    final firstDep = widget.routeData['First Departure']?.toString() ?? '';
    final firstArr = widget.routeData['First Arrival']?.toString() ?? '';
    final secondDep = widget.routeData['Second Departure']?.toString() ?? '';
    final secondArr = widget.routeData['Second Arrival']?.toString() ?? '';
    final firstDir = _resolveDirection(context, first, firstDep, firstArr);
    final secondDir = _resolveDirection(context, second, secondDep, secondArr);
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
      _lineLabel(first, _lineColor(first)),
      _directionTag(firstDir, _lineColor(first)),
      const SizedBox(height: 8),
      if (firstStations.isNotEmpty)
        _point(firstStations.first, true, _lineColor(first)),
      if (changeAt.isNotEmpty) _transfer(changeAt, first, second),
      _lineLabel(second, _lineColor(second)),
      _directionTag(secondDir, _lineColor(second)),
      const SizedBox(height: 8),
      if (secondStations.isNotEmpty)
        _point(secondStations.last, true, _lineColor(second)),
    ];
  }

  List<Widget> _threeLine(BuildContext context) {
    final first = widget.routeData['First take']?.toString() ?? '';
    final second = widget.routeData['Second take']?.toString() ?? '';
    final third = widget.routeData['Third take']?.toString() ?? '';
    final firstDep = widget.routeData['First Departure']?.toString() ?? '';
    final firstArr = widget.routeData['First Arrival']?.toString() ?? '';
    final secondDep = widget.routeData['Second Departure']?.toString() ?? '';
    final secondArr = widget.routeData['Second Arrival']?.toString() ?? '';
    final thirdDep = widget.routeData['Third Departure']?.toString() ?? '';
    final thirdArr = widget.routeData['Third Arrival']?.toString() ?? '';
    final firstDir = _resolveDirection(context, first, firstDep, firstArr);
    final secondDir = _resolveDirection(context, second, secondDep, secondArr);
    final thirdDir = _resolveDirection(context, third, thirdDep, thirdArr);
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
      _lineLabel(first, _lineColor(first)),
      _directionTag(firstDir, _lineColor(first)),
      const SizedBox(height: 8),
      if (firstStations.isNotEmpty)
        _point(firstStations.first, true, _lineColor(first)),
      if (secondStations.isNotEmpty)
        _transfer(secondStations.first, first, second),
      _lineLabel(second, _lineColor(second)),
      _directionTag(secondDir, _lineColor(second)),
      const SizedBox(height: 8),
      if (thirdStations.isNotEmpty)
        _transfer(thirdStations.first, second, third),
      _lineLabel(third, _lineColor(third)),
      _directionTag(thirdDir, _lineColor(third)),
      const SizedBox(height: 8),
      if (thirdStations.isNotEmpty)
        _point(thirdStations.last, true, _lineColor(third)),
    ];
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Calls getLineStartDirection / getLineEndDirection based on which way
  /// the train is travelling (determined by dep/arr indices in the line).
  String _resolveDirection(BuildContext context, String lineName, String dep, String arr) {
    final lineNum = getLineNumber(context, lineName);
    if (lineNum == 0) return '';
    final stations = getLineStations(lineNum);
    final depIdx = stations.indexOf(dep);
    final arrIdx = stations.indexOf(arr);
    if (depIdx == -1 || arrIdx == -1) return '';
    return arrIdx > depIdx
        ? getLineEndDirection(context, lineNum)
        : getLineStartDirection(context, lineNum);
  }

  // ── Sub-widgets ────────────────────────────────────────────────────────────

  Widget _directionTag(String direction, Color color) {
    if (direction.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 6, left: 22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.18 : 0.10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.40), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.navigation_rounded, size: 13, color: color),
            const SizedBox(width: 5),
            Text(
              '${l10n.direction}$direction',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lineLabel(String name, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _point(String station, bool major, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: major ? 11 : 7,
            height: major ? 11 : 7,
            decoration: BoxDecoration(
              color: major
                  ? color
                  : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: major ? 0 : 1.5),
              boxShadow: major
                  ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 4)]
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              station,
              style: TextStyle(
                fontSize: major ? 14 : 13,
                fontWeight: major ? FontWeight.w600 : FontWeight.w400,
                color: major
                    ? cs.onSurface
                    : (isDark ? AppTheme.darkTextSub : Colors.grey.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _collapsedPreview(int count, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 11,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(color),
                const SizedBox(height: 3),
                _dot(color.withOpacity(0.6)),
                const SizedBox(height: 3),
                _dot(color.withOpacity(0.35)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$count ${AppLocalizations.of(context)!.stopsWord}',
            style: TextStyle(
              color: isDark ? AppTheme.darkTextTertiary : Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  Widget _transfer(String at, String from, String to) {
    return TransferGuidanceCard(
      stationName: at,
      fromLine: from,
      toLine: to,
    );
  }

  Widget _buildMapButton(AppLocalizations l10n) {
    final rd = widget.routeData;
    final routeType = int.tryParse(rd['Route type']?.toString() ?? '1') ?? 1;

    // Build per-segment colors and labels from the actual line names in routeData.
    final List<String> segLabels;
    final List<Color> segColors;
    if (routeType == 1) {
      final take = rd['Take']?.toString() ?? '';
      segLabels = [take];
      segColors = [_lineColor(take)];
    } else if (routeType == 2) {
      final t1 = rd['First take']?.toString() ?? '';
      final t2 = rd['Second take']?.toString() ?? '';
      segLabels = [t1, t2];
      segColors = [_lineColor(t1), _lineColor(t2)];
    } else {
      final t1 = rd['First take']?.toString() ?? '';
      final t2 = rd['Second take']?.toString() ?? '';
      final t3 = rd['Third take']?.toString() ?? '';
      segLabels = [t1, t2, t3];
      segColors = [_lineColor(t1), _lineColor(t2), _lineColor(t3)];
    }

    // Build a "DEP → ARR" subtitle for the Stationspage header.
    final dep = routeType == 1
        ? rd['Departure']?.toString()
        : rd['First Departure']?.toString();
    final arr = routeType == 1
        ? rd['Arrival']?.toString()
        : routeType == 2
            ? rd['Second Arrival']?.toString()
            : rd['Third Arrival']?.toString();
    final routeTitle =
        (dep != null && arr != null && dep.isNotEmpty && arr.isNotEmpty)
            ? '$dep  →  $arr'
            : null;

    final totalStops =
        int.tryParse(rd['No. of stations']?.toString() ?? '') ?? 0;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          HapticFeedback.selectionClick();
          Get.to(() => Stationspage(
                serializedData: const [],
                stationNames: _buildStationNames(),
                segmentColors: segColors,
                segmentLabels: segLabels,
                routeTitle: routeTitle,
              ));
        },
        icon: const Icon(Icons.format_list_bulleted_rounded, size: 16),
        label: Text('${l10n.routeAllStops}  ·  $totalStops'),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.primaryNile,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
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
