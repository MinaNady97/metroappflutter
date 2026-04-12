import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';

// ── Method channel — triggers the native Google Play Services dialog ──────────
const _locationChannel = MethodChannel('com.metroapp/location');

/// Shows the native Google Play Services "Turn on location?" dialog that
/// resolves inline (like Uber) without leaving the app.
/// Returns true if the user turned location on, false otherwise.
Future<bool> requestLocationServiceNative() async {
  try {
    final result =
        await _locationChannel.invokeMethod<bool>('requestLocationService');
    return result ?? false;
  } catch (_) {
    // Falls back to opening settings if the channel call fails
    await Geolocator.openLocationSettings();
    return false;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Location permission / service dialog — shown instead of a snackbar when
// location is unavailable.  Pass [type] to control copy + action.
// ─────────────────────────────────────────────────────────────────────────────

enum LocationDialogType {
  /// App permission was denied (can ask again).
  permissionDenied,

  /// App permission was denied forever (must open settings).
  permissionPermanentlyDenied,
}

Future<void> showLocationDialog(
  BuildContext context, {
  required LocationDialogType type,
  required String noThanksLabel,
  required String openSettingsLabel,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _LocationDialog(
      type: type,
      noThanksLabel: noThanksLabel,
      openSettingsLabel: openSettingsLabel,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class _LocationDialog extends StatelessWidget {
  final LocationDialogType type;
  final String noThanksLabel;
  final String openSettingsLabel;

  const _LocationDialog({
    required this.type,
    required this.noThanksLabel,
    required this.openSettingsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : Colors.white;
    final textPrimary = isDark ? AppTheme.darkText : AppTheme.lightTextPrimary;
    final textSub = isDark ? AppTheme.darkTextSub : AppTheme.lightBodyText;
    final dividerColor = isDark ? AppTheme.darkDivider : AppTheme.lightBorder;

    // Content varies by type
    final _Content c = _content(type, context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.45 : 0.12),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon header ────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.primaryNile.withOpacity(0.12)
                    : AppTheme.primaryNile.withOpacity(0.06),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryNile.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 32,
                      color: AppTheme.primaryNile,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      c.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ───────────────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: textSub,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...c.bullets.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryNile.withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(b.icon,
                                size: 15, color: AppTheme.primaryNile),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                b.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: textPrimary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider + buttons ──────────────────────────────────────────
            Divider(height: 1, thickness: 1, color: dividerColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Row(
                children: [
                  // No thanks
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(
                          color: isDark
                              ? AppTheme.darkBorder
                              : AppTheme.lightBorder,
                          width: 1.5,
                        ),
                        foregroundColor: textSub,
                      ),
                      child: Text(
                        noThanksLabel,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Turn on / Open settings
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await c.action();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryNile,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        openSettingsLabel,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
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

  _Content _content(LocationDialogType type, BuildContext context) {
    switch (type) {
      case LocationDialogType.permissionDenied:
        return _Content(
          title: 'Location Access Required',
          subtitle:
              'Allow Cairo Metro to access your location so we can find the nearest station automatically:',
          bullets: [
            _Bullet(Icons.directions_subway_rounded,
                'Find your nearest metro station'),
            _Bullet(Icons.route_rounded,
                'Plan routes from your current position'),
          ],
          action: Geolocator.requestPermission,
        );
      case LocationDialogType.permissionPermanentlyDenied:
        return _Content(
          title: 'Location Access Required',
          subtitle:
              'Location permission was permanently denied. Open app settings to allow location access:',
          bullets: [
            _Bullet(Icons.directions_subway_rounded,
                'Find your nearest metro station'),
            _Bullet(Icons.route_rounded,
                'Plan routes from your current position'),
          ],
          action: Geolocator.openAppSettings,
        );
    }
  }
}

class _Content {
  final String title;
  final String subtitle;
  final List<_Bullet> bullets;
  final Future<dynamic> Function() action;

  const _Content({
    required this.title,
    required this.subtitle,
    required this.bullets,
    required this.action,
  });
}

class _Bullet {
  final IconData icon;
  final String label;
  const _Bullet(this.icon, this.label);
}
