import 'package:shared_preferences/shared_preferences.dart';

/// Persists recent and favorite routes to SharedPreferences.
///
/// Route pairs are stored as `"dep|||arr"` strings.
class FavoritesService {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  static const _favKey = 'fav_routes_v1';
  static const _recentKey = 'recent_routes_v1';
  static const String _sep = '|||';

  // ── Favorites ──────────────────────────────────────────────────────────────

  Future<List<({String dep, String arr})>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return _decode(prefs.getStringList(_favKey) ?? []);
  }

  Future<void> saveFavorites(List<({String dep, String arr})> routes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favKey, _encode(routes));
  }

  // ── Recent routes ──────────────────────────────────────────────────────────

  Future<List<({String dep, String arr})>> loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    return _decode(prefs.getStringList(_recentKey) ?? []);
  }

  Future<void> saveRecent(List<({String dep, String arr})> routes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentKey, _encode(routes));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<String> _encode(List<({String dep, String arr})> routes) =>
      routes.map((r) => '${r.dep}$_sep${r.arr}').toList();

  List<({String dep, String arr})> _decode(List<String> raw) => raw
      .map((s) {
        final idx = s.indexOf(_sep);
        if (idx < 0) return null;
        return (dep: s.substring(0, idx), arr: s.substring(idx + _sep.length));
      })
      .whereType<({String dep, String arr})>()
      .toList();
}
