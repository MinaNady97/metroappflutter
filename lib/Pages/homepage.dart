import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:metroappflutter/Controllers/homepagecontroller.dart';
import 'package:metroappflutter/Controllers/languagecontroller.dart';
import 'package:metroappflutter/Pages/routepage.dart';
import 'package:metroappflutter/Pages/subscription_info.dart';
import 'package:metroappflutter/Pages/tourist_guide.dart';
import 'package:metroappflutter/Pages/location_picker_page.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/widgets/animated_search_bar.dart';
import 'package:metroappflutter/widgets/line_preview_card.dart';
import 'package:metroappflutter/widgets/metro_map_preview.dart';
import 'package:metroappflutter/widgets/quick_action_card.dart';

import '../Constants/metro_stations.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final HomepageController controller = Get.find<HomepageController>();
  final LanguageController langController = Get.find<LanguageController>();
  final TextEditingController destinationInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    controller.allMetroStations = getAllMetroStations(context);
    controller.getMetroStationsLists(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundSand,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, l10n),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildHeroIntro(context, l10n),
                  const SizedBox(height: 20),
                  _buildRoutePlanner(context, l10n),
                  const SizedBox(height: 14),
                  _buildArrivalFinder(context, l10n),
                  const SizedBox(height: 20),
                  _buildQuickActions(context, l10n),
                  const SizedBox(height: 20),
                  _buildMetroLinesOverview(context, l10n),
                  const SizedBox(height: 20),
                  MetroMapPreview(onTap: () => _showFullMap(context)),
                  const SizedBox(height: 20),
                  _buildSubscriptionPromo(context, l10n),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentGold,
        onPressed: () => _findNearestStation(context),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: const Color(0xFF2A7B8A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_subway, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.appTitle,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/metroBG1.jpg', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF3B99A8).withOpacity(0.55),
                    AppTheme.primaryNile.withOpacity(0.82),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showAppInfo(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.16),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () => _showLanguageSwitcher(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.16),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildHeroIntro(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryNile.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF184D56),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.welcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blueGrey.shade600,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Metro + LRT',
                    style: TextStyle(
                      color: Colors.amber.shade800,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.train_rounded, color: Color(0xFF2A7B8A), size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutePlanner(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryNile.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.route, color: AppTheme.primaryNile),
              ),
              const SizedBox(width: 10),
              Text(l10n.planYourRoute, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => AnimatedSearchBar(
              hint: l10n.departureStationHint,
              icon: Icons.trip_origin,
              suggestions: controller.allMetroStations,
              selectedText: controller.depStation.value,
              onSelected: (v) => controller.depStation.value = v,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => AnimatedSearchBar(
              hint: l10n.arrivalStationHint,
              icon: Icons.location_on,
              suggestions: controller.allMetroStations,
              selectedText: controller.arrStation.value,
              onSelected: (v) => controller.arrStation.value = v,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final valid = controller.depStation.value.isNotEmpty &&
                controller.arrStation.value.isNotEmpty &&
                controller.depStation.value != controller.arrStation.value;
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: valid
                    ? () {
                        HapticFeedback.selectionClick();
                        Get.to(
                          () => Routepage(),
                          arguments: {
                            'DepartureStation': controller.depStation.value,
                            'ArrivalStation': controller.arrStation.value,
                            'SortType': '0',
                          },
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: valid ? AppTheme.primaryNile : Colors.grey.shade300,
                  foregroundColor: valid ? Colors.white : Colors.grey.shade700,
                ),
                icon: Icon(valid ? Icons.directions : Icons.block),
                label: Text(l10n.showRoutesButtonText),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.metroLinesTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                icon: Icons.my_location,
                label: l10n.nearestStationLabel,
                color: AppTheme.accentGold,
                onTap: () => _findNearestStation(context),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickActionCard(
                icon: Icons.explore,
                label: l10n.touristGuideTitle,
                color: AppTheme.line3,
                onTap: () => Get.to(() => TouristGuidePage()),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickActionCard(
                icon: Icons.credit_card,
                label: l10n.subscriptionInfoTitle,
                color: AppTheme.line2,
                onTap: () => Get.to(() => SubscriptionInfoPage()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArrivalFinder(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.search, color: AppTheme.primaryNile, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.findNearestStation,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: destinationInputController,
            decoration: InputDecoration(
              hintText: '${l10n.destinationFieldLabel} (or Google Maps link)',
              prefixIcon: const Icon(Icons.place_outlined),
            ),
            onSubmitted: (_) => _findArrivalByAddress(context),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _findArrivalByAddress(context),
              icon: const Icon(Icons.my_location),
              label: Text(l10n.findButtonText),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _pickLocationFromMap(context),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Pick from map'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetroLinesOverview(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.metroLinesTitle, style: Theme.of(context).textTheme.titleMedium),
            TextButton(onPressed: () => _showAllLines(context), child: Text(l10n.seeAll)),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 115,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              LinePreviewCard(lineNumber: '1', lineName: l10n.line1Name, color: AppTheme.line1, stations: 35, onTap: () {}),
              const SizedBox(width: 10),
              LinePreviewCard(lineNumber: '2', lineName: l10n.line2Name, color: AppTheme.line2, stations: 20, onTap: () {}),
              const SizedBox(width: 10),
              LinePreviewCard(lineNumber: '3', lineName: l10n.line3Name, color: AppTheme.line3, stations: 29, onTap: () {}),
              const SizedBox(width: 10),
              LinePreviewCard(lineNumber: 'LRT', lineName: 'LRT', color: AppTheme.lrt, stations: 15, onTap: _noop),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionPromo(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryNile, AppTheme.primaryNile.withBlue(40)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.subscriptionInfoTitle, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(l10n.subscriptionInfoSubtitle, style: TextStyle(color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Get.to(() => SubscriptionInfoPage()),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white)),
                  child: Text(l10n.learnMore),
                ),
              ],
            ),
          ),
          const Icon(Icons.credit_card, color: Colors.white, size: 32),
        ],
      ),
    );
  }

  Future<void> _findNearestStation(BuildContext context) async {
    HapticFeedback.lightImpact();
    await controller.updateUserLocation(context);
    final station = controller.depStation.value;
    if (station.isEmpty) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)!.nearestStationFound}: $station'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _findArrivalByAddress(BuildContext context) async {
    HapticFeedback.selectionClick();
    final success = await controller.updateArrivalFromInput(context, destinationInputController.text);
    if (!success) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.addressNotFound),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)!.stationFound}: ${controller.arrStation.value}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickLocationFromMap(BuildContext context) async {
    final picked = await Get.to<Position?>(
      () => const LocationPickerPage(),
    );
    if (picked == null) return;

    final success = await controller.updateArrivalFromPosition(context, picked);
    if (!success) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.addressNotFound),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)!.stationFound}: ${controller.arrStation.value}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.appInfoTitle),
        content: Text(AppLocalizations.of(context)!.appInfoDescription),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.close))],
      ),
    );
  }

  void _showLanguageSwitcher(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(child: Text('EN')),
              title: const Text('English'),
              onTap: () {
                langController.switchLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const CircleAvatar(child: Text('AR')),
              title: const Text('العربية'),
              onTap: () {
                langController.switchLanguage('ar');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAllLines(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(child: Text(AppLocalizations.of(context)!.allMetroLines)),
      ),
    );
  }

  void _showFullMap(BuildContext context) {
    Get.to(
      () => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.metroMapLabel)),
        body: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(child: Image.asset('assets/images/CairoMetroMap.jpg')),
        ),
      ),
    );
  }
}

void _noop() {}
