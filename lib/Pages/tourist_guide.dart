import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:metroappflutter/Controllers/homepagecontroller.dart';
import 'package:metroappflutter/Pages/routepage.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/data/tourist_places_data.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// Tourist Guide Page
// ═══════════════════════════════════════════════════════════════════════════════

class TouristGuidePage extends StatefulWidget {
  @override
  State<TouristGuidePage> createState() => _TouristGuidePageState();
}

class _TouristGuidePageState extends State<TouristGuidePage> {
  PlaceCategory? _activeCategory;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  List<TouristPlace> get _filteredPlaces {
    var list = touristPlaces.toList();
    if (_activeCategory != null) {
      list = list.where((p) => p.category == _activeCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) {
        return p.nameEn.toLowerCase().contains(q) ||
            p.nameAr.contains(q) ||
            p.stationEn.toLowerCase().contains(q) ||
            p.stationAr.contains(q);
      }).toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.locale == 'ar';
    final places = _filteredPlaces;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSand,
      body: CustomScrollView(
        controller: _scrollCtrl,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(isAr),
          SliverToBoxAdapter(child: _buildDisclaimer(isAr)),
          SliverToBoxAdapter(child: _buildSearchBar(isAr)),
          SliverToBoxAdapter(child: _buildCategoryChips(isAr)),
          if (places.isEmpty)
            SliverToBoxAdapter(child: _buildEmptyState(isAr))
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _PlaceCard(
                    place: places[i],
                    isAr: isAr,
                    onRoute: () => _onRoute(places[i], isAr),
                    onMap: () => _onMap(places[i], isAr),
                  ),
                  childCount: places.length,
                ),
              ),
            ),
          SliverToBoxAdapter(child: _buildTipsSection(isAr)),
          SliverToBoxAdapter(child: _buildPhrasesSection(isAr)),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
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
                      isAr ? 'دليل السياحة' : 'Tourist Guide',
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
                          isAr
                              ? '${touristPlaces.length} مكان للاستكشاف'
                              : '${touristPlaces.length} places to explore',
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
              isAr
                  ? 'المعلومات والأوقات والمسافات تقريبية وقد تختلف. يُرجى التحقق رسمياً قبل الزيارة.'
                  : 'Times, distances, and details are approximate and may vary. Please verify officially before visiting.',
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.brown.shade700,
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
          hintText:
              isAr ? 'ابحث عن مكان أو محطة...' : 'Search places or stations...',
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
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDDE6E8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDDE6E8)),
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
            label: isAr ? 'الكل' : 'All',
            icon: Icons.apps_rounded,
            isActive: _activeCategory == null,
            onTap: () => setState(() => _activeCategory = null),
          ),
          ...PlaceCategory.values.map((c) => _chip(
                label: c.label(isAr),
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
            color: isActive ? AppTheme.primaryNile : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isActive ? AppTheme.primaryNile : Colors.grey.shade300,
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
                  color: isActive ? Colors.white : Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Colors.white : Colors.grey.shade700,
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
          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            isAr ? 'لا توجد نتائج' : 'No places found',
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            isAr
                ? 'جرب بحثاً مختلفاً أو فئة أخرى'
                : 'Try a different search or category',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // ── Route planner ──────────────────────────────────────────────────────────

  Future<void> _onRoute(TouristPlace place, bool isAr) async {
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
                color: Colors.white,
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
                    isAr ? 'جاري تحديد موقعك...' : 'Detecting your location...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A535C),
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
        _showError(isAr
            ? 'لم نتمكن من تحديد أقرب محطة'
            : 'Could not find nearest station');
        return;
      }

      final arrStation = place.station(isAr);

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
      _showError(isAr
          ? 'لم نتمكن من تحديد موقعك. تحقق من إذن الموقع.'
          : 'Could not get your location. Check location permission.');
    }
  }

  // ── Open Google Maps (walking from station to place) ──────────────────────

  Future<void> _onMap(TouristPlace place, bool isAr) async {
    final stationQuery =
        Uri.encodeComponent('${place.stationEn} metro station, Cairo, Egypt');
    final placeQuery = Uri.encodeComponent('${place.nameEn}, Cairo, Egypt');
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=$stationQuery'
      '&destination=$placeQuery'
      '&travelmode=${place.needsTransport ? 'driving' : 'walking'}',
    );

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      _showError(
          isAr ? 'لم نتمكن من فتح خرائط جوجل' : 'Could not open Google Maps');
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
    final tips = [
      _TipData(
        icon: Icons.access_time_rounded,
        titleEn: 'Peak Hours',
        titleAr: 'ساعات الذروة',
        descEn:
            'Avoid 7–9 AM and 3–6 PM for less crowded trains. Weekends are generally quieter.',
        descAr:
            'تجنب 7–9 صباحاً و3–6 مساءً لقطارات أقل ازدحاماً. عطلات نهاية الأسبوع أهدأ عموماً.',
      ),
      _TipData(
        icon: Icons.shield_rounded,
        titleEn: 'Safety',
        titleAr: 'السلامة',
        descEn:
            'Keep valuables secure. Use the women-only car (first car) if applicable. Be aware of your surroundings.',
        descAr:
            'حافظ على الأشياء الثمينة. استخدم عربة السيدات (العربة الأولى) إن أمكن. كن واعياً لما حولك.',
      ),
      _TipData(
        icon: Icons.confirmation_num_rounded,
        titleEn: 'Tickets',
        titleAr: 'التذاكر',
        descEn:
            'Always keep your ticket until you exit. Consider a wallet card for frequent travel — saves time and money.',
        descAr:
            'احتفظ بتذكرتك حتى الخروج. فكر في بطاقة المحفظة للتنقل المتكرر — توفر الوقت والمال.',
      ),
      _TipData(
        icon: Icons.photo_camera_rounded,
        titleEn: 'Photography',
        titleAr: 'التصوير',
        descEn:
            'Photography is not allowed inside metro stations. Some attractions may charge a camera fee.',
        descAr:
            'التصوير غير مسموح داخل محطات المترو. بعض المعالم قد تفرض رسوم كاميرا.',
      ),
      _TipData(
        icon: Icons.wb_sunny_rounded,
        titleEn: 'Best Time to Visit',
        titleAr: 'أفضل وقت للزيارة',
        descEn:
            'October to April offers the best weather. Visit outdoor sites early morning or late afternoon.',
        descAr:
            'أكتوبر إلى أبريل يوفر أفضل طقس. زُر المواقع المفتوحة صباحاً باكراً أو عصراً.',
      ),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                isAr ? 'نصائح السفر' : 'Travel Tips',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A535C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map((t) => _buildTipRow(t, isAr)),
        ],
      ),
    );
  }

  Widget _buildTipRow(_TipData tip, bool isAr) {
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
            child: Icon(tip.icon, size: 16, color: AppTheme.primaryNile),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? tip.titleAr : tip.titleEn,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A535C),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isAr ? tip.descAr : tip.descEn,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
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
    final phrases = [
      _PhraseData(
          'How much is the ticket?', 'بكام التذكرة؟', 'Bikam el-tazkara?'),
      _PhraseData('Where is the metro station?', 'فين محطة المترو؟',
          'Fein mahattat el-metro?'),
      _PhraseData('Does this go to...?', 'ده بيروح...؟', 'Da biyroh...?'),
      _PhraseData('Thank you', 'شكراً', 'Shukran'),
      _PhraseData('How much?', 'بكام؟', 'Bikam?'),
      _PhraseData('Where is...?', 'فين...؟', 'Fein...?'),
      _PhraseData(
          'I want to go to...', 'أنا عايز أروح...', 'Ana aayez aroh...'),
      _PhraseData('Is it far?', 'هو بعيد؟', 'Howwa baeed?'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                isAr ? 'عبارات مفيدة' : 'Essential Arabic Phrases',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A535C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...phrases.map((p) => _buildPhraseRow(p, isAr)),
        ],
      ),
    );
  }

  Widget _buildPhraseRow(_PhraseData p, bool isAr) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F7F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.english,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A535C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${p.arabic}  (${p.pronunciation})',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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

// ═══════════════════════════════════════════════════════════════════════════════
// Place Card Widget
// ═══════════════════════════════════════════════════════════════════════════════

class _PlaceCard extends StatelessWidget {
  final TouristPlace place;
  final bool isAr;
  final VoidCallback onRoute;
  final VoidCallback onMap;

  const _PlaceCard({
    required this.place,
    required this.isAr,
    required this.onRoute,
    required this.onMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image with category badge ──
          Stack(
            children: [
              // Image — BoxFit.cover handles any aspect ratio
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.asset(
                  place.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.primaryNile.withOpacity(0.08),
                    child: Icon(Icons.image_not_supported_outlined,
                        size: 40, color: Colors.grey.shade300),
                  ),
                ),
              ),
              // Gradient overlay at bottom of image
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.45),
                      ],
                    ),
                  ),
                ),
              ),
              // Category badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_catIcon(place.category),
                          size: 12, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        place.category.label(isAr),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Walk time badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        place.needsTransport
                            ? Icons.directions_bus_rounded
                            : Icons.directions_walk_rounded,
                        size: 12,
                        color: AppTheme.primaryNile,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '~${place.walkMinutes} ${isAr ? "د" : "min"}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryNile,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Place name over image
              Positioned(
                bottom: 10,
                left: 14,
                right: 14,
                child: Text(
                  place.name(isAr),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                          blurRadius: 6,
                          color: Colors.black54,
                          offset: Offset(0, 1)),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // ── Content ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  place.desc(isAr),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.45,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),

                // Station chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryNile.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _lineBadge(place.line),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.station(isAr),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A535C),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              isAr ? 'خط ${place.line}' : 'Line ${place.line}',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Action buttons row
                Row(
                  children: [
                    // Route planner button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onRoute();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryNile,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.directions_subway_rounded,
                                  size: 16, color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                isAr ? 'خطط الرحلة' : 'Plan Route',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Google Maps button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onMap();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppTheme.primaryNile, width: 1.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map_rounded,
                                  size: 16, color: AppTheme.primaryNile),
                              const SizedBox(width: 6),
                              Text(
                                isAr ? 'خرائط جوجل' : 'Google Maps',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryNile,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _catIcon(PlaceCategory c) => switch (c) {
        PlaceCategory.historical => Icons.account_balance_rounded,
        PlaceCategory.museum => Icons.museum_rounded,
        PlaceCategory.religious => Icons.mosque_rounded,
        PlaceCategory.park => Icons.park_rounded,
        PlaceCategory.shopping => Icons.shopping_bag_rounded,
        PlaceCategory.culture => Icons.theater_comedy_rounded,
        PlaceCategory.nile => Icons.sailing_rounded,
        PlaceCategory.hiddenGem => Icons.diamond_rounded,
      };

  Widget _lineBadge(String line) {
    // Handle multi-line like "1/2", "2/3"
    final parts = line.split('/');
    if (parts.length == 1) {
      return _singleLineBadge(parts[0]);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: parts
          .map((p) => Padding(
                padding: const EdgeInsets.only(right: 3),
                child: _singleLineBadge(p),
              ))
          .toList(),
    );
  }

  Widget _singleLineBadge(String l) {
    final color = switch (l.trim()) {
      '1' => AppTheme.line1,
      '2' => AppTheme.line2,
      '3' => AppTheme.line3,
      _ => AppTheme.primaryNile,
    };
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          l.trim(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

// ── Helper data classes ─────────────────────────────────────────────────────

class _TipData {
  final IconData icon;
  final String titleEn, titleAr, descEn, descAr;
  const _TipData({
    required this.icon,
    required this.titleEn,
    required this.titleAr,
    required this.descEn,
    required this.descAr,
  });
}

class _PhraseData {
  final String english, arabic, pronunciation;
  const _PhraseData(this.english, this.arabic, this.pronunciation);
}
