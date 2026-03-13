import 'dart:convert';
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:metroappflutter/Pages/station_facilities.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

// ── Station entry with EN key, localized name, and facility count ─────────

class _StationEntry {
  final String jsonName; // e.g. "ADLY MANSOUR" — used as stationNameEN
  final String displayName; // localized name
  final int facilityCount;
  final Set<String> categories;

  _StationEntry({
    required this.jsonName,
    required this.displayName,
    required this.facilityCount,
    required this.categories,
  });
}

// ── EN name → ARB localized name mapping ─────────────────────────────────

Map<String, String> _buildLocalizedMap(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return {
    'ADLY MANSOUR': l10n.metroStationADLY_MANSOUR,
    'EL-HAYKSTEP': l10n.metroStationEL_HAYKSTEP,
    'OMAR IBN EL-KHATTAB': l10n.metroStationOMAR_IBN_EL_KHATTAB,
    'QOBA': l10n.metroStationQOBA,
    'HESHAM BARAKAT': l10n.metroStationHESHAM_BARAKAT,
    'EL-NOZHA': l10n.metroStationEL_NOZHA,
    'NADI EL-SHAMS': l10n.metroStationNADI_EL_SHAMS,
    'ALF MASKAN': l10n.metroStationALF_MASKAN,
    'HELIOPOLIS': l10n.metroStationHELIOPOLIS,
    'HAROUN': l10n.metroStationHAROUN,
    'EL-AHRAM': l10n.metroStationEL_AHRAM,
    'KOLLEYET EL-BANAT': l10n.metroStationKOLLEYET_EL_BANAT,
    'EL-ESTAD': l10n.metroStationEL_ESTAD,
    'ARD EL-MAARD': l10n.metroStationARD_EL_MAARD,
    'ABASIA': l10n.metroStationABASIA,
    'ABDO BASHA': l10n.metroStationABDO_BASHA,
    'EL-GEISH': l10n.metroStationEL_GEISH,
    'BAB EL-SHARIA': l10n.metroStationBAB_EL_SHARIA,
    'ATABA': l10n.metroStationATABA,
    'GAMAL ABD EL-NASSER': l10n.metroStationGAMAL_ABD_EL_NASSER,
    'MASPERO': l10n.metroStationMASPERO,
    'SAFAA HEGAZI': l10n.metroStationSAFAA_HEGAZI,
    'KIT KAT': l10n.metroStationKIT_KAT,
    'SUDAN': l10n.metroStationSUDAN,
    'IMBABA': l10n.metroStationIMBABA,
    'EL_BOHY': l10n.metroStationEL_BOHY,
    'EL_QAWMEYA': l10n.metroStationEL_QAWMEYA,
    'EL_TARIQ_EL_DAIRY': l10n.metroStationEL_TARIQ_EL_DAIRY,
    'ROD_EL_FARAG_AXIS': l10n.metroStationROD_EL_FARAG_AXIS,
    'EL_TOUFIQIA': l10n.metroStationEL_TOUFIQIA,
    'WADI_EL_NIL': l10n.metroStationWADI_EL_NIL,
    'GAMAET_EL_DOWL_EL_ARABIA': l10n.metroStationGAMAET_EL_DOWL_EL_ARABIA,
    'BOLAK_EL_DAKROUR': l10n.metroStationBOLAK_EL_DAKROUR,
    'CAIRO_UNIVERSITY': l10n.metroStationCAIRO_UNIVERSITY,
  };
}

// ── Main page ────────────────────────────────────────────────────────────────

class StationExplorerPage extends StatefulWidget {
  const StationExplorerPage({super.key});

  @override
  State<StationExplorerPage> createState() => _StationExplorerPageState();
}

class _StationExplorerPageState extends State<StationExplorerPage> {
  final List<_StationEntry> _stations = [];
  List<_StationEntry> _filtered = [];
  final TextEditingController _searchCtrl = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loading) _loadStations();
  }

  Future<void> _loadStations() async {
    final jsonStr = await rootBundle
        .loadString('assets/data/full_cairo_metro_template2.json');
    final Map<String, dynamic> data = json.decode(jsonStr);
    final nameMap = _buildLocalizedMap(context);

    // Extract all en_metroStation* keys and count their facilities
    for (final key in data.keys) {
      if (!key.startsWith('en_metroStation')) continue;
      final jsonName = key.substring('en_metroStation'.length);
      final stationData = data[key];
      if (stationData is! Map<String, dynamic>) continue;

      int count = 0;
      final cats = <String>{};
      stationData.forEach((_, v) {
        if (v is Map<String, dynamic>) {
          count++;
          final cat = v['category'] as String?;
          if (cat != null) cats.add(cat);
        }
      });

      // Skip stations with no facilities
      if (count == 0) continue;

      final displayName = nameMap[jsonName] ?? jsonName;
      _stations.add(_StationEntry(
        jsonName: jsonName,
        displayName: displayName,
        facilityCount: count,
        categories: cats,
      ));
    }

    // Sort by facility count (most first)
    _stations.sort((a, b) => b.facilityCount.compareTo(a.facilityCount));

    setState(() {
      _filtered = List.from(_stations);
      _loading = false;
    });
  }

  void _applyFilter() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(_stations);
      } else {
        _filtered = _stations
            .where((s) =>
                s.displayName.toLowerCase().contains(q) ||
                s.jsonName.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.locale == 'ar';

    return Scaffold(
      backgroundColor: AppTheme.backgroundSand,
      body: CustomScrollView(
        slivers: [
          // ── App bar ──
          SliverAppBar(
            expandedHeight: 150,
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
                const expandedH = 150.0;
                final minH = kToolbarHeight + topPad;
                final maxH = expandedH + topPad;
                final t = ((constraints.maxHeight - minH) / (maxH - minH))
                    .clamp(0.0, 1.0);

                final textLeft = lerpDouble(56.0, 35.0, t)!;
                final titleSize = lerpDouble(15.0, 20.0, t)!;
                final subtitleOpacity = 1.0;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient background
                    const DecoratedBox(
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
                    // Decorative circles
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
                    // Watermark icon
                    Positioned(
                      right: 24,
                      top: topPad + 8,
                      child: Opacity(
                        opacity: 0.12 * t,
                        child: const Icon(Icons.explore_rounded,
                            size: 88, color: Colors.white),
                      ),
                    ),
                    // Title + subtitle
                    Positioned(
                      left: textLeft,
                      right: 20,
                      bottom: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.exploreAreaTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (subtitleOpacity > 0)
                            Opacity(
                              opacity: subtitleOpacity,
                              child: Text(
                                isAr
                                    ? '${_stations.length} محطة متاحة'
                                    : '${_stations.length} stations available',
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
                  ],
                );
              },
            ),
          ),

          // ── Search bar ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: TextStyle(color: Colors.grey.shade900, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.searchStationsHint,
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: AppTheme.primaryNile, size: 20),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close_rounded,
                                color: Colors.grey.shade400, size: 18),
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
          ),

          // ── Disclaimer ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.warning.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 16, color: AppTheme.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isAr
                            ? 'البيانات تقريبية وقد تختلف. يرجى التحقق رسمياً قبل الزيارة.'
                            : 'Data is approximate and may vary. Please verify officially before visiting.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Loading / empty / list ──
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(l10n.noStationsFound,
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14)),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _stationCard(_filtered[i], isAr),
                childCount: _filtered.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ── Station card ───────────────────────────────────────────────────────────

  Widget _stationCard(_StationEntry station, bool isAr) {
    final imagePath = 'assets/stations/line3/${station.jsonName}.jpg';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.to(() => StationFacilitiesPage(
                stationNameEN: station.jsonName,
                stationNameLang: station.displayName,
              )),
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                // Station photo thumbnail
                SizedBox(
                  width: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        cacheWidth: 200,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppTheme.line3, AppTheme.line3Dark],
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.train_rounded,
                                size: 28, color: Colors.white70),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.5, 1.0],
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Place count on image
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Text(
                            '${station.facilityCount}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Station info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          station.displayName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isAr
                              ? '${station.facilityCount} مكان قريب'
                              : '${station.facilityCount} nearby places',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Category icons row
                        SizedBox(
                          height: 22,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: station.categories
                                .where((c) => c.toLowerCase() != 'streets')
                                .take(5)
                                .map((c) {
                              final meta = _categoryMeta[c.toLowerCase()];
                              if (meta == null) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: meta.$2.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(meta.$1, size: 10, color: meta.$2),
                                      const SizedBox(width: 3),
                                      Text(
                                        c,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: meta.$2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Arrow
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.chevron_right_rounded,
                      size: 20, color: Colors.grey.shade300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Re-export category metadata for station_facilities.dart
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
