import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Pages/station_explorer.dart';
import '../../Pages/station_facilities.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// Horizontally-scrolling row of featured station cards.
class ExploreAreaSection extends StatelessWidget {
  const ExploreAreaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = l10n.locale == 'ar';

    final featured = <(String, String, int)>[
      ('SAFAA HEGAZI', l10n.metroStationSAFAA_HEGAZI, 82),
      ('KIT KAT', l10n.metroStationKIT_KAT, 72),
      ('ABASIA', l10n.metroStationABASIA, 70),
      ('ABDO BASHA', l10n.metroStationABDO_BASHA, 56),
      ('GAMAL ABD EL-NASSER', l10n.metroStationGAMAL_ABD_EL_NASSER, 54),
      ('ATABA', l10n.metroStationATABA, 51),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                l10n.exploreAreaTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppTheme.darkPrimary : AppTheme.primaryNile,
                  letterSpacing: -0.1,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => Get.to(() => const StationExplorerPage()),
              icon: const Icon(Icons.explore_rounded, size: 14),
              label: Text(l10n.seeAll),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryNile,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            l10n.exploreAreaSubtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppTheme.darkTextTertiary
                  : Colors.grey.shade500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: featured.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final (jsonName, displayName, count) = featured[i];
              return _ExploreCard(
                jsonName: jsonName,
                displayName: displayName,
                count: count,
                isAr: isAr,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Individual station card ────────────────────────────────────────────────────

class _ExploreCard extends StatelessWidget {
  final String jsonName;
  final String displayName;
  final int count;
  final bool isAr;

  const _ExploreCard({
    required this.jsonName,
    required this.displayName,
    required this.count,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imagePath = 'assets/stations/line3/$jsonName.jpg';

    return GestureDetector(
      onTap: () => Get.to(() => StationFacilitiesPage(
            stationNameEN: jsonName,
            stationNameLang: displayName,
          )),
      child: Container(
        width: 140,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Station photo (falls back to gradient icon)
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              cacheWidth: 280,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A535C), Color(0xFF0C3340)],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.train_rounded,
                      size: 40,
                      color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),

            // Count badge
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.place_rounded,
                        size: 11, color: Colors.white),
                    const SizedBox(width: 3),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Station name + subtitle
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.tapToExplore,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.75),
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
