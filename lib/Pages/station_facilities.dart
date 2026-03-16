import 'dart:convert';
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

String _translateFacilityCategory(String name, AppLocalizations l10n) {
  switch (name) {
    case 'Commercial': return l10n.facilityCommercial;
    case 'Cultural': return l10n.facilityCultural;
    case 'Educational': return l10n.facilityEducational;
    case 'Landmarks': return l10n.facilityLandmarks;
    case 'Medical': return l10n.facilityMedical;
    case 'Public Institutions': return l10n.facilityPublicInstitutions;
    case 'Public Spaces': return l10n.facilityPublicSpaces;
    case 'Religious': return l10n.facilityReligious;
    case 'Services': return l10n.facilityServices;
    case 'Sport Facilities': return l10n.facilitySportFacilities;
    case 'Streets': return l10n.facilityStreets;
    default: return name;
  }
}

// ── Data models ──────────────────────────────────────────────────────────────

class _FacilityCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<_FacilityItem> items;
  _FacilityCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.items,
  });
}

class _FacilityItem {
  final String name;
  final String? category;
  final String? description;
  final String? directions;
  final String? mapHint;
  final double? lat;
  final double? lng;

  _FacilityItem({
    required this.name,
    this.category,
    this.description,
    this.directions,
    this.mapHint,
    this.lat,
    this.lng,
  });

  factory _FacilityItem.fromEntry(String key, Map<String, dynamic> data) {
    return _FacilityItem(
      name: key,
      category: data['category'] as String?,
      description: data['description'] as String?,
      directions: data['directions'] as String?,
      mapHint: data['map_hint'] as String?,
      lat: (data['lat'] as num?)?.toDouble(),
      lng: (data['lng'] as num?)?.toDouble(),
    );
  }

  bool get hasLocation => lat != null && lng != null;
}

// ── Category metadata ────────────────────────────────────────────────────────

const _categoryMeta = <String, (IconData, Color)>{
  'religious': (Icons.mosque_rounded, Color(0xFF2E7D32)),
  'medical': (Icons.local_hospital_rounded, Color(0xFFD32F2F)),
  'cultural': (Icons.theater_comedy_rounded, Color(0xFF7B1FA2)),
  'commercial': (Icons.shopping_bag_rounded, Color(0xFFE65100)),
  'public spaces': (Icons.park_rounded, Color(0xFF388E3C)),
  'sport facilities': (Icons.sports_soccer_rounded, Color(0xFF1565C0)),
  'educational': (Icons.school_rounded, Color(0xFF0277BD)),
  'services': (Icons.support_agent_rounded, Color(0xFF00838F)),
  'landmarks': (Icons.account_balance_rounded, Color(0xFF4E342E)),
  'public institutions': (Icons.apartment_rounded, Color(0xFF37474F)),
  'streets': (Icons.route_rounded, Color(0xFF546E7A)),
};

(IconData, Color) _metaFor(String category) {
  return _categoryMeta[category.toLowerCase()] ??
      (Icons.place_rounded, AppTheme.primaryNile);
}

// ── Main page ────────────────────────────────────────────────────────────────

class StationFacilitiesPage extends StatefulWidget {
  final String stationNameEN;
  final String stationNameLang;

  const StationFacilitiesPage({
    super.key,
    required this.stationNameEN,
    required this.stationNameLang,
  });

  @override
  State<StationFacilitiesPage> createState() => _StationFacilitiesPageState();
}

class _StationFacilitiesPageState extends State<StationFacilitiesPage> {
  final List<_FacilityCategory> _categories = [];
  String? _activeFilter;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();
  bool _loading = true;
  bool _noData = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase().trim());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loading) _loadData();
  }

  Future<void> _loadData() async {
    final jsonStr = await rootBundle
        .loadString('assets/data/full_cairo_metro_template2.json');
    final Map<String, dynamic> allData = json.decode(jsonStr);
    final locale = AppLocalizations.of(context)!.locale;
    final key = '${locale}_metroStation${widget.stationNameEN}';
    final stationData = (allData[key] ?? allData['en_metroStation${widget.stationNameEN}'])
        as Map<String, dynamic>?;

    if (stationData == null || stationData.isEmpty) {
      setState(() {
        _loading = false;
        _noData = true;
      });
      return;
    }

    // Group by category
    final Map<String, List<_FacilityItem>> grouped = {};
    stationData.forEach((k, v) {
      if (v is! Map<String, dynamic>) return;
      final cat = (v['category'] as String?) ?? 'Other';
      grouped.putIfAbsent(cat, () => []);
      grouped[cat]!.add(_FacilityItem.fromEntry(k, v));
    });

    final cats = <_FacilityCategory>[];
    grouped.forEach((catName, items) {
      final meta = _metaFor(catName);
      cats.add(_FacilityCategory(
        name: catName,
        icon: meta.$1,
        color: meta.$2,
        items: items,
      ));
    });

    // Sort categories: more items first, 'Streets' last
    cats.sort((a, b) {
      if (a.name.toLowerCase() == 'streets') return 1;
      if (b.name.toLowerCase() == 'streets') return -1;
      return b.items.length.compareTo(a.items.length);
    });

    setState(() {
      _categories.addAll(cats);
      _loading = false;
    });
  }

  List<_FacilityCategory> get _filtered {
    var cats = _categories;
    if (_activeFilter != null) {
      cats = cats.where((c) => c.name == _activeFilter).toList();
    }
    if (_searchQuery.isEmpty) return cats;
    return cats
        .map((c) {
          final matched = c.items
              .where((i) =>
                  i.name.toLowerCase().contains(_searchQuery) ||
                  (i.description?.toLowerCase().contains(_searchQuery) ??
                      false))
              .toList();
          if (matched.isEmpty) return null;
          return _FacilityCategory(
              name: c.name, icon: c.icon, color: c.color, items: matched);
        })
        .whereType<_FacilityCategory>()
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.locale == 'ar';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(l10n, isAr),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_noData)
            SliverFillRemaining(child: _buildNoData(l10n, isAr))
          else ...[
            SliverToBoxAdapter(child: _buildSearchBar(l10n, isAr)),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            SliverToBoxAdapter(child: _buildStats(l10n, isAr)),
            ..._buildFacilityList(),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ],
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────

  String get _imagePath => 'assets/stations/line3/${widget.stationNameEN}.jpg';

  void _openImageViewer(bool isAr) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  child: Image.asset(
                    _imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 54,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: isAr ? null : 8,
                left: isAr ? 8 : null,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.facilityZoomHint,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n, bool isAr) {
    final totalPlaces =
        _categories.fold<int>(0, (sum, c) => sum + c.items.length);
    const expandedH = 200.0;

    return SliverAppBar(
      expandedHeight: expandedH,
      pinned: true,
      backgroundColor: AppTheme.primaryNile,
      elevation: 0,
      title: const SizedBox.shrink(),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 20, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final topPad = MediaQuery.of(context).padding.top;
          final minH = kToolbarHeight + topPad;
          final maxH = expandedH + topPad;
          final t =
              ((constraints.maxHeight - minH) / (maxH - minH)).clamp(0.0, 1.0);

          final textBottom = lerpDouble(10, 10, t)!;
          final textLeft = lerpDouble(56.0, 35.0, t)!;
          final titleSize = lerpDouble(15.0, 20.0, t)!;
          final subtitleOpacity = 1.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _imagePath,
                fit: BoxFit.cover,
                cacheWidth: 900,
                errorBuilder: (_, __, ___) => const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0D3B52),
                        AppTheme.primaryNile,
                        Color(0xFF1E7A8A),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.45, 1.0],
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.transparent,
                      Colors.black.withOpacity(0.72),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: -40,
                top: -20,
                child: Opacity(
                  opacity: t,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 40,
                bottom: -30,
                child: Opacity(
                  opacity: t,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 24,
                top: topPad + 8,
                child: Opacity(
                  opacity: 0.12 * t,
                  child: const Icon(
                    Icons.place_rounded,
                    size: 88,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: isAr ? null : 16,
                left: isAr ? 16 : null,
                bottom: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.zoom_in_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.zoomLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: textLeft,
                right: 20,
                bottom: textBottom,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stationNameLang,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (subtitleOpacity > 0)
                      Opacity(
                        opacity: subtitleOpacity,
                        child: Text(
                          '$totalPlaces ${l10n.facilityPlacesCount} • ${_categories.length} ${l10n.facilityCategoriesLabel}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openImageViewer(isAr),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── No data state ──────────────────────────────────────────────────────────

  Widget _buildNoData(AppLocalizations l10n, bool isAr) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_rounded,
                size: 64,
                color: isDark ? AppTheme.darkBorder : Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              l10n.facilityNoData,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppTheme.darkTextSub : Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.facilityDataSoon,
              style: TextStyle(
                  fontSize: 13,
                  color:
                      isDark ? AppTheme.darkTextTertiary : Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────

  Widget _buildSearchBar(AppLocalizations l10n, bool isAr) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isDark ? AppTheme.darkBorder : Colors.grey.shade200),
        ),
        child: TextField(
          controller: _searchCtrl,
          style: TextStyle(
              color: isDark ? AppTheme.darkText : Colors.grey.shade900,
              fontSize: 14),
          decoration: InputDecoration(
            hintText: l10n.facilitySearchHint,
            hintStyle: TextStyle(
                color: isDark ? AppTheme.darkTextTertiary : Colors.grey.shade400,
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  // ── Category chips ─────────────────────────────────────────────────────────

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        itemCount: _categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final l10n = AppLocalizations.of(context)!;
          if (i == 0) {
            final isActive = _activeFilter == null;
            return _chip(
              label: l10n.touristGuideCategoryAll,
              icon: Icons.grid_view_rounded,
              color: AppTheme.primaryNile,
              isActive: isActive,
              onTap: () => setState(() => _activeFilter = null),
            );
          }
          final cat = _categories[i - 1];
          final isActive = _activeFilter == cat.name;
          return _chip(
            label: _translateFacilityCategory(cat.name, l10n),
            icon: cat.icon,
            color: cat.color,
            isActive: isActive,
            count: cat.items.length,
            onTap: () =>
                setState(() => _activeFilter = isActive ? null : cat.name),
          );
        },
      ),
    );
  }

  Widget _chip({
    required String label,
    required IconData icon,
    required Color color,
    required bool isActive,
    int? count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? color
              : (Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkElevated
                  : AppTheme.lightCard),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? color
                : (Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkBorder
                    : Colors.grey.shade200),
          ),
          boxShadow: isActive
              ? [BoxShadow(color: color.withOpacity(0.25), blurRadius: 8)]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: isActive ? Colors.white : color),
            const SizedBox(width: 5),
            Text(
              count != null ? '$label ($count)' : label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkTextSub
                        : Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Stats bar ──────────────────────────────────────────────────────────────

  Widget _buildStats(AppLocalizations l10n, bool isAr) {
    final filteredCount =
        _filtered.fold<int>(0, (sum, c) => sum + c.items.length);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryNile.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$filteredCount ${l10n.facilityPlacesCount}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryNile,
              ),
            ),
          ),
          if (_activeFilter != null || _searchQuery.isNotEmpty) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _activeFilter = null;
                  _searchCtrl.clear();
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close_rounded, size: 12, color: AppTheme.error),
                    const SizedBox(width: 4),
                    Text(
                      l10n.facilityClearFilter,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Facility list by category ──────────────────────────────────────────────

  List<Widget> _buildFacilityList() {
    final cats = _filtered;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    if (cats.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded,
                    size: 48,
                    color: isDark
                        ? AppTheme.darkBorder
                        : Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context)!.touristGuideNoPlaces,
                    style: TextStyle(
                        color: isDark
                            ? AppTheme.darkTextTertiary
                            : Colors.grey.shade400,
                        fontSize: 14)),
              ],
            ),
          ),
        ),
      ];
    }

    final widgets = <Widget>[];
    for (final cat in cats) {
      // Category header
      widgets.add(SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cat.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(cat.icon, size: 18, color: cat.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _translateFacilityCategory(cat.name, l10n),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppTheme.darkText
                        : Colors.grey.shade800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cat.color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cat.items.length}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: cat.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));

      // Facility cards
      widgets.add(SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, i) => _facilityCard(cat.items[i], cat.color),
          childCount: cat.items.length,
        ),
      ));
    }
    return widgets;
  }

  // ── Single facility card ───────────────────────────────────────────────────

  Widget _facilityCard(_FacilityItem item, Color catColor) {
    final isStreet = item.category?.toLowerCase() == 'streets';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showDetails(item, catColor),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isStreet
                        ? Icons.route_rounded
                        : _metaFor(item.category ?? '').$1,
                    size: 20,
                    color: catColor,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppTheme.darkText
                              : Colors.grey.shade800,
                        ),
                      ),
                      if (item.description != null &&
                          item.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppTheme.darkTextSub
                                : Colors.grey.shade500,
                            height: 1.3,
                          ),
                        ),
                      ],
                      if (item.directions != null &&
                          item.directions!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.directions_walk_rounded,
                                size: 13, color: AppTheme.primaryNile),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.directions!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.primaryNile,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Map button
                if (item.hasLocation)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () => _openMaps(item),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryNile.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.map_rounded,
                            size: 18, color: AppTheme.primaryNile),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Detail bottom sheet ────────────────────────────────────────────────────

  void _showDetails(_FacilityItem item, Color catColor) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.locale == 'ar';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBorder : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name + category badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_metaFor(item.category ?? '').$1,
                      size: 22, color: catColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppTheme.darkText
                              : Colors.grey.shade800,
                        ),
                      ),
                      if (item.category != null)
                        Text(
                          _translateFacilityCategory(item.category!, l10n),
                          style: TextStyle(
                            fontSize: 12,
                            color: catColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            if (item.description != null && item.description!.isNotEmpty) ...[
              Text(
                item.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppTheme.darkTextSub : Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Directions
            if (item.directions != null && item.directions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryNile.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppTheme.primaryNile.withOpacity(0.1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.directions_walk_rounded,
                        size: 18, color: AppTheme.primaryNile),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.directions!,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryNile,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Map hint
            if (item.mapHint != null && item.mapHint!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 14,
                      color: isDark
                          ? AppTheme.darkTextTertiary
                          : Colors.grey.shade400),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.mapHint!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppTheme.darkTextTertiary
                            : Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 18),

            // Action buttons
            Row(
              children: [
                if (item.hasLocation)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openMaps(item);
                      },
                      icon: const Icon(Icons.map_rounded, size: 18),
                      label: Text(
                        l10n.googleMapsLabel,
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryNile,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (item.hasLocation) const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppTheme.darkTextSub
                          : Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                          color: isDark
                              ? AppTheme.darkBorder
                              : Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        Text(l10n.close, style: const TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
      }, // builder
    );
  }

  // ── Open Google Maps ───────────────────────────────────────────────────────

  Future<void> _openMaps(_FacilityItem item) async {
    if (!item.hasLocation) return;
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${item.lat},${item.lng}',
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
