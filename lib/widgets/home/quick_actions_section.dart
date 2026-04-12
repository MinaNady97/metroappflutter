import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Pages/tourist_guide.dart';
import '../../Pages/subscription_info.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../tour/tour_keys.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class _QuickAction {
  final IconData icon;
  final String label;
  final String subtitle;
  final String ctaLabel;
  final Color color;
  final VoidCallback onTap;
  final int badge;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.ctaLabel,
    required this.color,
    required this.onTap,
    this.badge = 0,
  });
}

// ── Section widget ────────────────────────────────────────────────────────────

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final actions = [
      _QuickAction(
        icon: Icons.tour_rounded,
        label: l10n.touristGuideTitle,
        subtitle: l10n.nearbyAttractions,
        ctaLabel: l10n.viewDetails,
        color: AppTheme.line3,
        badge: 48,
        onTap: () => Get.to(() => TouristGuidePage()),
      ),
      _QuickAction(
        icon: Icons.credit_card_rounded,
        label: l10n.subscriptionInfoTitle,
        subtitle: l10n.viewPlansLabel,
        ctaLabel: l10n.learnMore,
        color: AppTheme.line1,
        onTap: () => Get.to(() => SubscriptionInfoPage()),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            l10n.quickActionsTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? AppTheme.darkPrimary : AppTheme.primaryNile,
              letterSpacing: -0.1,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...actions.asMap().entries.map((entry) => Padding(
              key: entry.key == 0 ? TourKeys.touristGuideCard : null,
              padding: const EdgeInsets.only(bottom: 10),
              child: _FeatureBannerCard(action: entry.value),
            )),
      ],
    );
  }
}

// ── Feature banner card ────────────────────────────────────────────────────────

class _FeatureBannerCard extends StatelessWidget {
  final _QuickAction action;
  const _FeatureBannerCard({required this.action});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final a = action;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        a.onTap();
      },
      child: Container(
        height: 100,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              a.color.withValues(alpha: 0.11),
              a.color.withValues(alpha: 0.03),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: a.color.withValues(alpha: 0.18)),
        ),
        child: Stack(
          children: [
            // Watermark icon
            Positioned(
              right: -12,
              top: -12,
              child: Icon(a.icon, size: 115, color: a.color.withValues(alpha: 0.07)),
            ),
            // Left accent strip
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 4, color: a.color),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 100, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title + optional badge
                  Row(
                    children: [
                      Text(
                        a.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: a.color,
                        ),
                      ),
                      if (a.badge > 0) ...[
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: a.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${a.badge}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Subtitle
                  Text(
                    a.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppTheme.darkTextSub
                          : Colors.grey.shade600,
                    ),
                  ),
                  // CTA row
                  Row(
                    children: [
                      Text(
                        a.ctaLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: a.color,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded,
                          size: 13, color: a.color),
                    ],
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
