import 'package:flutter/foundation.dart';

/// Immutable domain entity for a metro station.
/// Uses a stable, locale-independent [id] string (e.g. "sadat").
/// Display names are stored in both languages to avoid BuildContext coupling.
@immutable
class Station {
  final String id;
  final String nameEn;
  final String nameAr;
  final double latitude;
  final double longitude;
  final List<String> lineIds;
  final bool isTransfer;
  final bool isAccessible;
  final List<String> facilities;

  const Station({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.latitude,
    required this.longitude,
    required this.lineIds,
    this.isTransfer = false,
    this.isAccessible = false,
    this.facilities = const [],
  });

  /// Returns the display name for [languageCode] ('en' or 'ar').
  String localizedName(String languageCode) =>
      languageCode == 'ar' ? nameAr : nameEn;

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameAr: json['nameAr'] as String,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      lineIds: List<String>.from(json['lines'] as List),
      isTransfer: json['isTransfer'] as bool? ?? false,
      isAccessible: json['isAccessible'] as bool? ?? false,
      facilities: List<String>.from(json['facilities'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameEn': nameEn,
        'nameAr': nameAr,
        'lat': latitude,
        'lng': longitude,
        'lines': lineIds,
        'isTransfer': isTransfer,
        'isAccessible': isAccessible,
        'facilities': facilities,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Station && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Station($id: $nameEn)';
}
