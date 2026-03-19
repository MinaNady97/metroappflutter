import 'dart:convert';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LandmarkResult — single match returned by LocalSearchService
// ─────────────────────────────────────────────────────────────────────────────

class LandmarkResult {
  final String name;
  final String nameAr;
  final double lat;
  final double lng;
  final String type;
  final double score;

  /// 'local' = bundled JSON, 'online' = Nominatim live result
  final String source;

  const LandmarkResult({
    required this.name,
    required this.nameAr,
    required this.lat,
    required this.lng,
    required this.type,
    required this.score,
    this.source = 'local',
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// LocalSearchService — singleton, loads once from bundled JSON asset
// ─────────────────────────────────────────────────────────────────────────────

class LocalSearchService {
  static final LocalSearchService _instance = LocalSearchService._();
  static LocalSearchService get instance => _instance;
  LocalSearchService._();

  List<Map<String, dynamic>> _landmarks = [];
  bool _loaded = false;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw =
          await rootBundle.loadString('assets/data/cairo_landmarks.json');
      final data = jsonDecode(raw) as List<dynamic>;
      _landmarks = data.cast<Map<String, dynamic>>();
      _loaded = true;
    } catch (_) {
      _landmarks = [];
      _loaded = true;
    }
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Returns up to [maxResults] landmarks ranked by relevance.
  /// Set [preferArabic] = true when the user is typing in Arabic so that
  /// Arabic names are scored first.
  List<LandmarkResult> search(
    String query, {
    int maxResults = 6,
    bool preferArabic = false,
  }) {
    if (!_loaded || query.trim().isEmpty) return [];

    // Arabic text is NOT lowercased — Unicode comparisons are case-irrelevant
    // for Arabic. English is lowercased for case-insensitive matching.
    final qAr = query.trim();
    final qEn = query.toLowerCase().trim();

    final results = <LandmarkResult>[];

    for (final l in _landmarks) {
      final nameEn = ((l['name'] as String?) ?? '').toLowerCase();
      final nameAr = (l['nameAr'] as String?) ?? '';
      final score = preferArabic
          ? _scoreArabic(qAr, qEn, nameAr, nameEn)
          : _scoreEnglish(qEn, qAr, nameEn, nameAr);

      if (score > 0) {
        results.add(LandmarkResult(
          name: (l['name'] as String?) ?? '',
          nameAr: nameAr,
          lat: (l['lat'] as num).toDouble(),
          lng: (l['lng'] as num).toDouble(),
          type: (l['type'] as String?) ?? 'place',
          score: score,
        ));
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(maxResults).toList();
  }

  /// Up to 3 fallback candidates for "Did You Mean?" on geocoding failure.
  List<LandmarkResult> didYouMean(String query, {bool preferArabic = false}) =>
      search(query, maxResults: 3, preferArabic: preferArabic);

  // ── Scoring ────────────────────────────────────────────────────────────────

  /// Arabic-first: rank Arabic name matches above English matches.
  double _scoreArabic(
      String qAr, String qEn, String nameAr, String nameEn) {
    if (nameAr.startsWith(qAr)) return 1.0;
    if (nameAr.contains(qAr)) return 0.80;
    // word-level Arabic
    final arWords = qAr.split(RegExp(r'\s+'));
    final arMatched =
        arWords.where((w) => w.isNotEmpty && nameAr.contains(w)).length;
    if (arMatched > 0) return arMatched / arWords.length * 0.65;
    // fallback to English
    if (nameEn.startsWith(qEn)) return 0.50;
    if (nameEn.contains(qEn)) return 0.40;
    return 0;
  }

  /// English-first: rank English name matches above Arabic matches.
  double _scoreEnglish(
      String qEn, String qAr, String nameEn, String nameAr) {
    if (nameEn.startsWith(qEn)) return 1.0;
    if (nameEn.contains(qEn)) return 0.75;
    if (nameAr.contains(qAr)) return 0.65;
    final words = qEn.split(RegExp(r'\s+'));
    final matched =
        words.where((w) => w.length > 1 && nameEn.contains(w)).length;
    if (matched > 0) return matched / words.length * 0.55;
    return 0;
  }

  // ── Utilities ──────────────────────────────────────────────────────────────

  /// True when [text] contains any Arabic Unicode character.
  static bool isArabic(String text) =>
      text.runes.any((r) => r >= 0x0600 && r <= 0x06FF);

  static String typeEmoji(String type) => switch (type) {
        'museum' => '🏛',
        'mosque' => '🕌',
        'church' => '⛪',
        'hotel' => '🏨',
        'mall' => '🛍',
        'university' => '🎓',
        'hospital' => '🏥',
        'airport' => '✈',
        'transport' => '🚉',
        'market' => '🛒',
        'park' => '🌳',
        'sports' => '🏟',
        'neighborhood' => '📍',
        'landmark' => '🗼',
        'square' => '⬛',
        'business' => '🏢',
        'government' => '🏛',
        _ => '📍',
      };
}
