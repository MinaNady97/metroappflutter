import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/metro_line.dart';
import '../../domain/entities/station.dart';

/// Loads metro network data from the bundled JSON asset.
/// No BuildContext dependency — safe to call from any layer.
class MetroLocalDatasource {
  static const String _assetPath = 'assets/data/metro_network.json';

  Map<String, dynamic>? _rawJson;

  /// Loads and caches the JSON asset. Subsequent calls return the cached version.
  Future<Map<String, dynamic>> _load() async {
    _rawJson ??= jsonDecode(
      await rootBundle.loadString(_assetPath),
    ) as Map<String, dynamic>;
    return _rawJson!;
  }

  /// Returns all [Station] entities parsed from the JSON asset.
  Future<List<Station>> loadStations() async {
    final json = await _load();
    final list = json['stations'] as List;
    return list
        .map((s) => Station.fromJson(s as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// Returns all [MetroLine] entities parsed from the JSON asset.
  Future<List<MetroLine>> loadLines() async {
    final json = await _load();
    final list = json['lines'] as List;
    return list
        .map((l) => MetroLine.fromJson(l as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// Returns the data version string from the JSON asset.
  Future<String> getVersion() async {
    final json = await _load();
    return json['version'] as String? ?? '1.0';
  }

  /// Clears the in-memory cache (call after updating the asset at runtime).
  void clearCache() => _rawJson = null;
}
