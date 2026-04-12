import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' hide Path;

import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/data/cairo_geo_data.dart';
import 'package:metroappflutter/domain/entities/metro_line.dart';
import 'package:metroappflutter/domain/entities/station.dart';
import 'package:metroappflutter/domain/repositories/metro_repository.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/widgets/metro_map_painter.dart';
import 'package:metroappflutter/widgets/location_permission_dialog.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MetroMapPage — Interactive Cairo Metro + LRT Map  v4 (performance)
//
// Two-layer rendering:
//   Static  — lines, stations, labels, grid → cached via RepaintBoundary
//   Animated — train dots, selection ring, user location → lightweight
//
// Animations paused during pan/zoom for buttery-smooth interaction.
// Paths & train positions pre-computed once at load time.
// ─────────────────────────────────────────────────────────────────────────────

class MetroMapPage extends StatefulWidget {
  const MetroMapPage({super.key});
  @override
  State<MetroMapPage> createState() => _MetroMapPageState();
}

class _MetroMapPageState extends State<MetroMapPage>
    with TickerProviderStateMixin {
  final TransformationController _transform = TransformationController();

  // ── Animation controllers ──────────────────────────────────────────────
  late final AnimationController _legendCtrl;
  late final Animation<double> _legendAnim;
  late final AnimationController _resetBtnCtrl;
  late final Animation<double> _resetBtnAnim;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;
  late final AnimationController _trainCtrl;
  late final AnimationController _entranceCtrl;
  late final Animation<double> _entranceAnim;
  late final AnimationController _userLocPulseCtrl;

  // ── State ──────────────────────────────────────────────────────────────
  double _scale = 1.0;
  bool _legendVisible = true;
  bool _loading = true;

  List<MetroLine> _lines = [];
  Map<String, Station> _stationMap = {};

  String? _selectedStationId;
  final Set<String> _visibleLineIds = {'L1', 'L2', 'L3', 'LRT'};

  bool _searchOpen = false;
  final _searchCtrl = TextEditingController();
  List<Station> _searchResults = [];

  // User location
  Offset? _userLocationCanvas;
  Position? _userGpsPosition;
  bool _locationLoading = false;

  // Interaction tracking — skip setState during pan/zoom
  bool _isInteracting = false;

  // Label visibility — hidden during gestures so the GPU display-list has no
  // text ops, then revealed 200 ms after the gesture settles (debounced so
  // quick successive pinches don't cause flicker).
  final _labelsHidden = ValueNotifier<bool>(false);
  Timer? _labelRevealTimer;

  // ── Map mode toggle ─────────────────────────────────────────────────
  bool _mapMode = false;
  bool _mapCameraReady = false;

  // ── Current theme palette (updated in build()) ──────────────────────
  _Palette _palette = const _Palette.dark();
  MapCamera? _liveMapCamera;
  final MapController _flutterMapCtrl = MapController();
  double _mapZoom = 11.0;

  // ── Pre-computed caches (built once) ───────────────────────────────────
  MapBounds? _bounds;
  Map<String, Offset> _stationPositions = {};
  Map<String, Path> _linePaths = {};
  Map<String, List<Offset>> _trainSamples = {};

  // Nile + districts (projected to canvas coords)
  List<Offset> _nileMainProjected = [];
  List<Offset> _nileWestProjected = [];
  List<List<Offset>> _islandPathsProjected = [];
  List<({Offset pos, String name})> _districtLabels = [];

  static const _min = 0.1;
  static const _max = 10.0;
  static const _step = 1.40;

  @override
  void initState() {
    super.initState();
    _transform.addListener(_onTransformChanged);

    _legendCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280), value: 1);
    _legendAnim = CurvedAnimation(parent: _legendCtrl, curve: Curves.easeOut);

    _resetBtnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220), value: 0);
    _resetBtnAnim =
        CurvedAnimation(parent: _resetBtnCtrl, curve: Curves.easeOut);

    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);

    _trainCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 14));
    // Don't start train until entrance finishes

    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _entranceAnim =
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic);

    _entranceCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _trainCtrl.repeat(); // start trains only after entrance
      }
    });

    _userLocPulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    // Don't start until user location is available

    _searchCtrl.addListener(_onSearchChanged);
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = Get.find<MetroRepository>();
    final stations = await repo.getAllStations();
    final lines = await repo.getAllLines();
    if (!mounted) return;

    // Pre-compute everything once
    final bounds = MapBounds.fromStations(stations);
    final positions = <String, Offset>{};
    for (final s in stations) {
      positions[s.id] = bounds.project(s.latitude, s.longitude);
    }

    final paths = <String, Path>{};
    final samples = <String, List<Offset>>{};
    for (final line in lines) {
      final path = buildLinePath(line, positions);
      if (path != null) {
        paths[line.id] = path;
        samples[line.id] = samplePathPositions(path);
      }
    }

    // Project Nile + districts onto canvas
    List<Offset> projectList(List<(double, double)> pts) =>
        pts.map((p) => bounds.project(p.$1, p.$2)).toList();

    final lang = mounted ? Localizations.localeOf(context).languageCode : 'en';
    final distLabels = CairoGeoData.districts.map((d) {
      final name = lang == 'ar' ? d.$2 : d.$1;
      return (pos: bounds.project(d.$3, d.$4), name: name);
    }).toList();

    setState(() {
      _stationMap = {for (final s in stations) s.id: s};
      _lines = lines;
      _bounds = bounds;
      _stationPositions = positions;
      _linePaths = paths;
      _trainSamples = samples;
      _nileMainProjected = projectList(CairoGeoData.nileMain);
      _nileWestProjected = projectList(CairoGeoData.nileWest);
      _islandPathsProjected = [
        projectList(CairoGeoData.geziraIsland),
        projectList(CairoGeoData.rodaIsland),
      ];
      _districtLabels = distLabels;
      _loading = false;
    });

    _entranceCtrl.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitAllStations();
      if (_mapMode) _syncMapCameraToBounds();
    });
  }

  @override
  void dispose() {
    _transform
      ..removeListener(_onTransformChanged)
      ..dispose();
    _flutterMapCtrl.dispose();
    _legendCtrl.dispose();
    _resetBtnCtrl.dispose();
    _pulseCtrl.dispose();
    _trainCtrl.dispose();
    _entranceCtrl.dispose();
    _userLocPulseCtrl.dispose();
    _searchCtrl.dispose();
    _labelRevealTimer?.cancel();
    _labelsHidden.dispose();
    super.dispose();
  }

  // ── Fit all stations ───────────────────────────────────────────────────

  void _fitAllStations() {
    if (_bounds == null) return;
    final sz = MediaQuery.of(context).size;
    final cs = _bounds!.size;
    final scaleX = sz.width / cs.width;
    final scaleY = (sz.height - 200) / cs.height;
    final fitScale = (scaleX < scaleY ? scaleX : scaleY) * 0.92;
    final tx = (sz.width - cs.width * fitScale) / 2;
    final ty = (sz.height - cs.height * fitScale) / 2;
    _transform.value = Matrix4.identity()
      ..translate(tx, ty)
      ..scale(fitScale);
  }

  double _computeFitScale() {
    final b = _bounds;
    if (b == null) return 1.0;
    final sz = MediaQuery.of(context).size;
    final cs = b.size;
    final scaleX = sz.width / cs.width;
    final scaleY = (sz.height - 200) / cs.height;
    return (scaleX < scaleY ? scaleX : scaleY) * 0.92;
  }

  double _computeBaseMapZoom() {
    final b = _bounds;
    if (b == null) return 11.0;
    final lngSpan = (b.maxLng - b.minLng);
    final totalLngSpan =
        lngSpan * b.canvasW / (b.canvasW - 2 * MapBounds.padding);
    final fitZoom =
        math.log(b.canvasW * 360.0 / (256.0 * totalLngSpan)) / math.ln2;
    return fitZoom * 0.88;
  }

  LatLng _sceneToLatLng(Offset scene) {
    final b = _bounds!;
    // Do NOT clamp: clamping causes large jumps when user pans beyond bounds.
    final nx =
        (scene.dx - MapBounds.padding) / (b.canvasW - 2 * MapBounds.padding);
    final ny =
        (scene.dy - MapBounds.padding) / (b.canvasH - 2 * MapBounds.padding);
    final lng = b.minLng + nx * (b.maxLng - b.minLng);
    final lat = b.maxLat - ny * (b.maxLat - b.minLat);
    return LatLng(lat, lng);
  }

  void _syncMapFromSchematicView() {
    if (!_mapCameraReady || _bounds == null) return;
    final sz = MediaQuery.of(context).size;
    final viewCenter = Offset(sz.width / 2, sz.height / 2);
    final sceneCenter = _transform.toScene(viewCenter);
    final center = _sceneToLatLng(sceneCenter);

    final fitScale = _computeFitScale();
    final baseZoom = _computeBaseMapZoom();
    final ratio = (_scale / fitScale).clamp(0.25, 16.0);
    final targetZoom = (baseZoom + math.log(ratio) / math.ln2).clamp(9.0, 18.0);

    _flutterMapCtrl.move(center, targetZoom);
    setState(() => _mapZoom = targetZoom);
  }

  void _syncSchematicFromMapView() {
    if (!_mapCameraReady || _bounds == null) return;
    final cam = _liveMapCamera ?? _flutterMapCtrl.camera;
    final centerScene =
        _bounds!.project(cam.center.latitude, cam.center.longitude);

    final fitScale = _computeFitScale();
    final baseZoom = _computeBaseMapZoom();
    final targetScale = (fitScale * math.pow(2.0, cam.zoom - baseZoom))
        .clamp(_min, _max)
        .toDouble();

    final sz = MediaQuery.of(context).size;
    final vc = Offset(sz.width / 2, sz.height / 2);
    _transform.value = Matrix4.identity()
      ..translate(vc.dx, vc.dy)
      ..scale(targetScale)
      ..translate(-centerScene.dx, -centerScene.dy);
  }

  // ── Zoom ───────────────────────────────────────────────────────────────

  void _onTransformChanged() {
    final s = _transform.value.getMaxScaleOnAxis();
    if ((s - _scale).abs() < 0.01) return;
    _scale = s;
    s > 0.35 ? _resetBtnCtrl.forward() : _resetBtnCtrl.reverse();
    // Don't rebuild widget tree during active pinch/pan — zero lag
    if (!_isInteracting) setState(() {});
  }

  void _zoomStep(double factor) {
    HapticFeedback.lightImpact();
    final newScale = (_scale * factor).clamp(_min, _max);
    if (newScale == _scale) return;
    final ratio = newScale / _scale;
    final sz = MediaQuery.of(context).size;
    final vc = Offset(sz.width / 2, sz.height / 2);
    final sc = _transform.toScene(vc);
    _transform.value = Matrix4.copy(_transform.value)
      ..translate(sc.dx, sc.dy)
      ..scale(ratio)
      ..translate(-sc.dx, -sc.dy);
  }

  void _resetView() {
    HapticFeedback.mediumImpact();
    _fitAllStations();
  }

  void _toggleLegend() {
    HapticFeedback.selectionClick();
    setState(() => _legendVisible = !_legendVisible);
    _legendVisible ? _legendCtrl.forward() : _legendCtrl.reverse();
  }

  // ── Zoom to station ───────────────────────────────────────────────────

  void _zoomToStation(String stationId) {
    final pos = _stationPositions[stationId];
    if (pos == null) return;
    const targetScale = 3.0;
    final sz = MediaQuery.of(context).size;
    final vc = Offset(sz.width / 2, sz.height / 2);
    _transform.value = Matrix4.identity()
      ..translate(vc.dx, vc.dy)
      ..scale(targetScale)
      ..translate(-pos.dx, -pos.dy);
  }

  // ── Interaction pause/resume ──────────────────────────────────────────

  void _onInteractionStart(ScaleStartDetails details) {
    _isInteracting = true;
    _trainCtrl.stop();
    _userLocPulseCtrl.stop();
    _pulseCtrl.stop();
    // Hide labels only for pinch-zoom (2+ fingers), not for single-finger pan.
    // onInteractionStart re-fires when pointer count changes mid-gesture,
    // so adding a second finger while panning is also caught here.
    if (details.pointerCount >= 2) {
      _labelRevealTimer?.cancel();
      _labelsHidden.value = true;
    }
  }

  void _onInteractionEnd(ScaleEndDetails _) {
    _isInteracting = false;
    setState(() {}); // update zoom display once
    if (_entranceAnim.value >= 1.0) _trainCtrl.repeat();
    if (_userLocationCanvas != null) _userLocPulseCtrl.repeat();
    if (_selectedStationId != null) _pulseCtrl.repeat();
    // Reveal labels after a short settle — debounced so quick successive
    // pinches don't cause a flicker repaint on every gesture end.
    _labelRevealTimer?.cancel();
    _labelRevealTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) _labelsHidden.value = false;
    });
  }

  // ── Tap ───────────────────────────────────────────────────────────────

  void _onTapUp(TapUpDetails details) {
    if (_stationPositions.isEmpty) return;
    final scene = _transform.toScene(details.localPosition);
    final hit = _findStation(scene);

    if (hit != null) {
      HapticFeedback.lightImpact();
      setState(() => _selectedStationId = hit.id);
      _pulseCtrl
        ..reset()
        ..repeat();
      _showStationSheet(hit);
    } else if (_selectedStationId != null) {
      setState(() => _selectedStationId = null);
      _pulseCtrl.stop();
    }
  }

  void _onDoubleTapDown(TapDownDetails details) {
    if (_stationPositions.isEmpty) return;
    final scene = _transform.toScene(details.localPosition);
    final hit = _findStation(scene, radius: 35);
    if (hit != null) {
      HapticFeedback.mediumImpact();
      _zoomToStation(hit.id);
      setState(() => _selectedStationId = hit.id);
      _pulseCtrl
        ..reset()
        ..repeat();
      _showStationSheet(hit);
    }
  }

  Station? _findStation(Offset scenePoint, {double radius = 25}) {
    Station? nearest;
    double minDist = double.infinity;
    final r = radius / _scale;
    for (final entry in _stationPositions.entries) {
      final s = _stationMap[entry.key];
      if (s == null || !_isStationVisible(s)) continue;
      final d = (entry.value - scenePoint).distance;
      if (d < minDist && d < r) {
        minDist = d;
        nearest = s;
      }
    }
    return nearest;
  }

  void _onMapTap(TapPosition _, LatLng point) {
    Station? nearest;
    double minDist = double.infinity;
    for (final s in _stationMap.values) {
      if (!_isStationVisible(s)) continue;
      final dLat = point.latitude - s.latitude;
      final dLng = point.longitude - s.longitude;
      final d = math.sqrt(dLat * dLat + dLng * dLng);
      if (d < minDist) {
        minDist = d;
        nearest = s;
      }
    }
    // ~500m threshold (0.005 deg) so random taps don't select far stations
    if (nearest != null && minDist < 0.005) {
      HapticFeedback.lightImpact();
      setState(() => _selectedStationId = nearest!.id);
      _pulseCtrl
        ..reset()
        ..repeat();
      _showStationSheet(nearest);
    } else if (_selectedStationId != null) {
      setState(() => _selectedStationId = null);
      _pulseCtrl.stop();
    }
  }

  bool _isStationVisible(Station s) {
    return s.lineIds.any((lid) {
      if (lid.startsWith('LRT')) return _visibleLineIds.contains('LRT');
      if (lid == 'L3A' || lid == 'L3B') {
        return _visibleLineIds.contains('L3');
      }
      return _visibleLineIds.contains(lid);
    });
  }

  // ── Map mode toggle ────────────────────────────────────────────────

  void _toggleMapMode() {
    HapticFeedback.mediumImpact();
    if (_mapMode) {
      // Map -> schematic: preserve current center/zoom.
      _syncSchematicFromMapView();
      setState(() => _mapMode = false);
    } else {
      // Schematic -> map: preserve current center/zoom.
      setState(() => _mapMode = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_mapCameraReady) _syncMapFromSchematicView();
      });
    }
  }

  void _syncMapCameraToBounds() {
    if (!_mapCameraReady) return;
    final b = _bounds;
    if (b == null) return;

    final centerLat = (b.minLat + b.maxLat) / 2;
    final centerLng = (b.minLng + b.maxLng) / 2;

    final lngSpan = (b.maxLng - b.minLng);
    final totalLngSpan =
        lngSpan * b.canvasW / (b.canvasW - 2 * MapBounds.padding);
    final fitZoom =
        math.log(b.canvasW * 360.0 / (256.0 * totalLngSpan)) / math.ln2;

    final targetZoom = fitZoom * 0.88;
    _flutterMapCtrl.move(LatLng(centerLat, centerLng), targetZoom);
    setState(() => _mapZoom = targetZoom);
  }

  // ── User location ────────────────────────────────────────────────────

  Future<void> _fetchUserLocation() async {
    if (_locationLoading) return;
    setState(() => _locationLoading = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationLoading = false);
        if (!mounted) return;
        final enabled = await requestLocationServiceNative();
        if (enabled && mounted) {
          // Service just turned on — retry the whole fetch
          _fetchUserLocation();
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _locationLoading = false);
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            await showLocationDialog(
              context,
              type: LocationDialogType.permissionDenied,
              noThanksLabel: l10n.locationDialogNoThanks,
              openSettingsLabel: l10n.locationDialogOpenSettings,
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationLoading = false);
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          await showLocationDialog(
            context,
            type: LocationDialogType.permissionPermanentlyDenied,
            noThanksLabel: l10n.locationDialogNoThanks,
            openSettingsLabel: l10n.locationDialogOpenSettings,
          );
        }
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      setState(() {
        _userGpsPosition = pos;
        _locationLoading = false;
      });
      _updateUserCanvasPosition();
      if (_mapMode) {
        _flutterMapCtrl.move(LatLng(pos.latitude, pos.longitude), 14.0);
        setState(() => _mapZoom = 14.0);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _locationLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.locationError),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ));
      }
    }
  }

  void _updateUserCanvasPosition() {
    if (_userGpsPosition == null || _bounds == null) return;
    setState(() {
      _userLocationCanvas = _bounds!.project(
        _userGpsPosition!.latitude,
        _userGpsPosition!.longitude,
      );
    });
    if (!_userLocPulseCtrl.isAnimating) {
      _userLocPulseCtrl.repeat();
    }
  }

  // ── Search ────────────────────────────────────────────────────────────

  void _onSearchChanged() {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() {
      _searchResults = _stationMap.values
          .where(
              (s) => s.nameEn.toLowerCase().contains(q) || s.nameAr.contains(q))
          .take(6)
          .toList();
    });
  }

  void _selectSearchResult(Station station) {
    _searchCtrl.clear();
    setState(() {
      _searchOpen = false;
      _searchResults = [];
      _selectedStationId = station.id;
    });
    _pulseCtrl
      ..reset()
      ..repeat();

    for (final lid in station.lineIds) {
      if (lid.startsWith('LRT')) {
        _visibleLineIds.add('LRT');
      } else if (lid == 'L3A' || lid == 'L3B') {
        _visibleLineIds.add('L3');
      } else {
        _visibleLineIds.add(lid);
      }
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      _zoomToStation(station.id);
      _showStationSheet(station);
    });
  }

  // ── Line filter ───────────────────────────────────────────────────────

  void _toggleLine(String visKey) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_visibleLineIds.contains(visKey)) {
        if (_visibleLineIds.length > 1) _visibleLineIds.remove(visKey);
      } else {
        _visibleLineIds.add(visKey);
      }
    });
  }

  // ── Station sheet ─────────────────────────────────────────────────────

  void _showStationSheet(Station station) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    final adjacent = <Station>[];
    for (final line in _lines) {
      final idx = line.stationIds.indexOf(station.id);
      if (idx == -1) continue;
      if (idx > 0) {
        final s = _stationMap[line.stationIds[idx - 1]];
        if (s != null && !adjacent.contains(s)) adjacent.add(s);
      }
      if (idx < line.stationIds.length - 1) {
        final s = _stationMap[line.stationIds[idx + 1]];
        if (s != null && !adjacent.contains(s)) adjacent.add(s);
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _StationInfoSheet(
        station: station,
        lines: _lines,
        adjacentStations: adjacent,
        languageCode: lang,
        l10n: l10n,
        bottomPadding: bottomPad,
        onClose: () {
          Navigator.pop(context);
          setState(() => _selectedStationId = null);
          _pulseCtrl.stop();
        },
        onAdjacentTap: (s) {
          Navigator.pop(context);
          setState(() => _selectedStationId = s.id);
          _pulseCtrl
            ..reset()
            ..repeat();
          _zoomToStation(s.id);
          Future.delayed(
              const Duration(milliseconds: 200), () => _showStationSheet(s));
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    // Recompute palette whenever theme changes.
    _palette = Theme.of(context).brightness == Brightness.dark
        ? const _Palette.dark()
        : const _Palette.light();

    final l10n = AppLocalizations.of(context)!;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final topPad = MediaQuery.of(context).padding.top;
    final legendH = _legendVisible ? (108.0 + bottomPad) : 0.0;
    final lang = Localizations.localeOf(context).languageCode;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _palette.systemOverlay,
      child: Scaffold(
        backgroundColor: _palette.background,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(l10n),
        body: Stack(
          children: [
            // ── Map ──────────────────────────────────────────────
            if (_loading)
              const Center(
                  child: CircularProgressIndicator(color: Colors.white))
            else
              Positioned.fill(
                child: _mapMode
                    ? _buildGeographicOverlayMap(lang)
                    : _buildSchematicMap(lang),
              ),

            // ── Vignette ─────────────────────────────────────────
            if (!_loading && !_mapMode)
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _palette.vignette1,
                          Colors.transparent,
                          Colors.transparent,
                          _palette.vignette4,
                        ],
                        stops: const [0.0, 0.12, 0.80, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

            // ── Search overlay ──────────────────────────────────
            if (_searchOpen) _buildSearchOverlay(topPad, lang),

            // ── Hint chip ───────────────────────────────────────
            if (!_loading &&
                _selectedStationId == null &&
                !_searchOpen &&
                !_mapMode)
              Positioned(
                left: 0,
                right: 0,
                top: topPad + 72,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _scale < 0.8 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _palette.hintChipBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _palette.hintChipBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app_rounded,
                              color: _palette.hintText, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            lang == 'ar'
                                ? 'اضغط على محطة · انقر مرتين للتكبير'
                                : 'Tap station · Double-tap to zoom',
                            style: TextStyle(
                              color: _palette.hintText,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ── Location button ─────────────────────────────────
            Positioned(
              left: 16,
              bottom: legendH + 70,
              child: _locationButton(),
            ),

            // ── Station count ───────────────────────────────────
            if (!_loading && !_searchOpen)
              Positioned(
                left: 16,
                bottom: legendH + 16,
                child: _stationCountBadge(),
              ),

            // ── Zoom controls ───────────────────────────────────
            Positioned(
              right: 16,
              bottom: legendH + 16,
              child: _buildZoomControls(),
            ),

            // ── Legend ───────────────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildLegend(l10n, bottomPad),
            ),
          ],
        ),
      ),
    );
  }

  // ── Schematic map (CustomPaint) ─────────────────────────────────────

  Widget _buildSchematicMap(String lang) {
    return GestureDetector(
      onTapUp: _onTapUp,
      onDoubleTapDown: _onDoubleTapDown,
      onDoubleTap: () {},
      child: InteractiveViewer(
        transformationController: _transform,
        minScale: _min,
        maxScale: _max,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        onInteractionStart: _onInteractionStart,
        onInteractionEnd: _onInteractionEnd,
        child: SizedBox(
          width: _bounds!.size.width,
          height: _bounds!.size.height,
          child: Stack(
            children: [
              // Static layer (cached via RepaintBoundary)
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: Listenable.merge([_entranceAnim, _labelsHidden]),
                  builder: (_, __) => CustomPaint(
                    isComplex: true,
                    willChange: false,
                    size: _bounds!.size,
                    painter: MetroMapPainter(
                      lines: _lines,
                      stationMap: _stationMap,
                      stationPositions: _stationPositions,
                      linePaths: _linePaths,
                      languageCode: lang,
                      visibleLineIds: Set<String>.from(_visibleLineIds),
                      entranceProgress: _entranceAnim.value,
                      canvasSize: _bounds!.size,
                      scale: _scale,
                      hideLabels: _labelsHidden.value,
                      isDark: _palette.isDark,
                      labelColor: _palette.labelColor,
                      labelBgColor: _palette.labelBgColor,
                      nileMainPath: _nileMainProjected,
                      nileWestPath: _nileWestProjected,
                      islandPaths: _islandPathsProjected,
                      districtLabels: _districtLabels,
                    ),
                  ),
                ),
              ),
              // Animated layer (lightweight)
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _trainCtrl,
                    _pulseAnim,
                    _userLocPulseCtrl,
                  ]),
                  builder: (_, __) {
                    final selId = _selectedStationId;
                    return CustomPaint(
                      size: _bounds!.size,
                      painter: MetroMapAnimPainter(
                        trainProgress: _trainCtrl.value,
                        trainSamples: _trainSamples,
                        lines: _lines,
                        visibleLineIds: _visibleLineIds,
                        selectedStationId: selId,
                        selectedStationPos:
                            selId != null ? _stationPositions[selId] : null,
                        selectedStationColor:
                            selId != null && _stationMap[selId] != null
                                ? stationThemeColor(_stationMap[selId]!)
                                : null,
                        selectionAnimValue: _pulseAnim.value,
                        userLocation: _userLocationCanvas,
                        userLocPulse: _userLocPulseCtrl.value,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeographicOverlayMap(String lang) {
    if (!_mapCameraReady) {
      return Stack(
        children: [
          Positioned.fill(child: _buildTileBackground()),
          const Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final camera = _liveMapCamera ?? _flutterMapCtrl.camera;

    // Project stations from geo coords into current map screen-space.
    final geoPositions = <String, Offset>{
      for (final s in _stationMap.values)
        s.id: _projectWithMapCamera(camera, s.latitude, s.longitude),
    };

    // Rebuild paths/samples against current map projection.
    final geoLinePaths = <String, Path>{};
    final geoTrainSamples = <String, List<Offset>>{};
    for (final line in _lines) {
      final p = buildLinePath(line, geoPositions);
      if (p != null) {
        geoLinePaths[line.id] = p;
        geoTrainSamples[line.id] = samplePathPositions(p);
      }
    }

    final userLoc = _userGpsPosition == null
        ? null
        : _projectWithMapCamera(
            camera,
            _userGpsPosition!.latitude,
            _userGpsPosition!.longitude,
          );

    final mapVisualScale = ((_mapZoom - 9.5) / 5.0).clamp(0.2, 1.2);
    final mapSymbolScale = mapVisualScale.clamp(0.72, 1.0);

    return Stack(
      children: [
        Positioned.fill(child: _buildTileBackground()),
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: Listenable.merge([_entranceAnim, _labelsHidden]),
                builder: (_, __) => CustomPaint(
                  isComplex: true,
                  willChange: false,
                  size: MediaQuery.of(context).size,
                  painter: MetroMapPainter(
                    lines: _lines,
                    stationMap: _stationMap,
                    stationPositions: geoPositions,
                    linePaths: geoLinePaths,
                    languageCode: lang,
                    visibleLineIds: Set<String>.from(_visibleLineIds),
                    entranceProgress: _entranceAnim.value,
                    canvasSize: MediaQuery.of(context).size,
                    // Geo mode needs stronger de-cluttering at low zoom.
                    scale: mapVisualScale,
                    hideLabels: _labelsHidden.value || _mapZoom < 9.9,
                    adaptiveDensity: true,
                    isDark: _palette.isDark,
                    labelColor: _palette.labelColor,
                    labelBgColor: _palette.labelBgColor,
                    nileMainPath: const [],
                    nileWestPath: const [],
                    islandPaths: const [],
                    districtLabels: const [],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _trainCtrl,
                  _pulseAnim,
                  _userLocPulseCtrl,
                ]),
                builder: (_, __) {
                  final selId = _selectedStationId;
                  return CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: MetroMapAnimPainter(
                      trainProgress: _trainCtrl.value,
                      trainSamples: geoTrainSamples,
                      lines: _lines,
                      visibleLineIds: _visibleLineIds,
                      selectedStationId: selId,
                      selectedStationPos:
                          selId != null ? geoPositions[selId] : null,
                      selectedStationColor:
                          selId != null && _stationMap[selId] != null
                              ? stationThemeColor(_stationMap[selId]!)
                              : null,
                      selectionAnimValue: _pulseAnim.value,
                      userLocation: userLoc,
                      userLocPulse: _userLocPulseCtrl.value,
                      symbolScale: mapSymbolScale,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Offset _projectWithMapCamera(MapCamera camera, double lat, double lng) {
    return camera.latLngToScreenOffset(LatLng(lat, lng));
  }

  // ── Tile background (map mode) ────────────────────────────────────────
  //
  // Lives INSIDE InteractiveViewer so it shares the same transformation
  // matrix as the painter.  Both layers pan/zoom as one unit — they can
  // never drift apart.
  //
  // Zoom alignment:
  //   The canvas covers `totalLngSpan` degrees across `canvasW` pixels.
  //   FlutterMap at zoom Z has (256 × 2^Z) / 360 px per degree longitude.
  //   Equating gives:  Z = log₂(canvasW × 360 / (256 × totalLngSpan))
  //
  // Projection note:
  //   The schematic uses equirectangular projection; OSM tiles use Web
  //   Mercator.  For Cairo's latitude (~30 °N) the vertical distortion is
  //   ~1.5 %, which is imperceptible at any practical zoom level.  The
  //   schematic geometry is completely unchanged.

  Widget _buildTileBackground() {
    final b = _bounds!;

    // Geographic center of bounds
    final centerLat = (b.minLat + b.maxLat) / 2;
    final centerLng = (b.minLng + b.maxLng) / 2;

    // Longitude span corrected for canvas padding
    final lngSpan = (b.maxLng - b.minLng);
    final totalLngSpan =
        lngSpan * b.canvasW / (b.canvasW - 2 * MapBounds.padding);

    // Compute zoom that matches the schematic canvas width
    final zoom =
        math.log(b.canvasW * 360.0 / (256.0 * totalLngSpan)) / math.ln2;

    return FlutterMap(
      mapController: _flutterMapCtrl,
      options: MapOptions(
        initialCenter: LatLng(centerLat, centerLng),
        // Slightly wider framing to cover whole network footprint
        initialZoom: 10,
        minZoom: 10,
        backgroundColor: Colors.transparent,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onMapReady: () {
          if (!_mapCameraReady) {
            setState(() {
              _mapCameraReady = true;
              _liveMapCamera = _flutterMapCtrl.camera;
            });
            if (_mapMode) _syncMapFromSchematicView();
          }
        },
        onTap: _onMapTap,
        onPositionChanged: (pos, _) {
          setState(() {
            _liveMapCamera = pos;
            _mapZoom = pos.zoom;
          });
        },
      ),
      children: [
        TileLayer(
          urlTemplate: _palette.tileUrl,
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.metroappflutter',
          maxZoom: 19,
          // Dark mode: slight desaturation so metro overlays pop.
          // Light mode: voyager tiles look best without any filter.
          tileBuilder: _palette.isDark
              ? (context, tileWidget, tile) => ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      0.85, 0, 0, 0, 0,
                      0, 0.85, 0, 0, 0,
                      0, 0, 0.90, 0, 0,
                      0, 0, 0, 1, 0,
                    ]),
                    child: tileWidget,
                  )
              : null,
        ),
      ],
    );
  }

  // ── Location button ───────────────────────────────────────────────────

  Widget _locationButton() {
    final hasLoc = _userLocationCanvas != null;
    return Material(
      color: hasLoc ? const Color(0x404285F4) : _palette.controlBg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: _locationLoading ? null : _fetchUserLocation,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasLoc
                  ? const Color(0x664285F4)
                  : _palette.controlBorder,
            ),
          ),
          child: _locationLoading
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: _palette.iconPrimary))
              : Icon(
                  hasLoc
                      ? Icons.my_location_rounded
                      : Icons.location_searching_rounded,
                  color: hasLoc
                      ? const Color(0xFF4285F4)
                      : _palette.iconSecondary,
                  size: 20),
        ),
      ),
    );
  }

  // ── Station count ─────────────────────────────────────────────────────

  Widget _stationCountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _palette.controlBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _palette.controlBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.train_rounded, color: _palette.iconSecondary, size: 14),
          const SizedBox(width: 6),
          Text('${_stationMap.length}',
              style: TextStyle(
                  color: _palette.stationCountText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 3),
          Text('stations',
              style: TextStyle(
                  color: _palette.textTertiary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // ── Search overlay ────────────────────────────────────────────────────

  Widget _buildSearchOverlay(double topPad, String lang) {
    return Positioned(
      left: 12,
      right: 12,
      top: topPad + 64,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _palette.overlayBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _palette.overlayBorder),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              style: TextStyle(color: _palette.searchText, fontSize: 15),
              decoration: InputDecoration(
                hintText:
                    lang == 'ar' ? 'ابحث عن محطة...' : 'Search stations...',
                hintStyle:
                    TextStyle(color: _palette.searchHint, fontSize: 15),
                prefixIcon:
                    Icon(Icons.search_rounded, color: _palette.searchIcon),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: _palette.searchIcon, size: 20),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() {
                      _searchOpen = false;
                      _searchResults = [];
                    });
                  },
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          if (_searchResults.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: _palette.overlayBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _palette.overlayBorder),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _searchResults.map((s) {
                  final c = _colorForStation(s);
                  return ListTile(
                    dense: true,
                    leading: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Color.fromRGBO(c.red, c.green, c.blue, 0.5),
                              blurRadius: 4)
                        ],
                      ),
                    ),
                    title: Text(s.localizedName(lang),
                        style: TextStyle(
                            color: _palette.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(lang == 'ar' ? s.nameEn : s.nameAr,
                        style: TextStyle(
                            color: _palette.textTertiary, fontSize: 11)),
                    trailing: s.isTransfer
                        ? const Icon(Icons.swap_horiz_rounded,
                            color: Color(0x99FFC107), size: 16)
                        : null,
                    onTap: () => _selectSearchResult(s),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _colorForStation(Station s) {
    for (final lid in s.lineIds) {
      switch (lid) {
        case 'L1':
          return AppTheme.line1;
        case 'L2':
          return AppTheme.line2;
        case 'L3':
        case 'L3A':
        case 'L3B':
          return AppTheme.line3;
        case 'LRT_MAIN':
        case 'LRT_BRANCH_NAC':
        case 'LRT_BRANCH_10TH':
          return AppTheme.lrt;
      }
    }
    return AppTheme.primaryNile;
  }

  // ── App bar ───────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: AppBar(
            backgroundColor: _palette.appBarBg,
            elevation: 0,
            toolbarHeight: 64,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: _palette.iconPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.metroMapLabel,
                    style: TextStyle(
                        color: _palette.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3)),
                Text(l10n.cairoMetroNetworkLabel,
                    style: TextStyle(
                        color: _palette.textSecondary, fontSize: 11)),
              ],
            ),
            centerTitle: false,
            actions: [
              _iconBtn(Icons.search_rounded,
                  () => setState(() => _searchOpen = !_searchOpen)),
              const SizedBox(width: 6),
              _iconBtn(
                _mapMode ? Icons.map_outlined : Icons.map_rounded,
                _toggleMapMode,
                tooltip: _mapMode ? l10n.mapViewSchematic : l10n.mapViewGeographic,
              ),
              const SizedBox(width: 6),
              ScaleTransition(
                scale: _resetBtnAnim,
                child: _iconBtn(Icons.center_focus_strong_rounded, _resetView,
                    tooltip: l10n.resetViewLabel),
              ),
              const SizedBox(width: 6),
              _iconBtn(
                _legendVisible
                    ? Icons.layers_rounded
                    : Icons.layers_clear_rounded,
                _toggleLegend,
                tooltip: l10n.mapLegendLabel,
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, {String? tooltip}) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: _palette.iconBtnBg,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: _palette.iconPrimary, size: 20),
          ),
        ),
      ),
    );
  }

  // ── Zoom controls ─────────────────────────────────────────────────────

  Widget _buildZoomControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: _scale > 0.5 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _palette.zoomCountBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _palette.zoomCountBorder),
            ),
            child: Text(
                _mapMode
                    ? '${_mapZoom.toStringAsFixed(0)}z'
                    : '${_scale.toStringAsFixed(1)}×',
                style: TextStyle(
                    color: _palette.zoomCountText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5)),
          ),
        ),
        _zoomBtn(Icons.add_rounded, () => _zoomStep(_step), isTop: true),
        Container(width: 44, height: 1, color: _palette.zoomDivider),
        _zoomBtn(Icons.remove_rounded, () => _zoomStep(1 / _step),
            isTop: false),
      ],
    );
  }

  Widget _zoomBtn(IconData icon, VoidCallback onTap, {required bool isTop}) {
    return Material(
      color: _palette.zoomBtnBg,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isTop ? 14 : 0),
        topRight: Radius.circular(isTop ? 14 : 0),
        bottomLeft: Radius.circular(isTop ? 0 : 14),
        bottomRight: Radius.circular(isTop ? 0 : 14),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTop ? 14 : 0),
          topRight: Radius.circular(isTop ? 14 : 0),
          bottomLeft: Radius.circular(isTop ? 0 : 14),
          bottomRight: Radius.circular(isTop ? 0 : 14),
        ),
        splashColor: _palette.iconBtnBg,
        child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: _palette.iconPrimary, size: 20)),
      ),
    );
  }

  // ── Legend + filters ──────────────────────────────────────────────────

  Widget _buildLegend(AppLocalizations l10n, double bottomPad) {
    return SizeTransition(
      sizeFactor: _legendAnim,
      axisAlignment: 1,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
        decoration: BoxDecoration(
          color: _palette.legendBg,
          border: Border(top: BorderSide(color: _palette.legendBorder)),
          boxShadow: _palette.isDark
              ? []
              : [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4)),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(l10n.mapLegendLabel.toUpperCase(),
                  style: TextStyle(
                      color: _palette.legendLabel,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _lineFilterChip('L1', 'Line 1', AppTheme.line1, '35'),
                  const SizedBox(width: 8),
                  _lineFilterChip('L2', 'Line 2', AppTheme.line2, '20'),
                  const SizedBox(width: 8),
                  _lineFilterChip('L3', 'Line 3', AppTheme.line3, '34'),
                  const SizedBox(width: 8),
                  _lineFilterChip('LRT', 'LRT', AppTheme.lrt, '19'),
                  const SizedBox(width: 8),
                  _transferChip(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: _palette.legendLabel, size: 12),
                const SizedBox(width: 6),
                Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'اضغط على الخط لإظهاره/إخفائه'
                      : 'Tap a line to show/hide it',
                  style: TextStyle(
                      color: _palette.legendLabel,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _lineFilterChip(
      String visKey, String name, Color color, String count) {
    final isActive = _visibleLineIds.contains(visKey);
    return GestureDetector(
      onTap: () => _toggleLine(visKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Color.fromRGBO(color.red, color.green, color.blue, 0.15)
              : _palette.chipInactiveBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Color.fromRGBO(color.red, color.green, color.blue, 0.5)
                : _palette.chipInactiveBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? color
                    : Color.fromRGBO(color.red, color.green, color.blue, 0.35),
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                            color: Color.fromRGBO(
                                color.red, color.green, color.blue, 0.45),
                            blurRadius: 6)
                      ]
                    : [],
              ),
            ),
            const SizedBox(width: 8),
            Text(name,
                style: TextStyle(
                    color: isActive
                        ? _palette.chipActiveText
                        : _palette.chipInactiveText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Text(count,
                style: TextStyle(
                    color: isActive
                        ? _palette.chipCountActive
                        : _palette.chipCountInactive,
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _transferChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _palette.chipInactiveBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _palette.chipInactiveBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _palette.textPrimary, width: 2),
            ),
          ),
          const SizedBox(width: 8),
          Text(AppLocalizations.of(context)!.transferLabel,
              style: TextStyle(
                  color: _palette.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Station Info Bottom Sheet
// ═════════════════════════════════════════════════════════════════════════════

class _StationInfoSheet extends StatelessWidget {
  final Station station;
  final List<MetroLine> lines;
  final List<Station> adjacentStations;
  final String languageCode;
  final AppLocalizations l10n;
  final double bottomPadding;
  final VoidCallback onClose;
  final ValueChanged<Station> onAdjacentTap;

  const _StationInfoSheet({
    required this.station,
    required this.lines,
    required this.adjacentStations,
    required this.languageCode,
    required this.l10n,
    required this.bottomPadding,
    required this.onClose,
    required this.onAdjacentTap,
  });

  Color _themeColor(MetroLine line) {
    switch (line.id) {
      case 'L1':
        return AppTheme.line1;
      case 'L2':
        return AppTheme.line2;
      case 'L3':
      case 'L3A':
      case 'L3B':
        return AppTheme.line3;
      case 'LRT_MAIN':
      case 'LRT_BRANCH_NAC':
      case 'LRT_BRANCH_10TH':
        return AppTheme.lrt;
      default:
        return line.color;
    }
  }

  Color _stationThemeColor(Station s) {
    for (final lid in s.lineIds) {
      switch (lid) {
        case 'L1':
          return AppTheme.line1;
        case 'L2':
          return AppTheme.line2;
        case 'L3':
        case 'L3A':
        case 'L3B':
          return AppTheme.line3;
        case 'LRT_MAIN':
        case 'LRT_BRANCH_NAC':
        case 'LRT_BRANCH_10TH':
          return AppTheme.lrt;
      }
    }
    return AppTheme.primaryNile;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pal = isDark ? const _Palette.dark() : const _Palette.light();

    final stationLines =
        lines.where((l) => station.lineIds.contains(l.id)).toList();
    final mainColor = _stationThemeColor(station);

    // Sheet background — dark: deep navy tinted by line color
    //                    light: white tinted subtly by line color
    final sheetBase = isDark ? const Color(0xFF1A2332) : Colors.white;

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sheetBase,
            Color.lerp(sheetBase, mainColor, 0.06)!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Color.fromRGBO(
                mainColor.red, mainColor.green, mainColor.blue, 0.15)),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(
                  mainColor.red, mainColor.green, mainColor.blue, 0.12),
              blurRadius: 30,
              offset: const Offset(0, -4)),
          BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, -2)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 16 + bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: pal.sheetHandle,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 44,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(mainColor.red, mainColor.green,
                              mainColor.blue, 0.4),
                          blurRadius: 8),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(station.localizedName(languageCode),
                          style: TextStyle(
                              color: pal.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5)),
                      Text(
                          languageCode == 'ar'
                              ? station.nameEn
                              : station.nameAr,
                          style: TextStyle(
                              color: pal.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: pal.sheetCloseBtn,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.close_rounded,
                        color: pal.iconPrimary, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final line in stationLines) _lineChip(line, pal),
                if (station.isTransfer)
                  _badgeChip(Icons.swap_horiz_rounded, l10n.transferLabel,
                      Colors.amber, pal),
                if (station.isAccessible)
                  _badgeChip(Icons.accessible_rounded, l10n.accessibilityLabel,
                      Colors.blue, pal),
              ],
            ),
            if (station.facilities.isNotEmpty) ...[
              const SizedBox(height: 14),
              _infoRow(
                icon: Icons.business_rounded,
                label: l10n.facilitiesTitle,
                pal: pal,
                trailing: Wrap(
                  spacing: 6,
                  children:
                      station.facilities.map((f) => _facilityIcon(f, pal)).toList(),
                ),
              ),
            ],
            if (adjacentStations.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                languageCode == 'ar' ? 'المحطات المجاورة' : 'Adjacent Stations',
                style: TextStyle(
                    color: pal.textTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: adjacentStations.map((adj) {
                    final ac = _stationThemeColor(adj);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => onAdjacentTap(adj),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                Color.fromRGBO(ac.red, ac.green, ac.blue, 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Color.fromRGBO(
                                    ac.red, ac.green, ac.blue, 0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    color: ac, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Text(adj.localizedName(languageCode),
                                  style: TextStyle(
                                      color: pal.textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 6),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  color: pal.textTertiary, size: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            const SizedBox(height: 14),
            _infoRow(
              icon: Icons.location_on_rounded,
              label:
                  '${station.latitude.toStringAsFixed(5)}, ${station.longitude.toStringAsFixed(5)}',
              pal: pal,
              useMono: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
      {required IconData icon,
      required String label,
      required _Palette pal,
      Widget? trailing,
      bool useMono = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: pal.infoRowBg,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: pal.sheetIcon, size: 16),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: pal.textSecondary,
                      fontSize: 12,
                      fontFamily: useMono ? 'monospace' : null,
                      fontWeight: FontWeight.w500))),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _lineChip(MetroLine line, _Palette pal) {
    final c = _themeColor(line);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color.fromRGBO(c.red, c.green, c.blue, 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color.fromRGBO(c.red, c.green, c.blue, 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(c.red, c.green, c.blue, 0.5),
                    blurRadius: 4)
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(line.localizedName(languageCode),
              style: TextStyle(
                  color: c, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _badgeChip(IconData icon, String label, Color color, _Palette pal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Color.fromRGBO(color.red, color.green, color.blue, 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Color.fromRGBO(color.red, color.green, color.blue, 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _facilityIcon(String facility, _Palette pal) {
    final (IconData icon, String tip) = switch (facility) {
      'toilet' => (Icons.wc_rounded, 'Toilets'),
      'parking' => (Icons.local_parking_rounded, 'Parking'),
      'elevator' => (Icons.elevator_rounded, 'Elevator'),
      'escalator' => (Icons.escalator_rounded, 'Escalator'),
      'women_only_car' => (Icons.woman_rounded, 'Women Only'),
      'police' => (Icons.local_police_rounded, 'Police'),
      'bus_interchange' => (Icons.directions_bus_rounded, 'Bus'),
      _ => (Icons.info_outline_rounded, facility),
    };
    return Tooltip(
      message: tip,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: pal.infoRowBg,
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: pal.sheetIcon, size: 15),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// _Palette — centralises every light/dark colour used by MetroMapPage.
//
// Dark mode: deep midnight navy, white controls — existing cinematic look.
// Light mode: clean daylight map — warm off-white background, dark controls,
//             Carto Voyager tiles (rastertiles/voyager_labels_under).
// ═════════════════════════════════════════════════════════════════════════════

class _Palette {
  final bool isDark;

  const _Palette.dark() : isDark = true;
  const _Palette.light() : isDark = false;

  // ── Scaffold & overlays ───────────────────────────────────────────────────

  Color get background =>
      isDark ? const Color(0xFF0A1628) : const Color(0xFFEEF3F8);

  Color get vignette1 =>
      isDark ? const Color(0xCC0A1628) : const Color(0xAAD6E4F0);

  Color get vignette4 =>
      isDark ? const Color(0xD90A1628) : const Color(0xCCD6E4F0);

  Color get appBarBg =>
      isDark ? const Color(0x61000000) : const Color(0xCCFFFFFF);

  // ── Text ─────────────────────────────────────────────────────────────────

  Color get textPrimary =>
      isDark ? Colors.white : const Color(0xFF1A2332);

  Color get textSecondary =>
      isDark ? const Color(0x8CFFFFFF) : const Color(0xFF4A5568);

  Color get textTertiary =>
      isDark ? const Color(0x66FFFFFF) : const Color(0xFF8A9BB0);

  // ── Icons ─────────────────────────────────────────────────────────────────

  Color get iconPrimary =>
      isDark ? Colors.white : const Color(0xFF1A2332);

  Color get iconSecondary =>
      isDark ? const Color(0x99FFFFFF) : const Color(0xFF4A5568);

  Color get iconBtnBg =>
      isDark ? const Color(0x1FFFFFFF) : const Color(0x14000000);

  // ── Floating controls (zoom, location, badge) ────────────────────────────

  Color get controlBg =>
      isDark ? const Color(0x1AFFFFFF) : const Color(0xDDFFFFFF);

  Color get controlBorder =>
      isDark ? const Color(0x14FFFFFF) : const Color(0x22000000);

  // ── Hint chip ─────────────────────────────────────────────────────────────

  Color get hintChipBg =>
      isDark ? const Color(0x8C000000) : const Color(0xCCFFFFFF);

  Color get hintChipBorder =>
      isDark ? const Color(0x1AFFFFFF) : const Color(0x22000000);

  Color get hintText =>
      isDark ? const Color(0xA6FFFFFF) : const Color(0x99000000);

  // ── Station count badge ───────────────────────────────────────────────────

  Color get stationCountText =>
      isDark ? const Color(0xCCFFFFFF) : const Color(0xCC000000);

  // ── Search overlay ────────────────────────────────────────────────────────

  Color get overlayBg =>
      isDark ? const Color(0xF21A2332) : const Color(0xF8FFFFFF);

  Color get overlayBorder =>
      isDark ? const Color(0x1FFFFFFF) : const Color(0x1A000000);

  Color get searchText =>
      isDark ? Colors.white : const Color(0xFF1A2332);

  Color get searchHint =>
      isDark ? const Color(0x59FFFFFF) : const Color(0x59000000);

  Color get searchIcon =>
      isDark ? const Color(0x66FFFFFF) : const Color(0x66000000);

  // ── Zoom controls ─────────────────────────────────────────────────────────

  Color get zoomBtnBg =>
      isDark ? const Color(0x21FFFFFF) : const Color(0xDDFFFFFF);

  Color get zoomDivider =>
      isDark ? const Color(0x26FFFFFF) : const Color(0x1A000000);

  Color get zoomCountBg =>
      isDark ? const Color(0x99000000) : const Color(0xDDFFFFFF);

  Color get zoomCountText =>
      isDark ? Colors.white : const Color(0xFF1A2332);

  Color get zoomCountBorder =>
      isDark ? const Color(0x26FFFFFF) : const Color(0x1A000000);

  // ── Legend ────────────────────────────────────────────────────────────────

  Color get legendBg =>
      isDark ? const Color(0xD9101828) : const Color(0xF8FFFFFF);

  Color get legendBorder =>
      isDark ? const Color(0x14FFFFFF) : const Color(0x18000000);

  Color get legendLabel =>
      isDark ? const Color(0x66FFFFFF) : const Color(0x70000000);

  // ── Filter chips ──────────────────────────────────────────────────────────

  Color get chipInactiveBg =>
      isDark ? const Color(0x0DFFFFFF) : const Color(0x0A000000);

  Color get chipInactiveBorder =>
      isDark ? const Color(0x14FFFFFF) : const Color(0x18000000);

  Color get chipActiveText =>
      isDark ? Colors.white : const Color(0xFF1A2332);

  Color get chipInactiveText =>
      isDark ? const Color(0x59FFFFFF) : const Color(0x59000000);

  Color get chipCountActive =>
      isDark ? const Color(0x73FFFFFF) : const Color(0x73000000);

  Color get chipCountInactive =>
      isDark ? const Color(0x33FFFFFF) : const Color(0x33000000);

  // ── Station info sheet ────────────────────────────────────────────────────

  Color get sheetHandle =>
      isDark ? const Color(0x26FFFFFF) : const Color(0x26000000);

  Color get sheetIcon =>
      isDark ? const Color(0x66FFFFFF) : const Color(0x66000000);

  Color get sheetCloseBtn =>
      isDark ? const Color(0x14FFFFFF) : const Color(0x10000000);

  Color get infoRowBg =>
      isDark ? const Color(0x0DFFFFFF) : const Color(0x08000000);

  // ── Label painter colours (passed to MetroMapPainter) ────────────────────

  /// Text colour for station / district labels on the canvas.
  Color get labelColor =>
      isDark ? Colors.white : const Color(0xFF1E2A3A);

  /// Pill background behind each label.
  Color get labelBgColor =>
      isDark ? const Color(0x99000000) : const Color(0xCCFFFFFF);

  // ── Map tile URL ──────────────────────────────────────────────────────────

  String get tileUrl => isDark
      ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
      : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_labels_under/{z}/{x}/{y}{r}.png';

  // ── System UI overlay ─────────────────────────────────────────────────────

  SystemUiOverlayStyle get systemOverlay =>
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}
