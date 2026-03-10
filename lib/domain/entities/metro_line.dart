import 'package:flutter/material.dart';

@immutable
class MetroLine {
  final String id;
  final String nameEn;
  final String nameAr;
  final Color color;
  final List<String> stationIds; // Ordered from terminus A → terminus B
  final String terminusAId;
  final String terminusBId;

  const MetroLine({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.color,
    required this.stationIds,
    required this.terminusAId,
    required this.terminusBId,
  });

  String localizedName(String languageCode) =>
      languageCode == 'ar' ? nameAr : nameEn;

  factory MetroLine.fromJson(Map<String, dynamic> json) {
    final colorHex = json['color'] as String;
    return MetroLine(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameAr: json['nameAr'] as String,
      color: Color(int.parse(colorHex.replaceFirst('#', 'FF'), radix: 16)),
      stationIds: List<String>.from(json['stations'] as List),
      terminusAId: (json['stations'] as List).first as String,
      terminusBId: (json['stations'] as List).last as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is MetroLine && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MetroLine($id: $nameEn)';
}
