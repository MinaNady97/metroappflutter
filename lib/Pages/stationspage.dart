import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

class Stationspage extends StatefulWidget {
  final List<List<List<int>>> serializedData;

  /// Station names per segment — primary data when serializedData is empty.
  final List<List<String>>? stationNames;

  /// Per-segment line colors derived from the actual route lines.
  final List<Color>? segmentColors;

  /// Per-segment labels (localized line names) shown as segment headers.
  final List<String>? segmentLabels;

  /// "DEPARTURE → ARRIVAL" title string shown in the app bar subtitle.
  final String? routeTitle;

  const Stationspage({
    super.key,
    required this.serializedData,
    this.stationNames,
    this.segmentColors,
    this.segmentLabels,
    this.routeTitle,
  });

  @override
  State<Stationspage> createState() => _StationspageState();
}

class _StationspageState extends State<Stationspage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final List<Map<String, dynamic>> _stationsByLine = [];
  List<Map<String, dynamic>> _filtered = [];

  @override
  void initState() {
    super.initState();
    _buildData();
    _searchCtrl.addListener(_filter);
  }

  void _buildData() {
    // Prefer stationNames when serializedData is empty (new routing engine path).
    final useNamesOnly =
        widget.serializedData.isEmpty && widget.stationNames != null;
    final segCount = useNamesOnly
        ? widget.stationNames!.length
        : widget.serializedData.length;

    for (int i = 0; i < segCount; i++) {
      final names = widget.stationNames?[i] ?? [];
      final segLen =
          useNamesOnly ? names.length : widget.serializedData[i].length;

      final stations = List.generate(segLen, (j) {
        final name = j < names.length ? names[j] : 'Station ${j + 1}';
        return {
          'name': name,
          'isFirst': j == 0,
          'isLast': j == segLen - 1,
        };
      });

      _stationsByLine.add({
        'segmentIndex': i,
        'color':
            widget.segmentColors != null && i < widget.segmentColors!.length
                ? widget.segmentColors![i]
                : _segmentColor(i),
        'label':
            widget.segmentLabels != null && i < widget.segmentLabels!.length
                ? widget.segmentLabels![i]
                : null,
        'stations': stations,
      });
    }
    _filtered = List.from(_stationsByLine);
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(_stationsByLine);
      } else {
        _filtered = _stationsByLine
            .map((seg) {
              final list = (seg['stations'] as List)
                  .where((s) => s['name'].toString().toLowerCase().contains(q))
                  .toList();
              return {...seg, 'stations': list};
            })
            .where((seg) => (seg['stations'] as List).isNotEmpty)
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primaryNile,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 12,
        title: Row(
          children: [
            // Labeled back button — clearly looks like a button
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.routeAllStops,
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.routeTitle != null)
                    Text(
                      widget.routeTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.noScaling,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ─────────────────────────────────────────────────────
          Container(
            color: cs.surface,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkCard : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isDark ? AppTheme.darkBorder : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      style: TextStyle(color: cs.onSurface, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: l10n.searchStationsHint,
                        hintStyle: TextStyle(
                            color: isDark
                                ? AppTheme.darkTextTertiary
                                : Colors.grey.shade400,
                            fontSize: 14),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: AppTheme.primaryNile, size: 20),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close_rounded,
                                    color: isDark
                                        ? AppTheme.darkTextTertiary
                                        : Colors.grey.shade400,
                                    size: 18),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 13),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Thin divider between search and list
          Divider(
              height: 1,
              color: isDark ? AppTheme.darkDivider : Colors.grey.shade100),

          // Station list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      l10n.noStationsFound,
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.darkTextTertiary
                            : Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, idx) =>
                        _buildSegmentCard(ctx, _filtered[idx]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentCard(BuildContext context, Map<String, dynamic> seg) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = seg['color'] as Color;
    final stations = seg['stations'] as List;
    final segIdx = seg['segmentIndex'] as int;
    final segLabel = (seg['label'] as String?) ?? _segmentLabel(segIdx);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border:
            isDark ? Border.all(color: AppTheme.darkBorder, width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segment header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.4), blurRadius: 6)
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    segLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${stations.length}',
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Station items
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: List.generate(stations.length, (i) {
                final s = stations[i] as Map<String, dynamic>;
                final isFirst = s['isFirst'] as bool;
                final isLast = s['isLast'] as bool;
                final isMajor = isFirst || isLast;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Timeline column
                      SizedBox(
                        width: 24,
                        child: Column(
                          children: [
                            // Top connector
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: 2,
                                  color: i == 0
                                      ? Colors.transparent
                                      : color.withOpacity(0.25),
                                ),
                              ),
                            ),
                            // Dot
                            Container(
                              width: isMajor ? 12 : 8,
                              height: isMajor ? 12 : 8,
                              decoration: BoxDecoration(
                                color: isMajor
                                    ? color
                                    : (isDark
                                        ? AppTheme.darkCard
                                        : AppTheme.lightCard),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: color, width: isMajor ? 0 : 1.5),
                                boxShadow: isMajor
                                    ? [
                                        BoxShadow(
                                            color: color.withOpacity(0.35),
                                            blurRadius: 4)
                                      ]
                                    : null,
                              ),
                            ),
                            // Bottom connector
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: 2,
                                  color: i == stations.length - 1
                                      ? Colors.transparent
                                      : color.withOpacity(0.25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Station name
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s['name'].toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textScaler: TextScaler.noScaling,
                                  style: TextStyle(
                                    fontSize: isMajor ? 14 : 13,
                                    fontWeight: isMajor
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isMajor
                                        ? cs.onSurface
                                        : (isDark
                                            ? AppTheme.darkTextSub
                                            : Colors.grey.shade700),
                                  ),
                                ),
                              ),
                              if (isMajor) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isFirst ? 'DEP' : 'ARR',
                                    textScaler: TextScaler.noScaling,
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Color _segmentColor(int i) {
    switch (i) {
      case 0:
        return AppTheme.line1;
      case 1:
        return AppTheme.line2;
      case 2:
        return AppTheme.line3;
      default:
        return AppTheme.lrt;
    }
  }

  String _segmentLabel(int i) {
    final total = _stationsByLine.length;
    if (total == 1) return 'Direct Route';
    switch (i) {
      case 0:
        return 'Segment 1';
      case 1:
        return 'Segment 2';
      case 2:
        return 'Segment 3';
      default:
        return 'Segment ${i + 1}';
    }
  }
}
