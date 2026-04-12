import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:metroappflutter/Controllers/homepagecontroller.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/domain/repositories/metro_repository.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/services/location_service.dart';
import 'package:metroappflutter/services/route_service.dart';
import 'package:metroappflutter/tour/tour_keys.dart';
import 'package:metroappflutter/widgets/route_timeline.dart';
import 'package:metroappflutter/widgets/skeleton_loader.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late HomepageController _homeCtrl;
  bool _mapsLoading = false;

  @override
  void initState() {
    super.initState();
    _homeCtrl = Get.find<HomepageController>();
  }

  // ── Google Maps: arrival station → user's searched destination ──────────────

  Future<void> _openMapsLastMile(
      String arrName, double destLat, double destLng, String mode) async {
    if (!mounted) return;
    try {
      final repo = Get.find<MetroRepository>();
      final matches = await repo.searchStations(arrName);
      if (matches.isEmpty) throw Exception('Station not found');
      final station = matches.first;
      final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&origin=${station.latitude},${station.longitude}'
        '&destination=$destLat,$destLng'
        '&travelmode=$mode',
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)?.addressNotFound ?? 'Error'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.error,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        );
      }
    }
  }

  void _showLastMileSheet(BuildContext context, String arrName,
      double destLat, double destLng, String destName, AppLocalizations l10n) {
    HapticFeedback.selectionClick();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RouteDirectionsSheet(
        l10n: l10n,
        isDark: isDark,
        stationName: arrName,
        destinationName: destName,
        onWalking: () {
          Navigator.pop(context);
          _openMapsLastMile(arrName, destLat, destLng, 'walking');
        },
        onDriving: () {
          Navigator.pop(context);
          _openMapsLastMile(arrName, destLat, destLng, 'driving');
        },
      ),
    );
  }

  // ── Google Maps: user location → departure station ─────────────────────────

  Future<void> _openMapsToStation(String depName, String mode) async {
    if (!mounted) return;
    setState(() => _mapsLoading = true);
    try {
      // 1. Get current user location
      final userPos = await LocationService.instance.getUserLocation();

      // 2. Look up departure station coordinates via repository
      final repo = Get.find<MetroRepository>();
      final matches = await repo.searchStations(depName);
      if (matches.isEmpty) throw Exception('Station not found');
      final station = matches.first;

      // 3. Open Google Maps
      final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&origin=${userPos.latitude},${userPos.longitude}'
        '&destination=${station.latitude},${station.longitude}'
        '&travelmode=$mode',
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)?.addressNotFound ?? 'Error'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.error,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _mapsLoading = false);
    }
  }

  void _showMapsSheet(BuildContext context, String depName,
      AppLocalizations l10n) {
    HapticFeedback.selectionClick();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RouteDirectionsSheet(
        l10n: l10n,
        isDark: isDark,
        stationName: depName,
        onWalking: () {
          Navigator.pop(context);
          _openMapsToStation(depName, 'walking');
        },
        onDriving: () {
          Navigator.pop(context);
          _openMapsToStation(depName, 'driving');
        },
      ),
    );
  }

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
        _SortBy.stops => () {
            final sc = _parseInt(ra['No. of stations'])
                .compareTo(_parseInt(rb['No. of stations']));
            if (sc != 0) return sc;
            // tiebreaker: fewer line changes first
            return _parseInt(ra['Route type'])
                .compareTo(_parseInt(rb['Route type']));
          }(),
        _SortBy.time => _parseDouble(ra['Estimated travel time'])
            .compareTo(_parseDouble(rb['Estimated travel time'])),
        _SortBy.fare => _parseDouble(ra['Ticket Price'])
            .compareTo(_parseDouble(rb['Ticket Price'])),
        _SortBy.lines =>
          _parseInt(ra['Route type']).compareTo(_parseInt(rb['Route type'])),
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
    final preferAccessible = args['PreferAccessible'] == '1';
    final destLat = double.tryParse(args['DestLat'] ?? '');
    final destLng = double.tryParse(args['DestLng'] ?? '');
    final destName = args['DestName'] ?? '';
    final hasLastMile = destLat != null && destLng != null;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context, l10n, dep, arr),
          // _buildFilterBar(context, l10n), // hidden — sorting N routes is not meaningful
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: RouteService.instance.findRoutes(
                context,
                dep,
                arr,
                int.tryParse(args['SortType'] ?? '0') ?? 0,
                preferAccessible: preferAccessible,
              ),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const RouteSkeletonLoader();
                }
                if (snapshot.hasError) {
                  return _errorState(l10n, snapshot.error);
                }

                final rawRoutes = snapshot.data?['allRoutesDetails'];
                final routeDetails = rawRoutes == null
                    ? null
                    : (rawRoutes as List)
                        .map((e) => Map<String, dynamic>.from(e as Map))
                        .toList();
                final rawSerial = snapshot.data?['serializedData'];
                final serializedData = rawSerial == null
                    ? null
                    : (rawSerial as List)
                        .map((route) => (route as List)
                            .map((seg) => (seg as List)
                                .map((coord) => (coord as List)
                                    .map((v) => v as int)
                                    .toList())
                                .toList())
                            .toList())
                        .toList();

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
                    final rd = routeDetails[idx];
                    if (i == 0) {
                      // Only the first route has a favorite button — wrap
                      // only this item in Obx so GetX tracks the narrow scope.
                      return KeyedSubtree(
                        key: TourKeys.firstRouteCard,
                        child: Obx(() {
                        final isFav = _homeCtrl.favoriteRoutes.any(
                            (f) => f.dep == dep && f.arr == arr);
                        return RouteTimeline(
                          routeData: rd,
                          serializedData: serializedData[idx],
                          isFirst: true,
                          isFavorite: isFav,
                          onFavorite: () {
                            _homeCtrl.toggleFavorite(dep, arr);
                            final l10n = AppLocalizations.of(context)!;
                            ScaffoldMessenger.maybeOf(context)
                                ?.showSnackBar(SnackBar(
                              content: Text(isFav
                                  ? l10n.routeUnsaved
                                  : l10n.routeSaved),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: isFav
                                  ? Colors.grey.shade700
                                  : AppTheme.success,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ));
                          },
                        );
                      }),    // end Obx
                      );     // end KeyedSubtree
                    }
                    return RouteTimeline(
                      routeData: rd,
                      serializedData: serializedData[idx],
                      isFirst: false,
                    );
                  },
                );
              },
            ),
          ),

          // ── Directions card: both legs grouped together ──────────────────
          _buildDirectionsCard(
            context, l10n, dep, arr,
            destLat: hasLastMile ? destLat : null,
            destLng: hasLastMile ? destLng : null,
            destName: destName,
          ),
        ],
      ),
    );
  }

  // ── Directions card (both legs stacked) ───────────────────────────────────

  Widget _buildDirectionsCard(
    BuildContext context,
    AppLocalizations l10n,
    String dep,
    String arr, {
    double? destLat,
    double? destLng,
    String destName = '',
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final hasLastMile = destLat != null && destLng != null;

    return Container(
      key: TourKeys.directionsCard,
      color: cs.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1,
              color: isDark ? AppTheme.darkDivider : Colors.grey.shade100),

          // ── Row 1: current location → departure station ──────────────────
          _DirectionRow(
            icon: Icons.my_location_rounded,
            iconColor: AppTheme.primaryNile,
            label: dep,
            sublabel: l10n.walkingDirections,
            isDark: isDark,
            loading: _mapsLoading,
            onTap: () => _showMapsSheet(context, dep, l10n),
          ),

          // ── Row 2: arrival station → searched destination ────────────────
          if (hasLastMile) ...[
            Divider(
              height: 1,
              indent: 56,
              color: isDark ? AppTheme.darkDivider : Colors.grey.shade100,
            ),
            _DirectionRow(
              icon: Icons.near_me_rounded,
              iconColor: AppTheme.accentGold,
              label: arr,
              sublabel: destName.isNotEmpty ? destName : l10n.destinationFieldLabel,
              isDark: isDark,
              loading: false,
              onTap: () => _showLastMileSheet(
                  context, arr, destLat, destLng, destName, l10n),
            ),
          ],
        ],
      ),
    );
  }

  // ── Header (replaces AppBar) ───────────────────────────────────────────────

  Widget _buildHeader(
      BuildContext context, AppLocalizations l10n, String dep, String arr) {
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
                      color: isDark
                          ? AppTheme.darkTextTertiary
                          : Colors.grey.shade500,
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
          Divider(
              height: 1,
              color: isDark ? AppTheme.darkDivider : Colors.grey.shade100),
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
                        : (isDark
                            ? AppTheme.darkTextTertiary
                            : Colors.grey.shade500),
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? Colors.white
                        : (isDark
                            ? AppTheme.darkTextSub
                            : Colors.grey.shade600),
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
                color:
                    isDark ? AppTheme.darkTextTertiary : Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable direction row inside the bottom card ────────────────────────────

class _DirectionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String sublabel;
  final bool isDark;
  final bool loading;
  final VoidCallback onTap;

  const _DirectionRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sublabel,
    required this.isDark,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 17, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppTheme.darkText
                            : AppTheme.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      sublabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppTheme.darkTextSub
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                size: 15,
                color: isDark
                    ? AppTheme.darkTextTertiary
                    : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Directions sheet: current location → departure station ───────────────────

class _RouteDirectionsSheet extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDark;
  final String stationName;
  /// When non-empty, shows "stationName → destinationName" instead of
  /// "currentLocation → stationName" (used for the last-mile leg).
  final String destinationName;
  final VoidCallback onWalking;
  final VoidCallback onDriving;

  const _RouteDirectionsSheet({
    required this.l10n,
    required this.isDark,
    required this.stationName,
    this.destinationName = '',
    required this.onWalking,
    required this.onDriving,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppTheme.darkCard : Colors.white;
    final textColor = isDark ? AppTheme.darkText : AppTheme.lightTextPrimary;
    final subColor = isDark ? AppTheme.darkTextSub : Colors.grey.shade500;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryNile.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.my_location_rounded,
                      color: AppTheme.primaryNile, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.getDirections,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            destinationName.isNotEmpty
                                ? '$stationName  →  '
                                : '${l10n.currentLocation}  →  ',
                            style: TextStyle(fontSize: 12, color: subColor),
                          ),
                          Flexible(
                            child: Text(
                              destinationName.isNotEmpty
                                  ? destinationName
                                  : stationName,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryNile),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(
              height: 1,
              color: isDark ? AppTheme.darkDivider : Colors.grey.shade100),
          const SizedBox(height: 8),

          _DirectionOption(
            icon: Icons.directions_walk_rounded,
            label: l10n.walkingDirections,
            color: const Color(0xFF2E7D32),
            isDark: isDark,
            onTap: onWalking,
          ),
          _DirectionOption(
            icon: Icons.directions_car_rounded,
            label: l10n.drivingDirections,
            color: AppTheme.primaryNile,
            isDark: isDark,
            onTap: onDriving,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _DirectionOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _DirectionOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
              ),
            ),
            const Spacer(),
            Icon(Icons.open_in_new_rounded,
                size: 16,
                color: isDark
                    ? AppTheme.darkTextTertiary
                    : Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

