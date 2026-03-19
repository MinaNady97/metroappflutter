import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GeocodingCacheService
//
// Persists successful forward-geocoding results in SharedPreferences so the
// same address never needs a network round-trip twice.
//
// Cache key   : 'geocache_' + normalized query (lowercase, collapsed spaces)
// Cache value : JSON {"lat":…,"lng":…,"ts":<epoch-ms>}
// TTL         : 30 days
// ─────────────────────────────────────────────────────────────────────────────

class GeocodingCacheService {
  static const _prefix = 'geocache_';
  static const _ttlMs = 30 * 24 * 60 * 60 * 1000; // 30 days in ms

  // ── Read ───────────────────────────────────────────────────────────────────

  /// Returns [lat, lng] if a fresh cache entry exists, null otherwise.
  static Future<List<double>?> get(String query) async {
    final key = _key(query);
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null) return null;

      final data = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (data['ts'] as num?)?.toInt() ?? 0;
      if (DateTime.now().millisecondsSinceEpoch - ts > _ttlMs) {
        await prefs.remove(key); // expired
        return null;
      }

      final lat = (data['lat'] as num?)?.toDouble();
      final lng = (data['lng'] as num?)?.toDouble();
      if (lat == null || lng == null) return null;
      return [lat, lng];
    } catch (_) {
      return null;
    }
  }

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Stores a geocoding result. Fire-and-forget (caller need not await).
  static Future<void> put(String query, double lat, double lng) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _key(query),
        jsonEncode({
          'lat': lat,
          'lng': lng,
          'ts': DateTime.now().millisecondsSinceEpoch,
        }),
      );
    } catch (_) {
      // Cache write failure is non-fatal
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static String _key(String query) =>
      _prefix + query.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
}
