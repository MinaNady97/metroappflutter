import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metroappflutter/domain/entities/metro_line.dart';
import 'package:metroappflutter/domain/entities/station.dart';
import 'package:metroappflutter/routing/dijkstra_engine.dart';
import 'package:metroappflutter/routing/fare_calculator.dart';
import 'package:metroappflutter/routing/metro_graph.dart';

/// Minimal synthetic metro network used in all tests:
///
///  L1: A ─── B ─── C ─── D
///  L2:           C ─── E ─── F
///
/// Transfer station: C (L1 + L2)
/// Expected routes:
///   A → F : go A→B→C (L1), transfer at C, C→E→F (L2)  — 4 hops
///   A → D : stay on L1, 3 hops
///   D → F : D→C (L1), transfer at C, C→E→F (L2)   — 4 hops
///   A → A : no route (same station)
final _testStations = {
  'a': const Station(id: 'a', nameEn: 'A', nameAr: 'أ', latitude: 0, longitude: 0, lineIds: ['L1']),
  'b': const Station(id: 'b', nameEn: 'B', nameAr: 'ب', latitude: 0, longitude: 0.01, lineIds: ['L1']),
  'c': const Station(id: 'c', nameEn: 'C', nameAr: 'ج', latitude: 0, longitude: 0.02, lineIds: ['L1', 'L2'], isTransfer: true),
  'd': const Station(id: 'd', nameEn: 'D', nameAr: 'د', latitude: 0, longitude: 0.03, lineIds: ['L1']),
  'e': const Station(id: 'e', nameEn: 'E', nameAr: 'هـ', latitude: 0.01, longitude: 0.02, lineIds: ['L2']),
  'f': const Station(id: 'f', nameEn: 'F', nameAr: 'و', latitude: 0.01, longitude: 0.03, lineIds: ['L2']),
};

final _testLines = [
  MetroLine(
    id: 'L1',
    nameEn: 'Line 1',
    nameAr: 'الخط الأول',
    color: const Color(0xFFAD1F52),
    stationIds: ['a', 'b', 'c', 'd'],
    terminusAId: 'a',
    terminusBId: 'd',
  ),
  MetroLine(
    id: 'L2',
    nameEn: 'Line 2',
    nameAr: 'الخط الثاني',
    color: const Color(0xFF029692),
    stationIds: ['c', 'e', 'f'],
    terminusAId: 'c',
    terminusBId: 'f',
  ),
];

DijkstraEngine _buildEngine() {
  final graph = MetroGraph();
  graph.build(_testLines, _testStations);
  return DijkstraEngine(
    graph: graph,
    stations: _testStations,
    lines: {for (final l in _testLines) l.id: l},
  );
}

void main() {
  group('MetroGraph', () {
    test('builds adjacency list for all stations', () {
      final graph = MetroGraph();
      graph.build(_testLines, _testStations);
      expect(graph.contains('a'), isTrue);
      expect(graph.contains('f'), isTrue);
      expect(graph.allStationIds.length, equals(6));
    });

    test('transfer station has edges to both lines', () {
      final graph = MetroGraph();
      graph.build(_testLines, _testStations);
      final neighbors = graph.neighbors('c');
      final lineIds = neighbors.map((e) => e.lineId).toSet();
      expect(lineIds, containsAll(['L1', 'L2']));
    });

    test('edges are bidirectional', () {
      final graph = MetroGraph();
      graph.build(_testLines, _testStations);
      final aNeighbors = graph.neighbors('a').map((e) => e.toStationId);
      final bNeighbors = graph.neighbors('b').map((e) => e.toStationId);
      expect(aNeighbors, contains('b'));
      expect(bNeighbors, contains('a'));
    });
  });

  group('DijkstraEngine', () {
    late DijkstraEngine engine;
    setUp(() => engine = _buildEngine());

    test('same station returns empty list', () {
      final routes = engine.findTopRoutes('a', 'a');
      expect(routes, isEmpty);
    });

    test('unknown station returns empty list', () {
      final routes = engine.findTopRoutes('a', 'zzz');
      expect(routes, isEmpty);
    });

    test('single-line route A → D has no transfers', () {
      final routes = engine.findTopRoutes('a', 'd');
      expect(routes, isNotEmpty);
      final best = routes.first;
      expect(best.transfers, equals(0));
      expect(best.totalStations, equals(3));
      expect(best.stationIds, equals(['a', 'b', 'c', 'd']));
    });

    test('cross-line route A → F has 1 transfer at C', () {
      final routes = engine.findTopRoutes('a', 'f');
      expect(routes, isNotEmpty);
      final best = routes.first;
      expect(best.transfers, equals(1));
      expect(best.stationIds.first, equals('a'));
      expect(best.stationIds.last, equals('f'));
      expect(best.transferStationIds, contains('c'));
    });

    test('reverse route F → A has 1 transfer', () {
      final routes = engine.findTopRoutes('f', 'a');
      expect(routes, isNotEmpty);
      expect(routes.first.transfers, equals(1));
    });

    test('route result has correct fare', () {
      final routes = engine.findTopRoutes('a', 'd');
      expect(routes.first.fareEGP, equals(FareCalculator.calculate(3)));
    });

    test('findTopRoutes returns at most maxResults routes', () {
      final routes = engine.findTopRoutes('a', 'f', maxResults: 2);
      expect(routes.length, lessThanOrEqualTo(2));
    });
  });

  group('FareCalculator', () {
    test('1-9 stations costs 8 EGP', () {
      for (int i = 1; i <= 9; i++) {
        expect(FareCalculator.calculate(i), equals(8), reason: '$i stations');
      }
    });

    test('10-16 stations costs 10 EGP', () {
      for (int i = 10; i <= 16; i++) {
        expect(FareCalculator.calculate(i), equals(10), reason: '$i stations');
      }
    });

    test('17-23 stations costs 15 EGP', () {
      for (int i = 17; i <= 23; i++) {
        expect(FareCalculator.calculate(i), equals(15), reason: '$i stations');
      }
    });

    test('24+ stations costs 20 EGP', () {
      expect(FareCalculator.calculate(24), equals(20));
      expect(FareCalculator.calculate(34), equals(20));
    });

    test('student discount is 50%', () {
      expect(FareCalculator.applyDiscount(20, UserType.student), equals(10));
    });

    test('senior discount is 50%', () {
      expect(FareCalculator.applyDiscount(20, UserType.senior), equals(10));
    });

    test('disabled fare is free', () {
      expect(FareCalculator.applyDiscount(20, UserType.disabled), equals(0));
    });

    test('regular fare has no discount', () {
      expect(FareCalculator.applyDiscount(20, UserType.regular), equals(20));
    });
  });
}
