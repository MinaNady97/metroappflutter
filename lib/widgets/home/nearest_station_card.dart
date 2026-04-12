import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/homepagecontroller.dart';
import '../../Constants/metro_stations.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../tour/tour_keys.dart';
import '../location_permission_dialog.dart';

/// Displays the nearest metro station to the user's current location.
///
/// States:
///   • Idle (no location yet) — shows a "find nearest station" prompt.
///   • Loading               — shows a progress indicator.
///   • Found                 — shows station name, line badge, distance,
///                             directions button, and "Set as departure" action.
///
/// Auto-triggers location detection on first display.
class NearestStationCard extends StatefulWidget {
  const NearestStationCard({super.key});

  @override
  State<NearestStationCard> createState() => _NearestStationCardState();
}

class _NearestStationCardState extends State<NearestStationCard> {
  bool _triggered = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctrl = Get.find<HomepageController>();
      // Only auto-trigger if we haven't found a station yet and not loading
      if (!ctrl.nearestRouteButtonFlag.value && !ctrl.isLocatingNearest.value) {
        _triggered = true;
        _locate();
      }
      // Auto-refresh every 60 s so moving users see their real nearest station.
      _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
        if (mounted) _locate();
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _locate() async {
    if (!mounted) return;
    final ctrl = Get.find<HomepageController>();
    try {
      await ctrl.updateUserLocation(context);
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      final l10n = AppLocalizations.of(context)!;
      if (msg.contains('disabled')) {
        // Skip the intermediate app dialog and go straight to the native
        // system "Turn on location?" prompt so the user only sees one dialog.
        await requestLocationServiceNative();
      } else if (msg.contains('permanently')) {
        await showLocationDialog(
          context,
          type: LocationDialogType.permissionPermanentlyDenied,
          noThanksLabel: l10n.locationDialogNoThanks,
          openSettingsLabel: l10n.locationDialogOpenSettings,
        );
      } else if (msg.contains('denied')) {
        await showLocationDialog(
          context,
          type: LocationDialogType.permissionDenied,
          noThanksLabel: l10n.locationDialogNoThanks,
          openSettingsLabel: l10n.locationDialogOpenSettings,
        );
      }
      // Silently ignore other errors (e.g. user dismissed first-time)
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomepageController>();
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KeyedSubtree(
      key: TourKeys.nearestStationCard,
      child: Obx(() {
      final locating = ctrl.isLocatingNearest.value;
      final found = ctrl.nearestRouteButtonFlag.value;
      final station = ctrl.nearestStationName.value;
      final distM = ctrl.nearestDistanceM.value;

      if (locating) {
        return _LoadingCard(isDark: isDark, l10n: l10n);
      }

      if (!found || station.isEmpty) {
        return _PromptCard(
          isDark: isDark,
          l10n: l10n,
          onTap: () {
            HapticFeedback.selectionClick();
            _locate();
          },
        );
      }

      final lineMap = getStationLineMap(context);
      final lines = lineMap[station] ?? ['1'];

      return _FoundCard(
        isDark: isDark,
        l10n: l10n,
        station: station,
        lines: lines,
        distanceM: distM,
        userLat: ctrl.userLocation.latitude,
        userLng: ctrl.userLocation.longitude,
        stationLat: ctrl.departureLocation.latitude,
        stationLng: ctrl.departureLocation.longitude,
        onRefresh: () {
          HapticFeedback.selectionClick();
          _locate();
        },
        onSetAsDeparture: () {
          HapticFeedback.mediumImpact();
          final s = ctrl.nearestStationName.value;
          ctrl.depStation.value = s;
          ctrl.depStationIndex = ctrl.allMetroStations.indexOf(s);
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
            content: Text('${l10n.useAsDeparture}: $station'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.success,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ));
        },
      );
    }),   // end Obx
    );    // end KeyedSubtree
  }
}

// ── Prompt card (no location yet) ────────────────────────────────────────────

class _PromptCard extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _PromptCard({
    required this.isDark,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final border = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final textColor = isDark ? AppTheme.darkText : AppTheme.lightTextPrimary;
    final subColor = isDark ? AppTheme.darkTextSub : Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryNile
                        .withValues(alpha: isDark ? 0.2 : 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: AppTheme.primaryNile,
                    size: 22,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryNile,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'GPS',
                      style: TextStyle(
                        fontSize: 7,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.nearestStationTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.nearestStationSubtitle,
                    style: TextStyle(fontSize: 11, color: subColor),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.primaryNile.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading card ──────────────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;

  const _LoadingCard({required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final border = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation(AppTheme.primaryNile),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            l10n.nearestStationLocating,
            style: TextStyle(
              fontSize: 13,
              color:
                  isDark ? AppTheme.darkTextSub : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Found card ────────────────────────────────────────────────────────────────

class _FoundCard extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final String station;
  final List<String> lines;
  final double distanceM;
  final double userLat;
  final double userLng;
  final double stationLat;
  final double stationLng;
  final VoidCallback onRefresh;
  final VoidCallback onSetAsDeparture;

  const _FoundCard({
    required this.isDark,
    required this.l10n,
    required this.station,
    required this.lines,
    required this.distanceM,
    required this.userLat,
    required this.userLng,
    required this.stationLat,
    required this.stationLng,
    required this.onRefresh,
    required this.onSetAsDeparture,
  });

  Color _lineColor(String line) => switch (line) {
        '1' => AppTheme.line1,
        '2' => AppTheme.line2,
        '3' => AppTheme.line3,
        'LRT' => AppTheme.lrt,
        _ => AppTheme.primaryNile,
      };

  String _distanceLabel() {
    if (distanceM < 1000) return '${distanceM.round()} m';
    return '${(distanceM / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _openMaps(BuildContext context, String mode) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=$userLat,$userLng'
      '&destination=$stationLat,$stationLng'
      '&travelmode=$mode',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _showDirectionsSheet(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _DirectionsSheet(
        l10n: l10n,
        isDark: isDark,
        stationName: station,
        onWalking: () {
          Navigator.pop(context);
          _openMaps(context, 'walking');
        },
        onDriving: () {
          Navigator.pop(context);
          _openMaps(context, 'driving');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryLine = lines.first;
    final lineColor = _lineColor(primaryLine);
    final bg = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final textColor = isDark ? AppTheme.darkText : AppTheme.lightTextPrimary;
    final subColor = isDark ? AppTheme.darkTextSub : Colors.grey.shade500;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: lineColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: lineColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: line badges + station info + refresh ──────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Line badge(s)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: lines
                      .map((ln) => Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: _lineColor(ln),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  ln,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 12),
                // Station name + distance chip
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              station,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (distanceM > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: lineColor
                                    .withValues(alpha: isDark ? 0.2 : 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.directions_walk_rounded,
                                      size: 10, color: lineColor),
                                  const SizedBox(width: 2),
                                  Text(
                                    _distanceLabel(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: lineColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.gps_fixed_rounded,
                              size: 10,
                              color: subColor),
                          const SizedBox(width: 3),
                          Text(
                            l10n.nearestStationCaption,
                            style: TextStyle(fontSize: 11, color: subColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Refresh icon
                GestureDetector(
                  onTap: onRefresh,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: lineColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // ── Action row: Directions + Set as Departure ──────────────────
            Row(
              children: [
                // Directions button
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showDirectionsSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: lineColor.withValues(alpha: isDark ? 0.15 : 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: lineColor.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined,
                              size: 14, color: lineColor),
                          const SizedBox(width: 5),
                          Text(
                            l10n.getDirections,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: lineColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Set as departure button
                Expanded(
                  child: GestureDetector(
                    onTap: onSetAsDeparture,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryNile
                            .withValues(alpha: isDark ? 0.15 : 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppTheme.primaryNile
                                .withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.trip_origin_rounded,
                              size: 14, color: AppTheme.primaryNile),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              l10n.useAsDeparture,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryNile,
                              ),
                              overflow: TextOverflow.ellipsis,
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
    );
  }
}

// ── Directions bottom sheet ───────────────────────────────────────────────────

class _DirectionsSheet extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDark;
  final String stationName;
  final VoidCallback onWalking;
  final VoidCallback onDriving;

  const _DirectionsSheet({
    required this.l10n,
    required this.isDark,
    required this.stationName,
    required this.onWalking,
    required this.onDriving,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppTheme.darkCard : Colors.white;
    final textColor = isDark ? AppTheme.darkText : AppTheme.lightTextPrimary;
    final subColor = isDark ? AppTheme.darkTextSub : Colors.grey.shade500;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.directions_rounded,
                    color: AppTheme.primaryNile, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.getDirections,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        stationName,
                        style: TextStyle(fontSize: 12, color: subColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: isDark ? AppTheme.darkDivider : Colors.grey.shade100),
          const SizedBox(height: 8),

          // Walking option
          _SheetOption(
            icon: Icons.directions_walk_rounded,
            label: l10n.walkingDirections,
            color: const Color(0xFF2E7D32),
            isDark: isDark,
            onTap: onWalking,
          ),

          // Driving option
          _SheetOption(
            icon: Icons.directions_car_rounded,
            label: l10n.drivingDirections,
            color: AppTheme.primaryNile,
            isDark: isDark,
            onTap: onDriving,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDark
                    ? AppTheme.darkTextTertiary
                    : Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
