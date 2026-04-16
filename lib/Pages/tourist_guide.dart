import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:metroappflutter/Controllers/homepagecontroller.dart';
import 'package:metroappflutter/Pages/egypt_city_detail_page.dart';
import 'package:metroappflutter/Pages/routepage.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/data/egypt_cities_data.dart';
import 'package:metroappflutter/data/tourist_places_data.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/widgets/tourist/tourist_guide_cairo_place_card.dart';
import 'package:metroappflutter/widgets/tourist/tourist_guide_egypt_city_card.dart';
import 'package:metroappflutter/widgets/tourist/tourist_guide_line_badges.dart';

String _categoryLabel(PlaceCategory c, AppLocalizations l10n) => switch (c) {
      PlaceCategory.historical => l10n.categoryHistorical,
      PlaceCategory.museum => l10n.categoryMuseum,
      PlaceCategory.religious => l10n.categoryReligious,
      PlaceCategory.park => l10n.categoryPark,
      PlaceCategory.shopping => l10n.categoryShopping,
      PlaceCategory.culture => l10n.categoryCulture,
      PlaceCategory.nile => l10n.categoryNile,
      PlaceCategory.hiddenGem => l10n.categoryHiddenGem,
    };

// ═══════════════════════════════════════════════════════════════════════════════
// Tourist Guide Page
// ═══════════════════════════════════════════════════════════════════════════════

class TouristGuidePage extends StatefulWidget {
  @override
  State<TouristGuidePage> createState() => _TouristGuidePageState();
}

class _TouristGuidePageState extends State<TouristGuidePage>
    with TickerProviderStateMixin {
  PlaceCategory? _activeCategory;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  late final PageController _egyptPageController =
      PageController(viewportFraction: 0.88);
  int _egyptPageIndex = 0;

  List<TouristPlace> get _filteredPlaces {
    var list = touristPlaces.toList();
    if (_activeCategory != null) {
      list = list.where((p) => p.category == _activeCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) {
        return p.names.values.any((n) => n.toLowerCase().contains(q)) ||
            p.stationEn.toLowerCase().contains(q) ||
            p.stationAr.contains(q);
      }).toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _tabController.dispose();
    _egyptPageController.dispose();
    super.dispose();
  }

  String _exploreButtonLabel(AppLocalizations l10n) {
    if (l10n.locale == 'ar') return 'استكشف';
    return 'Explore';
  }

  void _openCityDetail(EgyptCity city) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => EgyptCityDetailPage(city: city),
      ),
    );
  }

  void _showPlaceBottomSheet(
    TouristPlace place,
    AppLocalizations l10n,
    bool isAr,
  ) {
    final locale = l10n.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.94,
          expand: false,
          builder: (_, scrollCtrl) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.asset(
                        place.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppTheme.primaryNile.withOpacity(0.08),
                          child: Icon(Icons.image_not_supported_outlined,
                              size: 48, color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name(locale),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            color: isDark
                                ? AppTheme.darkPrimary
                                : AppTheme.primaryNile,
                          ),
                        ),
                      ),
                      touristGuideLineBadges(place.line),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _categoryLabel(place.category, l10n),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryNile.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    place.desc(locale),
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark
                          ? AppTheme.darkTextSub
                          : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.darkElevated
                          : AppTheme.primaryNile.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.subway_rounded,
                            color: AppTheme.primaryNile, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.station(locale),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppTheme.darkPrimary
                                      : AppTheme.primaryNile,
                                ),
                              ),
                              Text(
                                '${l10n.lineLabel} ${place.line} · ~${place.walkMinutes} ${l10n.minuteShort}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppTheme.darkTextTertiary
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _onRoute(place, locale);
                          },
                          icon: const Icon(Icons.directions_subway_rounded,
                              size: 20),
                          label: Text(l10n.planRoute),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _onMap(place, isAr);
                          },
                          icon: const Icon(Icons.map_rounded, size: 20),
                          label: Text(l10n.googleMapsLabel),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryNile,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(
                                color: AppTheme.primaryNile, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.locale == 'ar';

    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: _buildSliverAppBar(isAr),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildCairoTabContent(l10n, isAr),
            _buildEgyptTabContent(l10n, isAr),
          ],
        ),
      ),
    );
  }

  Widget _buildCairoTabContent(AppLocalizations l10n, bool isAr) {
    final places = _filteredPlaces;
    const pad = 16.0;
    const gap = 12.0;
    const aspect = 0.74;

    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey<String>('tourist_cairo_tab'),
          primary: false,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle:
                  NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
        SliverToBoxAdapter(child: _buildDisclaimer(isAr)),
        SliverToBoxAdapter(child: _buildSearchBar(isAr)),
        SliverToBoxAdapter(child: _buildCategoryChips(isAr)),
        if (places.isEmpty)
          SliverToBoxAdapter(child: _buildEmptyState(isAr))
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(pad, 8, pad, 8),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: gap,
                crossAxisSpacing: gap,
                childAspectRatio: aspect,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final p = places[i];
                  return TouristGuideCairoPlaceCard(
                    place: p,
                    locale: l10n.locale,
                    categoryLabel: _categoryLabel(p.category, l10n),
                    onTap: () => _showPlaceBottomSheet(p, l10n, isAr),
                  );
                },
                childCount: places.length,
              ),
            ),
          ),
        SliverToBoxAdapter(child: _buildTipsSection(isAr)),
        SliverToBoxAdapter(child: _buildPhrasesSection(isAr)),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      },
    );
  }

  Widget _buildEgyptTabContent(AppLocalizations l10n, bool isAr) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final explore = _exploreButtonLabel(l10n);
    final h = (MediaQuery.sizeOf(context).height * 0.48).clamp(320.0, 440.0);

    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey<String>('tourist_egypt_tab'),
          primary: false,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle:
                  NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(child: _buildDisclaimer(isAr)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.discoverEgyptTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: isDark
                            ? AppTheme.darkPrimary
                            : AppTheme.primaryNile,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.discoverEgyptSubtitle,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.35,
                        color: isDark
                            ? AppTheme.darkTextSub
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: h,
                child: PageView.builder(
                  controller: _egyptPageController,
                  itemCount: egyptCities.length,
                  padEnds: true,
                  onPageChanged: (i) => setState(() => _egyptPageIndex = i),
                  itemBuilder: (_, i) {
                    final city = egyptCities[i];
                    return TouristGuideEgyptCityCard(
                      city: city,
                      locale: l10n.locale,
                      isDark: isDark,
                      exploreLabel: explore,
                      onExplore: () => _openCityDetail(city),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    egyptCities.length,
                    (i) {
                      final active = i == _egyptPageIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: active
                              ? AppTheme.primaryNile
                              : (isDark
                                  ? AppTheme.darkBorder
                                  : Colors.grey.shade300),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Sliver App Bar ────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(bool isAr) {
    const expandedH = 150.0;

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

          final textLeft = lerpDouble(56.0, 36.0, t)!;
          final titleSize = lerpDouble(15.0, 20.0, t)!;
          final subtitleOpacity = 1.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Gradient background
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? const [
                            Color(0xFF060D1A),
                            Color(0xFF0D1F2F),
                            Color(0xFF0A2030),
                          ]
                        : const [
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
                  child: const Icon(Icons.tour_rounded,
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
                      AppLocalizations.of(context)!.touristGuideTitle,
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
                          '${touristPlaces.length} ${AppLocalizations.of(context)!.touristGuidePlacesCount}',
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: ColoredBox(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF0A1520)
              : const Color(0xFF0D3B52),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 2.5,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.62),
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: isAr ? 'القاهرة' : 'Cairo'),
              Tab(text: isAr ? 'مصر' : 'Egypt'),
            ],
          ),
        ),
      ),
    );
  }

  // ── Disclaimer ────────────────────────────────────────────────────────────

  Widget _buildDisclaimer(bool isAr) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warning.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.touristGuideDisclaimer,
              style: TextStyle(
                fontSize: 11.5,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFD4956A)
                    : Colors.brown.shade700,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar(bool isAr) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _searchCtrl,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.touristGuideSearchHint,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(Icons.search_rounded,
              size: 20, color: AppTheme.primaryNile.withOpacity(0.5)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 18, color: Colors.grey.shade400),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkCard
              : AppTheme.lightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkBorder
                  : AppTheme.lightBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkBorder
                  : AppTheme.lightBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppTheme.primaryNile, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (v) => setState(() => _searchQuery = v.trim()),
      ),
    );
  }

  // ── Category chips ────────────────────────────────────────────────────────

  Widget _buildCategoryChips(bool isAr) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        children: [
          _chip(
            label: AppLocalizations.of(context)!.touristGuideCategoryAll,
            icon: Icons.apps_rounded,
            isActive: _activeCategory == null,
            onTap: () => setState(() => _activeCategory = null),
          ),
          ...PlaceCategory.values.map((c) => _chip(
                label: _categoryLabel(c, AppLocalizations.of(context)!),
                icon: _categoryIcon(c),
                isActive: _activeCategory == c,
                onTap: () => setState(
                    () => _activeCategory = _activeCategory == c ? null : c),
              )),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primaryNile
                : (Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkElevated
                    : AppTheme.lightCard),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isActive
                  ? AppTheme.primaryNile
                  : (Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.darkBorder
                      : Colors.grey.shade300),
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.primaryNile.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 14,
                  color: isActive
                      ? Colors.white
                      : (Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkTextSub
                          : Colors.grey.shade600)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
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
      ),
    );
  }

  IconData _categoryIcon(PlaceCategory c) => switch (c) {
        PlaceCategory.historical => Icons.account_balance_rounded,
        PlaceCategory.museum => Icons.museum_rounded,
        PlaceCategory.religious => Icons.mosque_rounded,
        PlaceCategory.park => Icons.park_rounded,
        PlaceCategory.shopping => Icons.shopping_bag_rounded,
        PlaceCategory.culture => Icons.theater_comedy_rounded,
        PlaceCategory.nile => Icons.sailing_rounded,
        PlaceCategory.hiddenGem => Icons.diamond_rounded,
      };


  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(bool isAr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded,
              size: 48,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkBorder
                  : Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.touristGuideNoPlaces,
            style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkTextSub
                    : Colors.grey.shade500,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.touristGuideNoPlacesSub,
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkTextTertiary
                    : Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // ── Route planner ──────────────────────────────────────────────────────────

  Future<void> _onRoute(TouristPlace place, String locale) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 220,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkCard
                    : AppTheme.lightCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryNile,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    AppLocalizations.of(context)!.detectingLocation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkPrimary
                          : AppTheme.primaryNile,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    try {
      final ctrl = Get.find<HomepageController>();
      final position = await ctrl.getUserLocation();
      final nearest = await ctrl.findNearestStation(position, context);
      final depStation = nearest['Station'] as String? ?? '';

      if (!mounted) return;
      Navigator.pop(context); // dismiss loading

      if (depStation.isEmpty) {
        _showError(AppLocalizations.of(context)!.couldNotFindNearestStation);
        return;
      }

      final arrStation = place.station(locale);

      Get.to(
        () => Routepage(),
        arguments: <String, String>{
          'DepartureStation': depStation,
          'ArrivalStation': arrStation,
          'SortType': '0',
        },
      );
    } catch (e) {
      if (mounted) Navigator.pop(context); // dismiss loading
      _showError(AppLocalizations.of(context)!.couldNotGetLocation);
    }
  }

  // ── Open Google Maps (walking from station to place) ──────────────────────

  Future<void> _onMap(TouristPlace place, bool isAr) async {
    final stationQuery =
        Uri.encodeComponent('${place.stationEn} metro station, Cairo, Egypt');
    final placeQuery = Uri.encodeComponent('${place.name('en')}, Cairo, Egypt');
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=$stationQuery'
      '&destination=$placeQuery'
      '&travelmode=${place.needsTransport ? 'driving' : 'walking'}',
    );

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      _showError(AppLocalizations.of(context)!.couldNotOpenMaps);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Travel Tips ───────────────────────────────────────────────────────────

  Widget _buildTipsSection(bool isAr) {
    final l10n = AppLocalizations.of(context)!;
    final tips = [
      (Icons.access_time_rounded, l10n.peakHoursTitle, l10n.peakHoursDescription),
      (Icons.shield_rounded, l10n.safetyTitle, l10n.safetyDescription),
      (Icons.confirmation_num_rounded, l10n.ticketsTitle, l10n.ticketsDescription),
      (Icons.photo_camera_rounded, l10n.photographyTitle, l10n.photographyDescription),
      (Icons.wb_sunny_rounded, l10n.bestTimeTitle, l10n.bestTimeDescription),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.tips_and_updates_rounded,
                    color: AppTheme.info, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.tipsTitle,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.darkPrimary : AppTheme.primaryNile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map((t) => _buildTipRow(t.$1, t.$2, t.$3)),
        ],
      ),
    );
  }

  Widget _buildTipRow(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryNile.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppTheme.primaryNile),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkPrimary
                        : AppTheme.primaryNile,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkTextSub
                        : Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Essential Phrases ─────────────────────────────────────────────────────

  Widget _buildPhrasesSection(bool isAr) {
    final l10n = AppLocalizations.of(context)!;
    final phrases = [
      (l10n.phrase1, l10n.phrase1Translation),
      (l10n.phrase2, l10n.phrase2Translation),
      (l10n.phrase3, l10n.phrase3Translation),
      (l10n.phrase4, l10n.phrase4Translation),
      (l10n.phrase5, l10n.phrase5Translation),
      (l10n.phrase6, l10n.phrase6Translation),
      (l10n.phrase7, l10n.phrase7Translation),
      (l10n.phrase8, l10n.phrase8Translation),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.translate_rounded,
                    color: AppTheme.accentGold, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.essentialPhrases,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.darkPrimary : AppTheme.primaryNile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...phrases.map((p) => _buildPhraseRow(p.$1, p.$2)),
        ],
      ),
    );
  }

  Widget _buildPhraseRow(String question, String translation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkElevated
              : AppTheme.lightPhraseRow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkPrimary
                          : AppTheme.primaryNile,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    translation,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkTextSub
                          : Colors.grey.shade600,
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
