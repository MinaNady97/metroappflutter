import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

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

class _StationFacilitiesPageState extends State<StationFacilitiesPage> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? stationData;
  final Map<String, FacilityCategory> _categories = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadStationData();
    }
  }

  Future<void> _loadStationData() async {
    final jsonStr = await rootBundle.loadString('assets/data/full_cairo_metro_template2.json');
    final Map<String, dynamic> data = json.decode(jsonStr);
    final locale = AppLocalizations.of(context)!.locale;
    final key = '${locale}_metroStation${widget.stationNameEN}';
    setState(() {
      stationData = data[key] as Map<String, dynamic>?;
      _organizeByCategory();
    });
  }

  void _organizeByCategory() {
    _categories.clear();
    if (stationData == null) return;
    stationData!.forEach((key, value) {
      if (value is! Map<String, dynamic>) return;
      final category = (value['category'] as String?) ?? 'Other';
      _categories.putIfAbsent(
        category,
        () => FacilityCategory(name: category, icon: _iconForCategory(category), items: []),
      );
      _categories[category]!.items.add(FacilityItem(name: key, data: value));
    });
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'religious':
        return Icons.mosque;
      case 'medical':
        return Icons.local_hospital;
      case 'cultural':
        return Icons.museum;
      case 'commercial':
        return Icons.shopping_bag;
      case 'public spaces':
        return Icons.park;
      case 'sport facilities':
        return Icons.sports_soccer;
      case 'educational':
        return Icons.school;
      case 'services':
        return Icons.support_agent;
      case 'landmarks':
        return Icons.account_balance;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.backgroundSand,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppTheme.primaryNile,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${widget.stationNameLang} ${l10n.facilitiesTitle}'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(_stationImagePath(widget.stationNameEN), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.black12)),
                  Container(color: Colors.black.withOpacity(0.35)),
                ],
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: const Icon(Icons.grid_view), text: l10n.facilitiesTitle),
                Tab(icon: const Icon(Icons.map), text: l10n.stationMapTitle),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFacilitiesGrid(),
            _buildStationMap(),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesGrid() {
    if (stationData == null) return const Center(child: CircularProgressIndicator());
    if (_categories.isEmpty) return const Center(child: Text('No facilities found'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _categories.values.map((cat) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(cat.icon, color: AppTheme.primaryNile),
                const SizedBox(width: 8),
                Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: cat.items.length,
              itemBuilder: (_, i) => _facilityCard(cat.items[i]),
            ),
            const SizedBox(height: 14),
          ],
        );
      }).toList(),
    );
  }

  Widget _facilityCard(FacilityItem item) {
    return InkWell(
      onTap: () => _showFacilityDetails(item),
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.place, color: AppTheme.primaryNile),
              const SizedBox(height: 8),
              Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStationMap() {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Image.asset(
          _stationImagePath(widget.stationNameEN),
          errorBuilder: (_, __, ___) => const Padding(
            padding: EdgeInsets.all(20),
            child: Text('No station image available'),
          ),
        ),
      ),
    );
  }

  void _showFacilityDetails(FacilityItem item) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(item.data['description']?.toString() ?? '-'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _stationImagePath(String stationNameEN) => 'assets/stations/line3/$stationNameEN.jpg';
}

class FacilityCategory {
  final String name;
  final IconData icon;
  final List<FacilityItem> items;

  FacilityCategory({required this.name, required this.icon, required this.items});
}

class FacilityItem {
  final String name;
  final Map<String, dynamic> data;

  FacilityItem({required this.name, required this.data});
}
