import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/entities/route_result.dart';
import '../domain/entities/station.dart';
import '../domain/repositories/metro_repository.dart';
import '../l10n/app_localizations.dart';
import '../Controllers/routecontroller.dart' show getLineName;

/// Bridges [MetroRepository] (Dijkstra-based routing) to the legacy
/// [Map<String, dynamic>] format consumed by [RouteTimeline] and [Routepage].
///
/// Falls back to an empty result map if routing fails.
class RouteService {
  RouteService._();
  static final RouteService instance = RouteService._();

  // ── Line ID → old line-number mapping ───────────────────────────────────────
  // Old routecontroller used integers 1–7; we map the new IDs here.
  static int _lineIdToNumber(String lineId) => switch (lineId) {
        'L1' => 1,
        'L2' => 2,
        'L3' || 'L3A' => 3, // shared trunk + Rod El-Farag branch
        'L3B' => 4,          // Cairo University branch
        'LRT_MAIN' => 5,
        'LRT_BRANCH_NAC' => 6,
        'LRT_BRANCH_10TH' => 7,
        _ => 0,
      };

  // ── Public API ───────────────────────────────────────────────────────────────

  /// Find routes from [depName] to [arrName] (localized station names).
  ///
  /// Returns a map with:
  /// - `allRoutesDetails`: List<Map<String,dynamic>> for RouteTimeline
  /// - `serializedData`:   List<List<List<int>>> (empty — map view not yet wired)
  Future<Map<String, dynamic>> findRoutes(
    BuildContext context,
    String depName,
    String arrName,
    int sortValue, {
    bool preferAccessible = false,
  }) async {
    final empty = <Map<String, dynamic>>[];
    try {
      final repo = Get.find<MetroRepository>();
      final l10n = AppLocalizations.of(context)!;
      final lang = l10n.locale; // 'en' or 'ar'

      // ── 0. Pre-load all stations for sync name lookup ────────────────────
      final allStations = await repo.getAllStations();
      final stationMap = <String, Station>{
        for (final s in allStations) s.id: s,
      };

      // ── 1. Resolve station IDs from display names ────────────────────────
      final depStation = await _stationByName(repo, depName, lang);
      final arrStation = await _stationByName(repo, arrName, lang);

      if (depStation == null || arrStation == null) {
        return {'allRoutesDetails': empty, 'serializedData': []};
      }

      // ── 2. Run Dijkstra ──────────────────────────────────────────────────
      final results = await repo.findRoutes(
        depStation.id,
        arrStation.id,
        maxResults: 3,
        preferAccessible: preferAccessible,
      );

      if (results.isEmpty) {
        return {'allRoutesDetails': empty, 'serializedData': []};
      }

      // ── 3. Convert RouteResult → legacy Map format ───────────────────────
      final converted = <Map<String, dynamic>>[];
      final serialized = <List<List<int>>>[];

      for (final route in results) {
        final map = _toRouteMap(route, context, lang, stationMap);
        if (map != null) {
          converted.add(map);
          serialized.add([]); // placeholder — Stationspage will be wired later
        }
      }

      // ── 4. Apply sort ────────────────────────────────────────────────────
      if (sortValue == 1) {
        converted.sort((a, b) {
          final sa = int.tryParse(a['No. of stations']?.toString() ?? '') ?? 0;
          final sb = int.tryParse(b['No. of stations']?.toString() ?? '') ?? 0;
          final ra = int.tryParse(a['Route type']?.toString() ?? '') ?? 0;
          final rb = int.tryParse(b['Route type']?.toString() ?? '') ?? 0;
          final cmp = sa.compareTo(sb);
          return cmp != 0 ? cmp : ra.compareTo(rb);
        });
      }

      return {'allRoutesDetails': converted, 'serializedData': serialized};
    } catch (e) {
      debugPrint('[RouteService] Error: $e');
      return {'allRoutesDetails': empty, 'serializedData': []};
    }
  }

  // ── Station lookup ───────────────────────────────────────────────────────────

  Future<Station?> _stationByName(
      MetroRepository repo, String name, String lang) async {
    if (name.isEmpty) return null;
    final results = await repo.searchStations(name);
    if (results.isEmpty) return null;

    // Prefer exact match on the current locale name
    final exact = results.firstWhereOrNull(
      (s) => s.localizedName(lang).toLowerCase() == name.toLowerCase(),
    );
    return exact ?? results.first;
  }

  // ── RouteResult → legacy Map ─────────────────────────────────────────────────

  Map<String, dynamic>? _toRouteMap(
    RouteResult route,
    BuildContext context,
    String lang,
    Map<String, Station> stationMap,
  ) {
    final segs = route.segments;
    if (segs.isEmpty) return null;

    final totalStations = route.totalStations;
    final minutes = route.estimatedTime.inMinutes;
    final fare = route.fareEGP;
    final routeType = segs.length.clamp(1, 3);

    final base = <String, dynamic>{
      'Route type': routeType.toString(),
      'No. of stations': totalStations.toString(),
      'Estimated travel time': minutes.toString(),
      'Ticket Price': fare.toString(),
      // Private key used by timetable display — ignored by RouteTimeline.
      '_firstLineId': segs.first.lineId,
      '_allLineIds': segs.map((s) => s.lineId).toList(),
      '_sortType': route.sortType.name,
    };

    if (routeType == 1) {
      _fillSingleLine(base, segs.first, context, lang, stationMap);
    } else if (routeType == 2) {
      _fillTwoLine(base, segs[0], segs[1], context, lang, stationMap);
    } else {
      _fillThreeLine(base, segs[0], segs[1], segs[2], context, lang, stationMap);
    }

    return base;
  }

  // ── Segment formatters ───────────────────────────────────────────────────────

  void _fillSingleLine(
    Map<String, dynamic> map,
    RouteSegment seg,
    BuildContext context,
    String lang,
    Map<String, Station> stationMap,
  ) {
    final lineName = _resolveLineName(seg.lineId, context);
    final stationNames =
        seg.stationIds.map((id) => _nameFromId(id, lang, stationMap)).toList();

    map['Take'] = lineName;
    map['Departure'] = stationNames.isNotEmpty ? stationNames.first : '';
    map['Arrival'] = stationNames.isNotEmpty ? stationNames.last : '';
    map['Intermediate Stations'] = stationNames;
  }

  void _fillTwoLine(
    Map<String, dynamic> map,
    RouteSegment seg1,
    RouteSegment seg2,
    BuildContext context,
    String lang,
    Map<String, Station> stationMap,
  ) {
    final line1 = _resolveLineName(seg1.lineId, context);
    final line2 = _resolveLineName(seg2.lineId, context);
    final seg1Names =
        seg1.stationIds.map((id) => _nameFromId(id, lang, stationMap)).toList();
    final seg2Names =
        seg2.stationIds.map((id) => _nameFromId(id, lang, stationMap)).toList();
    final changeAt = seg1Names.isNotEmpty ? seg1Names.last : '';

    map['First take'] = line1;
    map['First Departure'] = seg1Names.isNotEmpty ? seg1Names.first : '';
    map['First Arrival'] = changeAt;
    map['First Intermediate Stations'] = seg1Names;
    map['You will change at'] = changeAt;
    map['Second take'] = line2;
    map['Second Departure'] = changeAt;
    map['Second Arrival'] = seg2Names.isNotEmpty ? seg2Names.last : '';
    map['Second Intermediate Stations'] = seg2Names;
  }

  void _fillThreeLine(
    Map<String, dynamic> map,
    RouteSegment seg1,
    RouteSegment seg2,
    RouteSegment seg3,
    BuildContext context,
    String lang,
    Map<String, Station> stationMap,
  ) {
    final line1 = _resolveLineName(seg1.lineId, context);
    final line2 = _resolveLineName(seg2.lineId, context);
    final line3 = _resolveLineName(seg3.lineId, context);
    final seg1Names =
        seg1.stationIds.map((id) => _nameFromId(id, lang, stationMap)).toList();
    final seg2Names =
        seg2.stationIds.map((id) => _nameFromId(id, lang, stationMap)).toList();
    final seg3Names =
        seg3.stationIds.map((id) => _nameFromId(id, lang, stationMap)).toList();

    map['First take'] = line1;
    map['First Departure'] = seg1Names.isNotEmpty ? seg1Names.first : '';
    map['First Arrival'] = seg1Names.isNotEmpty ? seg1Names.last : '';
    map['First Intermediate Stations'] = seg1Names;
    map['Second take'] = line2;
    map['Second Departure'] = seg2Names.isNotEmpty ? seg2Names.first : '';
    map['Second Arrival'] = seg2Names.isNotEmpty ? seg2Names.last : '';
    map['Second Intermediate Stations'] = seg2Names;
    map['Third take'] = line3;
    map['Third Departure'] = seg3Names.isNotEmpty ? seg3Names.first : '';
    map['Third Arrival'] = seg3Names.isNotEmpty ? seg3Names.last : '';
    map['Third Intermediate Stations'] = seg3Names;
  }

  // ── Name helpers ─────────────────────────────────────────────────────────────

  /// Resolve a localized line name using the same strings as the old controller
  /// so that [RouteTimeline]'s _resolveDirection works correctly.
  String _resolveLineName(String lineId, BuildContext context) {
    final num = _lineIdToNumber(lineId);
    if (num == 0) return lineId; // unknown line — use raw ID as fallback
    return getLineName(context, num);
  }

  /// Return the station's localized display name from the pre-loaded stationMap.
  String _nameFromId(String id, String lang, Map<String, Station> stationMap) {
    final station = stationMap[id];
    if (station != null) return station.localizedName(lang);
    // Fallback: format snake_case ID as title case
    return id.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}

