import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/data/egypt_cities_data.dart';

/// Large swipeable card for an Egyptian destination (outside Cairo).
class TouristGuideEgyptCityCard extends StatelessWidget {
  final EgyptCity city;
  final String locale;
  final bool isDark;
  final String exploreLabel;
  final VoidCallback onExplore;

  const TouristGuideEgyptCityCard({
    super.key,
    required this.city,
    required this.locale,
    required this.isDark,
    required this.exploreLabel,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Material(
        borderRadius: BorderRadius.circular(26),
        clipBehavior: Clip.antiAlias,
        elevation: isDark ? 6 : 4,
        shadowColor: city.gradientColors.first.withOpacity(0.35),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onExplore();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                city.heroImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: city.gradientColors,
                    ),
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.65),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.emoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                    const Spacer(),
                    Text(
                      city.name(locale),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: Colors.black54,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      city.description(locale),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 14,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                        shadows: const [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black45,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        onExplore();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: city.accentColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        exploreLabel,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
