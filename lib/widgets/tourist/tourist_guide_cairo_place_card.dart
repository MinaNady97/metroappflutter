import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/data/tourist_places_data.dart';
import 'package:metroappflutter/widgets/tourist/tourist_guide_line_badges.dart';

/// Compact grid card for a Cairo metro–linked tourist place.
class TouristGuideCairoPlaceCard extends StatelessWidget {
  final TouristPlace place;
  final String locale;
  final String categoryLabel;
  final VoidCallback onTap;

  const TouristGuideCairoPlaceCard({
    super.key,
    required this.place,
    required this.locale,
    required this.categoryLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      elevation: isDark ? 2 : 1,
      shadowColor: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    place.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.primaryNile.withOpacity(0.08),
                      alignment: Alignment.center,
                      child: Icon(Icons.image_not_supported_outlined,
                          size: 32, color: Colors.grey.shade400),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.52),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _categoryIcon(place.category),
                            size: 11,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 72),
                            child: Text(
                              categoryLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (place.line.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          child: touristGuideLineBadges(place.line),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Text(
                place.name(locale),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: isDark ? AppTheme.darkPrimary : AppTheme.primaryNile,
                ),
              ),
            ),
          ],
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
}
