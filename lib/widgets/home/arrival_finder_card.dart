import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/homepagecontroller.dart';
import '../../Pages/location_picker_page.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/local_search_service.dart';
import '../../tour/tour_keys.dart';

// ── ArrivalFinderCard ─────────────────────────────────────────────────────────

/// Card that lets users type a destination address (with autocomplete) or pick
/// one from the map, and sets it as the arrival station.
class ArrivalFinderCard extends StatefulWidget {
  const ArrivalFinderCard({super.key});

  @override
  State<ArrivalFinderCard> createState() => _ArrivalFinderCardState();
}

class _ArrivalFinderCardState extends State<ArrivalFinderCard> {
  final TextEditingController _destCtrl = TextEditingController();
  final FocusNode _destFocus = FocusNode();
  late final HomepageController _ctrl;

  // Stored after a successful find — null means no successful result yet.
  Position? _foundStationPos; // nearest metro station to the destination
  Position? _searchedDestPos; // the destination the user searched for

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<HomepageController>();
  }

  @override
  void deactivate() {
    _destFocus.unfocus();
    super.deactivate();
  }

  @override
  void dispose() {
    _destCtrl.dispose();
    _destFocus.dispose();
    super.dispose();
  }

  // ── Snack helper ──────────────────────────────────────────────────────────

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? AppTheme.error : AppTheme.success,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _findByAddress(AppLocalizations l10n) async {
    HapticFeedback.selectionClick();
    final ok = await _ctrl.updateArrivalFromInput(context, _destCtrl.text);
    if (!context.mounted) return;
    if (!ok) {
      _snack(l10n.addressNotFound, error: true);
      return;
    }
    _capturePositions();
    _snack('${l10n.stationFound}: ${_ctrl.arrStation.value}');
  }

  Future<void> _pickFromMap(AppLocalizations l10n) async {
    final picked = await Get.to<Position?>(() => const LocationPickerPage());
    if (picked == null || !context.mounted) return;
    final ok = await _ctrl.updateArrivalFromPosition(context, picked);
    if (!context.mounted) return;
    if (!ok) {
      _snack(l10n.addressNotFound, error: true);
      return;
    }
    _capturePositions();
    _snack('${l10n.stationFound}: ${_ctrl.arrStation.value}');
  }

  Future<void> _selectLandmark(
      LandmarkResult landmark, AppLocalizations l10n) async {
    final ok = await _ctrl.updateArrivalFromLandmark(context, landmark);
    if (!context.mounted) return;
    if (!ok) {
      _snack(l10n.addressNotFound, error: true);
      return;
    }
    _capturePositions();
    _snack('${l10n.stationFound}: ${_ctrl.arrStation.value}');
  }

  /// Snapshot the controller's resolved positions into local state so the
  /// Maps button remains available even if the controller is updated later.
  void _capturePositions() {
    try {
      setState(() {
        _foundStationPos = _ctrl.arrivalLocation;
        _searchedDestPos = _ctrl.destinationLocation;
      });
    } catch (_) {
      // Positions not yet initialised — ignore.
    }
  }

  // ── Google Maps ───────────────────────────────────────────────────────────

  Future<void> _openMaps(String mode) async {
    final station = _foundStationPos;
    final dest = _searchedDestPos;
    if (station == null || dest == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${station.latitude},${station.longitude}'
      '&destination=${dest.latitude},${dest.longitude}'
      '&travelmode=$mode',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _showMapsSheet(AppLocalizations l10n) {
    if (_foundStationPos == null || _searchedDestPos == null) return;
    HapticFeedback.selectionClick();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ArrivalDirectionsSheet(
        l10n: l10n,
        isDark: isDark,
        stationName: _ctrl.arrStation.value,
        destinationName: _destCtrl.text,
        onWalking: () {
          Navigator.pop(context);
          _openMaps('walking');
        },
        onDriving: () {
          Navigator.pop(context);
          _openMaps('driving');
        },
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Container(
      key: TourKeys.arrivalFinderCard,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
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
                  color:
                      const Color(0xFF00897B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.pin_drop_rounded,
                  color: Color(0xFF00897B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.findNearestStation,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.adaptive(isDark),
                        letterSpacing: -0.1,
                      ),
                    ),
                    Text(
                      l10n.destinationFieldLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF78909C),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Search input ─────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? AppTheme.darkBorder
                    : Colors.grey.shade200,
              ),
            ),
            child: TextField(
              controller: _destCtrl,
              focusNode: _destFocus,
              decoration: InputDecoration(
                hintText: l10n.destinationFieldLabel,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9E9E9E),
                ),
                prefixIcon: Icon(
                  Icons.place_outlined,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                suffixIcon: _destCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () {
                          _destCtrl.clear();
                          _ctrl.onDestinationTextChanged('');
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (v) {
                _ctrl.onDestinationTextChanged(v);
                setState(() {});
              },
              onSubmitted: (_) => _findByAddress(l10n),
            ),
          ),

          // ── Autocomplete suggestions ─────────────────────────────────────
          Obx(() {
            final suggestions = _ctrl.autocompleteSuggestions;
            final loading = _ctrl.isFetchingOnlineSuggestions.value;
            final isArabic = _ctrl.isInputArabic.value;
            if (suggestions.isEmpty && !loading) {
              return const SizedBox.shrink();
            }
            return _AutocompleteList(
              suggestions: suggestions.toList(),
              loading: loading,
              isArabic: isArabic,
              onSelect: (s) {
                final fillText =
                    (isArabic && s.nameAr.isNotEmpty) ? s.nameAr : s.name;
                _destCtrl.text = fillText;
                _ctrl.onDestinationTextChanged('');
                setState(() {});
                _selectLandmark(s, l10n);
              },
            );
          }),

          const SizedBox(height: 8),

          // ── Google Maps link hint ────────────────────────────────────────
          if (_destCtrl.text.contains('maps.google') ||
              _destCtrl.text.contains('goo.gl/maps'))
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 12, color: AppTheme.success),
                  const SizedBox(width: 6),
                  Text(
                    l10n.googleMapsLinkDetected,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF78909C),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

          // ── "Did You Mean?" ──────────────────────────────────────────────
          Obx(() {
            final dym = _ctrl.didYouMeanSuggestions;
            if (dym.isEmpty) return const SizedBox.shrink();
            return _DidYouMean(
              suggestions: dym.toList(),
              onSelect: (s) {
                final chipLabel =
                    _ctrl.isInputArabic.value && s.nameAr.isNotEmpty
                        ? s.nameAr
                        : s.name;
                _destCtrl.text = chipLabel;
                _ctrl.didYouMeanSuggestions.clear();
                setState(() {});
                _selectLandmark(s, l10n);
              },
            );
          }),

          const SizedBox(height: 12),

          // ── Action buttons ───────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _findByAddress(l10n),
                  icon: const Icon(Icons.search_rounded, size: 16),
                  label: Text(l10n.findButtonText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.adaptive(isDark),
                    foregroundColor: Colors.white,
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
                  onPressed: () => _pickFromMap(l10n),
                  icon: const Icon(Icons.map_outlined, size: 16),
                  label: Text(l10n.pickFromMapLabel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.adaptive(isDark),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(
                        color: AppTheme.adaptive(isDark)
                            .withValues(alpha: isDark ? 0.50 : 0.30)),
                  ),
                ),
              ),
            ],
          ),

          // ── "Station → Destination" Maps button ─────────────────────────
          if (_foundStationPos != null && _searchedDestPos != null) ...[
            const SizedBox(height: 10),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showMapsSheet(l10n),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.adaptive(isDark).withValues(
                        alpha: isDark ? 0.12 : 0.07),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.adaptive(isDark).withValues(
                          alpha: isDark ? 0.30 : 0.20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppTheme.adaptive(isDark)
                              .withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.near_me_rounded,
                            size: 15,
                            color: AppTheme.adaptive(isDark)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.getDirections,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.adaptive(isDark),
                              ),
                            ),
                            Text(
                              '${_ctrl.arrStation.value}  →  ${_destCtrl.text}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppTheme.darkTextSub
                                    : Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.open_in_new_rounded,
                        size: 15,
                        color: AppTheme.adaptive(isDark).withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Directions bottom sheet (station → destination) ───────────────────────────

class _ArrivalDirectionsSheet extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDark;
  final String stationName;
  final String destinationName;
  final VoidCallback onWalking;
  final VoidCallback onDriving;

  const _ArrivalDirectionsSheet({
    required this.l10n,
    required this.isDark,
    required this.stationName,
    required this.destinationName,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_rounded,
                      color: AppTheme.success, size: 18),
                ),
                const SizedBox(width: 12),
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
                        '$stationName  →  $destinationName',
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
          Divider(
              height: 1,
              color: isDark ? AppTheme.darkDivider : Colors.grey.shade100),
          const SizedBox(height: 8),

          // Walking
          _SheetOption(
            icon: Icons.directions_walk_rounded,
            label: l10n.walkingDirections,
            color: const Color(0xFF2E7D32),
            isDark: isDark,
            onTap: onWalking,
          ),
          // Driving
          _SheetOption(
            icon: Icons.directions_car_rounded,
            label: l10n.drivingDirections,
            color: isDark ? AppTheme.darkPrimary : AppTheme.primaryNile,
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
                color: color.withValues(alpha: 0.10),
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
            Icon(Icons.open_in_new_rounded,
                size: 16,
                color: isDark
                    ? AppTheme.darkTextTertiary
                    : Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

// ── Autocomplete suggestions list ─────────────────────────────────────────────

class _AutocompleteList extends StatelessWidget {
  final List<LandmarkResult> suggestions;
  final bool loading;
  final bool isArabic;
  final void Function(LandmarkResult) onSelect;

  const _AutocompleteList({
    required this.suggestions,
    required this.loading,
    required this.isArabic,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkElevated : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...suggestions.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            final isOnline = s.source == 'online';
            final isLast = i == suggestions.length - 1 && !loading;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  borderRadius: BorderRadius.only(
                    topLeft: i == 0
                        ? const Radius.circular(14)
                        : Radius.zero,
                    topRight: i == 0
                        ? const Radius.circular(14)
                        : Radius.zero,
                    bottomLeft: isLast
                        ? const Radius.circular(14)
                        : Radius.zero,
                    bottomRight: isLast
                        ? const Radius.circular(14)
                        : Radius.zero,
                  ),
                  onTap: () => onSelect(s),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          LocalSearchService.typeEmoji(s.type),
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Builder(builder: (_) {
                            final String primary;
                            final String secondary;
                            if (isOnline) {
                              primary = s.name;
                              secondary = '';
                            } else if (isArabic && s.nameAr.isNotEmpty) {
                              primary = s.nameAr;
                              secondary = s.name;
                            } else {
                              primary = s.name;
                              secondary = s.nameAr;
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  primary,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppTheme.darkPrimary
                                        : AppTheme.primaryNile,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                ),
                                if (secondary.isNotEmpty)
                                  Text(
                                    secondary,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppTheme.darkTextTertiary
                                          : Colors.grey.shade500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            );
                          }),
                        ),
                        if (isOnline)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? AppTheme.darkPrimary
                                      : AppTheme.primaryNile)
                                  .withValues(alpha: isDark ? 0.18 : 0.10),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'web',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppTheme.darkPrimary
                                    : AppTheme.primaryNile,
                                letterSpacing: 0.3,
                              ),
                            ),
                          )
                        else
                          Icon(
                            Icons.north_west_rounded,
                            size: 13,
                            color: isDark
                                ? AppTheme.darkTextTertiary
                                : Colors.grey.shade400,
                          ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? AppTheme.darkBorder.withValues(alpha: 0.5)
                        : Colors.grey.shade100,
                    indent: 14,
                    endIndent: 14,
                  ),
              ],
            );
          }),
          // Loading footer
          if (loading)
            Padding(
              padding: EdgeInsets.fromLTRB(
                  14, suggestions.isEmpty ? 12 : 8, 14, 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: (isDark
                              ? AppTheme.darkPrimary
                              : AppTheme.primaryNile)
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.searchingOnline,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppTheme.darkTextTertiary
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── "Did You Mean?" chips ─────────────────────────────────────────────────────

class _DidYouMean extends StatelessWidget {
  final List<LandmarkResult> suggestions;
  final void Function(LandmarkResult) onSelect;

  const _DidYouMean({required this.suggestions, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final ctrl = Get.find<HomepageController>();
      final arabic = ctrl.isInputArabic.value;
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                AppLocalizations.of(context)!.didYouMean,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppTheme.darkTextTertiary
                      : Colors.grey.shade500,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: suggestions.map((s) {
                final chipLabel =
                    arabic && s.nameAr.isNotEmpty ? s.nameAr : s.name;
                return ActionChip(
                  avatar: Text(
                    LocalSearchService.typeEmoji(s.type),
                    style: const TextStyle(fontSize: 13),
                  ),
                  label: Text(
                    chipLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.darkPrimary
                          : AppTheme.primaryNile,
                    ),
                    textDirection:
                        arabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  backgroundColor:
                      isDark ? AppTheme.darkElevated : AppTheme.lightSubtle,
                  side: BorderSide(
                    color: AppTheme.primaryNile.withValues(alpha: 0.25),
                  ),
                  onPressed: () => onSelect(s),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}
