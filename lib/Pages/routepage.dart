import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:metroappflutter/Controllers/routecontroller.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/widgets/route_timeline.dart';
import 'package:metroappflutter/widgets/skeleton_loader.dart';

// ── Sort options ─────────────────────────────────────────────────────────────

enum _SortBy { stops, time, fare, lines }

extension _SortByX on _SortBy {
  String label(AppLocalizations l10n) => switch (this) {
        _SortBy.stops => l10n.sortStops,
        _SortBy.time => l10n.sortTime,
        _SortBy.fare => l10n.sortFare,
        _SortBy.lines => l10n.sortLines,
      };

  IconData get icon => switch (this) {
        _SortBy.stops => Icons.train_rounded,
        _SortBy.time => Icons.access_time_rounded,
        _SortBy.fare => Icons.payments_rounded,
        _SortBy.lines => Icons.alt_route_rounded,
      };
}

// ── Page ─────────────────────────────────────────────────────────────────────

class Routepage extends StatefulWidget {
  Routepage({super.key});

  @override
  State<Routepage> createState() => _RoutepageState();
}

class _RoutepageState extends State<Routepage> {
  _SortBy _sortBy = _SortBy.stops;

  // ── Sort logic ─────────────────────────────────────────────────────────────

  int _parseInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  double _parseDouble(dynamic v) {
    final s = v?.toString() ?? '';
    // strip any non-numeric suffix like " min", " EGP"
    return double.tryParse(s.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  List<int> _sortedIndices(List<Map<String, dynamic>> routes) {
    final indices = List<int>.generate(routes.length, (i) => i);
    indices.sort((a, b) {
      final ra = routes[a];
      final rb = routes[b];
      return switch (_sortBy) {
        _SortBy.stops => _parseInt(ra['No. of stations'])
            .compareTo(_parseInt(rb['No. of stations'])),
        _SortBy.time => _parseDouble(ra['Estimated travel time'])
            .compareTo(_parseDouble(rb['Estimated travel time'])),
        _SortBy.fare => _parseDouble(ra['Ticket Price'])
            .compareTo(_parseDouble(rb['Ticket Price'])),
        _SortBy.lines => _parseInt(ra['Route type'])
            .compareTo(_parseInt(rb['Route type'])),
      };
    });
    return indices;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = Get.arguments;
    final l10n = AppLocalizations.of(context)!;
    final dep = args['DepartureStation'] ?? '';
    final arr = args['ArrivalStation'] ?? '';

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context, l10n, dep, arr),
          _buildFilterBar(context, l10n),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: getRoutes(
                context,
                dep,
                arr,
                int.tryParse(args['SortType'] ?? '0') ?? 0,
              ),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const RouteSkeletonLoader();
                }
                if (snapshot.hasError) {
                  return _errorState(l10n, snapshot.error);
                }

                final routeDetails = snapshot.data?['allRoutesDetails']
                    as List<Map<String, dynamic>>?;
                final serializedData = snapshot.data?['serializedData']
                    as List<List<List<List<int>>>>?;

                if (routeDetails == null ||
                    serializedData == null ||
                    routeDetails.isEmpty) {
                  return _emptyState(l10n);
                }

                final sorted = _sortedIndices(routeDetails);

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  itemCount: sorted.length,
                  itemBuilder: (_, i) {
                    final idx = sorted[i];
                    return RouteTimeline(
                      routeData: routeDetails[idx],
                      serializedData: serializedData[idx],
                      isFirst: i == 0,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Header (replaces AppBar) ───────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, AppLocalizations l10n,
      String dep, String arr) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF060D1A), const Color(0xFF0D1F2F)]
              : [const Color(0xFF0D3B52), AppTheme.primaryNile],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toolbar
            SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.appTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => HapticFeedback.selectionClick(),
                  ),
                ],
              ),
            ),

            // Dep → Arr strip
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  _stationPill(
                      dep, Icons.radio_button_on_rounded, AppTheme.accentGold),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 16,
                            height: 1.5,
                            color: Colors.white.withOpacity(0.3)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.arrow_forward_rounded,
                              color: Colors.white.withOpacity(0.5), size: 14),
                        ),
                        Container(
                            width: 16,
                            height: 1.5,
                            color: Colors.white.withOpacity(0.3)),
                      ],
                    ),
                  ),
                  _stationPill(arr, Icons.location_on_rounded, AppTheme.line2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stationPill(String name, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 5),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 120),
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ── Filter bar ─────────────────────────────────────────────────────────────

  Widget _buildFilterBar(BuildContext context, AppLocalizations l10n) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = l10n.locale == 'ar';

    return Container(
      color: cs.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryNile.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sort_rounded,
                          size: 14, color: AppTheme.primaryNile),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.sortBy,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryNile,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Active sort label
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _sortBy.label(AppLocalizations.of(context)!),
                    key: ValueKey(_sortBy),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.darkTextTertiary : Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chip strip
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              children: _SortBy.values
                  .map((s) => _filterChip(context, s, isAr))
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: isDark ? AppTheme.darkDivider : Colors.grey.shade100),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, _SortBy sort, bool isAr) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = _sortBy == sort;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryNile
              : (isDark ? AppTheme.darkElevated : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppTheme.primaryNile
                : (isDark ? AppTheme.darkBorder : Colors.grey.shade200),
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.primaryNile.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _sortBy = sort);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    sort.icon,
                    key: ValueKey(isActive),
                    size: 15,
                    color: isActive
                        ? Colors.white
                        : (isDark ? AppTheme.darkTextTertiary : Colors.grey.shade500),
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? Colors.white
                        : (isDark ? AppTheme.darkTextSub : Colors.grey.shade600),
                    fontFamily: 'Tajawal',
                  ),
                  child: Text(sort.label(AppLocalizations.of(context)!)),
                ),
                if (isActive) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── States ─────────────────────────────────────────────────────────────────

  Widget _errorState(AppLocalizations l10n, Object? error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 48, color: AppTheme.error.withOpacity(0.6)),
            const SizedBox(height: 12),
            Text(
              '${l10n.error} $error',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? AppTheme.darkTextSub : Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.route_rounded,
                size: 48,
                color: isDark ? AppTheme.darkBorder : Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              l10n.noRoutesFound,
              style: TextStyle(
                color: isDark ? AppTheme.darkTextTertiary : Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
