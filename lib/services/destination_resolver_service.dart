import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'geocoding_cache_service.dart';
import 'local_search_service.dart';
import 'location_service.dart';

/// Encapsulates the 5-tier destination geocoding pipeline and autocomplete
/// suggestion fetching. All methods are pure — no Rx state.
class DestinationResolverService {
  DestinationResolverService._();
  static final DestinationResolverService instance =
      DestinationResolverService._();


  // ── 5-Tier resolution pipeline ───────────────────────────────────────────────

  /// Resolve [rawInput] to a [Position] using the 5-tier fallback strategy.
  /// Returns `null` when all tiers fail.
  Future<Position?> resolve(String rawInput) async {
    final input = rawInput.trim();
    if (input.isEmpty) return null;

    // Tier 0: Local offline landmark database
    final localMatches = LocalSearchService.instance.search(input, maxResults: 1);
    if (localMatches.isNotEmpty && localMatches.first.score >= 0.65) {
      final hit = localMatches.first;
      return LocationService.instance.makePosition(hit.lat, hit.lng);
    }

    // Tier 1: Direct lat/lng in input
    final coords = extractLatLng(input);
    if (coords != null) {
      return LocationService.instance.makePosition(coords[0], coords[1]);
    }

    // Tier 2: Geocoding cache
    final cached = await GeocodingCacheService.get(input);
    if (cached != null) {
      return LocationService.instance.makePosition(cached[0], cached[1]);
    }

    // Tier 3: Device geocoder
    var resolved = await geocodeWithDevice(input);
    if (resolved != null) {
      await GeocodingCacheService.put(
          input, resolved.latitude, resolved.longitude);
      return resolved;
    }

    // Tier 4: Nominatim online geocoder
    resolved = await geocodeWithNominatim(input);
    if (resolved != null) {
      await GeocodingCacheService.put(
          input, resolved.latitude, resolved.longitude);
      return resolved;
    }

    // Tier 5: Maps URL query string extraction
    final uri = tryParseUriLenient(input);
    final queryText =
        uri?.queryParameters['q'] ?? uri?.queryParameters['query'];
    if (queryText != null && queryText.trim().isNotEmpty) {
      resolved = await geocodeWithDevice(queryText.trim());
      resolved ??= await geocodeWithNominatim(queryText.trim());
      if (resolved != null) {
        await GeocodingCacheService.put(
            queryText.trim(), resolved.latitude, resolved.longitude);
        return resolved;
      }
    }

    return null;
  }

  // ── Autocomplete ─────────────────────────────────────────────────────────────

  /// Fetch and merge online Nominatim suggestions for [query].
  /// Returns merged list (local results first, online appended).
  Future<List<LandmarkResult>> fetchAutocompleteSuggestions(
    String query, {
    List<LandmarkResult> existing = const [],
    bool arabic = false,
  }) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': query,
        'format': 'json',
        'limit': '6',
        'countrycodes': 'eg',
        'accept-language': arabic ? 'ar' : 'en',
        'viewbox': '30.6,30.4,32.2,29.7',
      });

      final response = await http.get(uri, headers: {
        'User-Agent': 'metroappflutter/1.0 (Cairo Metro Guide)',
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) return existing.toList();

      final data = jsonDecode(response.body) as List<dynamic>;
      final online = <LandmarkResult>[];

      for (final item in data) {
        final lat = double.tryParse(item['lat']?.toString() ?? '');
        final lng = double.tryParse(item['lon']?.toString() ?? '');
        final displayName = (item['display_name'] as String?) ?? '';
        if (lat == null || lng == null || displayName.isEmpty) continue;
        if (lat < 22 || lat > 32 || lng < 24 || lng > 37) continue;

        final shortName = displayName.split(',').first.trim();
        if (shortName.isEmpty) continue;

        online.add(LandmarkResult(
          name: shortName,
          nameAr: '',
          lat: lat,
          lng: lng,
          type: nominatimType(
            item['class'] as String? ?? '',
            item['type'] as String? ?? '',
          ),
          score: 0.5,
          source: 'online',
        ));
      }

      final merged = List<LandmarkResult>.from(existing);
      for (final o in online) {
        final isDupe = merged.any((e) =>
            e.name.toLowerCase() == o.name.toLowerCase() ||
            kmBetween(e.lat, e.lng, o.lat, o.lng) < 0.15);
        if (!isDupe) merged.add(o);
      }

      merged.sort((a, b) {
        if (a.source == b.source) return b.score.compareTo(a.score);
        return a.source == 'local' ? -1 : 1;
      });

      return merged.take(8).toList();
    } catch (_) {
      return existing.toList();
    }
  }

  // ── Individual geocoding tiers ───────────────────────────────────────────────

  Future<Position?> geocodeWithDevice(String input) async {
    try {
      final locations = await locationFromAddress(input)
          .timeout(const Duration(seconds: 8));
      if (locations.isEmpty) return null;
      return LocationService.instance.locationToPosition(locations.first);
    } catch (e) {
      return null;
    }
  }

  Future<Position?> geocodeWithNominatim(String input) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': input,
        'format': 'json',
        'limit': '1',
      });
      final response = await http.get(uri, headers: {
        'User-Agent': 'metroappflutter/1.0 (Cairo Metro Guide)',
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      if (data is! List || data.isEmpty) return null;
      final item = data.first;
      final lat = double.tryParse(item['lat']?.toString() ?? '');
      final lng = double.tryParse(item['lon']?.toString() ?? '');
      if (lat == null || lng == null) return null;
      return LocationService.instance.makePosition(lat, lng);
    } catch (e) {
      return null;
    }
  }

  // ── Utility helpers ──────────────────────────────────────────────────────────

  List<double>? extractLatLng(String input) {
    final decoded = safeDecode(input);
    final normalized = decoded.replaceAll('+', ' ');

    final atPattern = RegExp(r'@(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)');
    final directPattern =
        RegExp(r'(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)');

    RegExpMatch? match = atPattern.firstMatch(normalized);
    match ??= directPattern.firstMatch(normalized);

    if (match != null) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null && lat.abs() <= 90 && lng.abs() <= 180) {
        return [lat, lng];
      }
    }

    final uri = tryParseUriLenient(normalized);
    if (uri != null) {
      final q = uri.queryParameters['q'] ?? uri.queryParameters['query'];
      if (q != null && q.isNotEmpty) return extractLatLng(q);
    }
    return null;
  }

  Uri? tryParseUriLenient(String value) {
    final direct = Uri.tryParse(value);
    if (direct != null) return direct;
    final decoded = safeDecode(value);
    if (decoded == value) return null;
    return Uri.tryParse(decoded);
  }

  String safeDecode(String value) {
    try {
      return Uri.decodeFull(value);
    } catch (_) {
      return value;
    }
  }

  double kmBetween(double lat1, double lng1, double lat2, double lng2) {
    final dlat = (lat2 - lat1) * 111.0;
    final dlng = (lng2 - lng1) * 111.0 * cos(lat1 * pi / 180);
    return sqrt(dlat * dlat + dlng * dlng);
  }

  String nominatimType(String cls, String type) => switch (cls) {
        'amenity' => switch (type) {
            'hospital' || 'clinic' => 'hospital',
            'university' || 'college' || 'school' => 'university',
            'place_of_worship' => 'mosque',
            'marketplace' || 'market' => 'market',
            'museum' => 'museum',
            _ => 'place',
          },
        'tourism' => switch (type) {
            'hotel' || 'motel' || 'hostel' => 'hotel',
            'museum' => 'museum',
            'attraction' || 'viewpoint' => 'landmark',
            _ => 'landmark',
          },
        'leisure' => 'park',
        'shop' => 'market',
        'aeroway' => 'airport',
        'railway' || 'public_transport' => 'transport',
        _ => 'place',
      };
}
