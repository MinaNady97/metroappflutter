import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Controllers/homepagecontroller.dart' show HomepageController, RecentRoute;
import '../../Constants/metro_stations.dart';
import '../../Pages/routepage.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../tour/tour_keys.dart';
import '../animated_search_bar.dart';

// ── Spacing tokens (mirrored from homepage.dart) ──────────────────────────────
abstract class _Sp {
  static const double xxs = 4.0;
}

abstract class _TS {
  static const Color _secondary = Color(0xFF78909C);
  // Not a const — color must adapt to dark/light mode.
  static TextStyle cardTitle(bool isDark) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppTheme.adaptive(isDark),
    letterSpacing: -0.1,
  );
  static const bodySecondary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: _secondary,
    height: 1.4,
  );
}

// ── Route Planner Card ────────────────────────────────────────────────────────

/// Self-contained route planner card.
/// Reads [HomepageController] via GetX and navigates to [Routepage].
class RoutePlannerCard extends StatelessWidget {
  const RoutePlannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomepageController>();
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Container(
      key: TourKeys.routePlannerCard,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.adaptive(isDark).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.route,
                    color: AppTheme.adaptive(isDark), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.planYourRoute, style: _TS.cardTitle(isDark)),
                    const SizedBox(height: _Sp.xxs),
                    Text(l10n.planYourRouteSubtitle, style: _TS.bodySecondary),
                  ],
                ),
              ),
              _DepartChip(l10n: l10n),
            ],
          ),
          const SizedBox(height: 18),

          // ── Search fields + connector + swap ─────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Vertical connector
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dot(AppTheme.adaptive(isDark)),
                  Container(
                    width: 2,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.adaptive(isDark).withValues(alpha: 0.7),
                          AppTheme.accentGold.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  _dot(AppTheme.accentGold),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Obx(() => AnimatedSearchBar(
                          maxDropdownHeight: 280,
                          hint: l10n.departureStationHint,
                          icon: Icons.trip_origin,
                          suggestions: ctrl.allMetroStations,
                          selectedText: ctrl.depStation.value,
                          onSelected: (v) {
                            ctrl.depStation.value = v;
                            ctrl.depStationIndex =
                                ctrl.allMetroStations.indexOf(v);
                          },
                          stationLines: getStationLineMap(context),
                        )),
                    const SizedBox(height: 8),
                    Obx(() => AnimatedSearchBar(
                          maxDropdownHeight: 280,
                          hint: l10n.arrivalStationHint,
                          icon: Icons.location_on,
                          suggestions: ctrl.allMetroStations,
                          selectedText: ctrl.arrStation.value,
                          onSelected: (v) {
                            ctrl.arrStation.value = v;
                            ctrl.arrStationIndex =
                                ctrl.allMetroStations.indexOf(v);
                          },
                          stationLines: getStationLineMap(context),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Swap button
              Obx(() {
                final both = ctrl.depStation.value.isNotEmpty &&
                    ctrl.arrStation.value.isNotEmpty;
                return Opacity(
                  opacity: both ? 1.0 : 0.28,
                  child: GestureDetector(
                    onTap: both
                        ? () {
                            HapticFeedback.selectionClick();
                            final tmp = ctrl.depStation.value;
                            ctrl.depStation.value = ctrl.arrStation.value;
                            ctrl.arrStation.value = tmp;
                            final tmpIdx = ctrl.depStationIndex;
                            ctrl.depStationIndex = ctrl.arrStationIndex;
                            ctrl.arrStationIndex = tmpIdx;
                          }
                        : null,
                    child: Container(
                      key: TourKeys.swapButton,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.adaptive(isDark).withValues(
                            alpha: isDark ? 0.14 : 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppTheme.adaptive(isDark).withValues(
                                alpha: isDark ? 0.30 : 0.18)),
                      ),
                      child: Icon(
                        Icons.swap_vert_rounded,
                        color: AppTheme.adaptive(isDark),
                        size: 20,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          // ── Favorite routes ──────────────────────────────────────────────
          Obx(() {
            final favs = ctrl.favoriteRoutes;
            if (favs.isEmpty) return const SizedBox.shrink();
            return _RouteChipRow(
              icon: Icons.star_rounded,
              iconColor: AppTheme.accentGold,
              label: l10n.favoritesLabel,
              routes: favs,
              isDark: isDark,
              chipColor: AppTheme.accentGold,
              onTap: (s) {
                ctrl.depStation.value = s.dep;
                ctrl.arrStation.value = s.arr;
              },
              onRemove: (s) => ctrl.toggleFavorite(s.dep, s.arr),
            );
          }),

          // ── Recent searches ──────────────────────────────────────────────
          Obx(() {
            final recent = ctrl.recentRoutes;
            if (recent.isEmpty) return const SizedBox.shrink();
            return _RouteChipRow(
              icon: Icons.history,
              iconColor: isDark ? AppTheme.darkTextTertiary : Colors.grey.shade500,
              label: l10n.recentSearchesLabel,
              routes: recent,
              isDark: isDark,
              chipColor: AppTheme.adaptive(isDark),
              onTap: (s) {
                ctrl.depStation.value = s.dep;
                ctrl.arrStation.value = s.arr;
              },
              onRemove: (s) => ctrl.removeRecentRoute(s.dep, s.arr),
            );
          }),

          // const SizedBox(height: 12),

          // ── Accessibility toggle — hidden until station data is complete ──
          /*
          const SizedBox(height: 12),
          Obx(() => GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  ctrl.preferAccessible.toggle();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: ctrl.preferAccessible.value
                        ? AppTheme.primaryNile.withOpacity(0.12)
                        : (isDark
                            ? Colors.white.withOpacity(0.04)
                            : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ctrl.preferAccessible.value
                          ? AppTheme.primaryNile.withOpacity(0.4)
                          : (isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.accessible_rounded,
                        size: 16,
                        color: ctrl.preferAccessible.value
                            ? AppTheme.primaryNile
                            : (isDark
                                ? AppTheme.darkTextTertiary
                                : Colors.grey.shade500),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.accessibleRoute,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: ctrl.preferAccessible.value
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: ctrl.preferAccessible.value
                              ? AppTheme.primaryNile
                              : (isDark
                                  ? AppTheme.darkTextSub
                                  : Colors.grey.shade600),
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          ctrl.preferAccessible.value
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          key: ValueKey(ctrl.preferAccessible.value),
                          size: 16,
                          color: ctrl.preferAccessible.value
                              ? AppTheme.primaryNile
                              : (isDark
                                  ? AppTheme.darkTextTertiary
                                  : Colors.grey.shade400),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 12),
          */

          const SizedBox(height: 12),

          // ── Search button ────────────────────────────────────────────────
          Obx(() {
            final valid = ctrl.depStation.value.isNotEmpty &&
                ctrl.arrStation.value.isNotEmpty &&
                ctrl.depStation.value != ctrl.arrStation.value;
            return SizedBox(
              key: TourKeys.searchButton,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: valid
                    ? () {
                        HapticFeedback.mediumImpact();
                        ctrl.saveRecentRoute(
                            ctrl.depStation.value, ctrl.arrStation.value);
                        final destPos = ctrl.destinationLocationOrNull;
                        Get.to(
                          () => Routepage(),
                          arguments: {
                            'DepartureStation': ctrl.depStation.value,
                            'ArrivalStation': ctrl.arrStation.value,
                            'SortType': '0',
                            'PreferAccessible':
                                ctrl.preferAccessible.value ? '1' : '0',
                            // Last-mile: arrival station → user's searched destination
                            if (destPos != null) ...{
                              'DestLat': destPos.latitude.toString(),
                              'DestLng': destPos.longitude.toString(),
                              'DestName': ctrl.destinationController.text,
                            },
                          },
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: valid
                      ? AppTheme.adaptive(isDark)
                      : (isDark
                          ? AppTheme.darkElevated
                          : Colors.grey.shade300),
                  foregroundColor: valid
                      ? Colors.white
                      : (isDark
                          ? AppTheme.darkTextTertiary
                          : Colors.grey.shade600),
                  elevation: valid ? 2 : 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(
                    valid ? Icons.directions_rounded : Icons.block,
                    size: 20),
                label: Text(
                  l10n.showRoutesButtonText,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
      );
}

// ── Depart time chip (formerly _DepartChip in homepage.dart) ─────────────────

class _DepartChip extends StatefulWidget {
  final AppLocalizations l10n;
  const _DepartChip({required this.l10n});

  @override
  State<_DepartChip> createState() => _DepartChipState();
}

class _DepartChipState extends State<_DepartChip> {
  DateTime? _dt;

  @override
  Widget build(BuildContext context) {
    final label = _dt == null
        ? widget.l10n.leaveNowLabel
        : '${_dt!.hour.toString().padLeft(2, '0')}:${_dt!.minute.toString().padLeft(2, '0')}';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipColor = AppTheme.adaptive(isDark);
    return GestureDetector(
      onTap: () async {
        HapticFeedback.selectionClick();
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 30)),
        );
        if (date == null || !context.mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time == null) return;
        setState(() => _dt = DateTime(
            date.year, date.month, date.day, time.hour, time.minute));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: chipColor.withValues(alpha: isDark ? 0.14 : 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: chipColor.withValues(alpha: isDark ? 0.30 : 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time_rounded, size: 13, color: chipColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: chipColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable chip row (favorites + recent) ────────────────────────────────────

class _RouteChipRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final List<RecentRoute> routes;
  final bool isDark;
  final Color chipColor;
  final void Function(RecentRoute) onTap;
  final void Function(RecentRoute) onRemove;

  const _RouteChipRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.routes,
    required this.isDark,
    required this.chipColor,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkTextSub : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: routes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (_, i) {
              final s = routes[i];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(s);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 4, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: chipColor.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: chipColor.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${s.dep}  →  ${s.arr}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: chipColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onRemove(s);
                        },
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: chipColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 10,
                            color: chipColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
