import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/domain/entities/metro_line.dart';
import 'package:metroappflutter/domain/entities/station.dart';
import 'package:metroappflutter/domain/repositories/metro_repository.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:metroappflutter/widgets/metro_map_painter.dart';

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

  // ── Pre-computed caches (built once) ───────────────────────────────────
  MapBounds? _bounds;
  Map<String, Offset> _stationPositions = {};
  Map<String, Path> _linePaths = {};
  Map<String, List<Offset>> _trainSamples = {};

  static const _min = 0.25;
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

    _trainCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 14));
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

    setState(() {
      _stationMap = {for (final s in stations) s.id: s};
      _lines = lines;
      _bounds = bounds;
      _stationPositions = positions;
      _linePaths = paths;
      _trainSamples = samples;
      _loading = false;
    });

    _entranceCtrl.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitAllStations());
  }

  @override
  void dispose() {
    _transform
      ..removeListener(_onTransformChanged)
      ..dispose();
    _legendCtrl.dispose();
    _resetBtnCtrl.dispose();
    _pulseCtrl.dispose();
    _trainCtrl.dispose();
    _entranceCtrl.dispose();
    _userLocPulseCtrl.dispose();
    _searchCtrl.dispose();
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

  void _onInteractionStart(ScaleStartDetails _) {
    _isInteracting = true;
    _trainCtrl.stop();
    _userLocPulseCtrl.stop();
    _pulseCtrl.stop();
  }

  void _onInteractionEnd(ScaleEndDetails _) {
    _isInteracting = false;
    setState(() {}); // update zoom display once
    if (_entranceAnim.value >= 1.0) _trainCtrl.repeat();
    if (_userLocationCanvas != null) _userLocPulseCtrl.repeat();
    if (_selectedStationId != null) _pulseCtrl.repeat();
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

  bool _isStationVisible(Station s) {
    return s.lineIds.any((lid) {
      if (lid.startsWith('LRT')) return _visibleLineIds.contains('LRT');
      if (lid == 'L3A' || lid == 'L3B') {
        return _visibleLineIds.contains('L3');
      }
      return _visibleLineIds.contains(lid);
    });
  }

  // ── User location ────────────────────────────────────────────────────

  Future<void> _fetchUserLocation() async {
    if (_locationLoading) return;
    setState(() => _locationLoading = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.locationServicesDisabled),
            backgroundColor: Colors.red.shade700,
          ));
        }
        setState(() => _locationLoading = false);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.locationPermissionDenied),
              backgroundColor: Colors.red.shade700,
            ));
          }
          setState(() => _locationLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.locationPermissionDenied),
            backgroundColor: Colors.red.shade700,
          ));
        }
        setState(() => _locationLoading = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      setState(() {
        _userGpsPosition = pos;
        _locationLoading = false;
      });
      _updateUserCanvasPosition();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.locationError),
          backgroundColor: Colors.red.shade700,
        ));
        setState(() => _locationLoading = false);
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
          .where((s) =>
              s.nameEn.toLowerCase().contains(q) || s.nameAr.contains(q))
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
    final l10n = AppLocalizations.of(context)!;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final topPad = MediaQuery.of(context).padding.top;
    final legendH = _legendVisible ? (108.0 + bottomPad) : 0.0;
    final lang = Localizations.localeOf(context).languageCode;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1628),
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
                child: GestureDetector(
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
                          // ── Static layer (cached) ──────────────
                          RepaintBoundary(
                            child: AnimatedBuilder(
                              animation: _entranceAnim,
                              builder: (_, __) => CustomPaint(
                                isComplex: true,
                                willChange: false,
                                size: _bounds!.size,
                                painter: MetroMapStaticPainter(
                                  lines: _lines,
                                  stationMap: _stationMap,
                                  stationPositions: _stationPositions,
                                  linePaths: _linePaths,
                                  languageCode: lang,
                                  visibleLineIds:
                                      Set<String>.from(_visibleLineIds),
                                  entranceProgress: _entranceAnim.value,
                                  canvasSize: _bounds!.size,
                                ),
                              ),
                            ),
                          ),
                          // ── Animated layer (lightweight) ───────
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
                                    selectedStationPos: selId != null
                                        ? _stationPositions[selId]
                                        : null,
                                    selectedStationColor: selId != null &&
                                            _stationMap[selId] != null
                                        ? stationThemeColor(
                                            _stationMap[selId]!)
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
                ),
              ),

            // ── Vignette ───────────────────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xCC0A1628),
                        Colors.transparent,
                        Colors.transparent,
                        const Color(0xD90A1628),
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
            if (!_loading && _selectedStationId == null && !_searchOpen)
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
                        color: const Color(0x8C000000),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0x1AFFFFFF)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.touch_app_rounded,
                              color: Color(0xA6FFFFFF), size: 16),
                          const SizedBox(width: 8),
                          Text(
                            lang == 'ar'
                                ? 'اضغط على محطة · انقر مرتين للتكبير'
                                : 'Tap station · Double-tap to zoom',
                            style: const TextStyle(
                              color: Color(0xA6FFFFFF),
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

  // ── Location button ───────────────────────────────────────────────────

  Widget _locationButton() {
    final hasLoc = _userLocationCanvas != null;
    return Material(
      color: hasLoc ? const Color(0x404285F4) : const Color(0x1AFFFFFF),
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
              color: hasLoc ? const Color(0x664285F4) : const Color(0x14FFFFFF),
            ),
          ),
          child: _locationLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Icon(
                  hasLoc
                      ? Icons.my_location_rounded
                      : Icons.location_searching_rounded,
                  color:
                      hasLoc ? const Color(0xFF4285F4) : const Color(0x99FFFFFF),
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
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.train_rounded, color: Color(0x99FFFFFF), size: 14),
          const SizedBox(width: 6),
          Text('${_stationMap.length}',
              style: const TextStyle(
                  color: Color(0xCCFFFFFF),
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 3),
          const Text('stations',
              style: TextStyle(
                  color: Color(0x66FFFFFF),
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
              color: const Color(0xF21A2332),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x1FFFFFFF)),
            ),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText:
                    lang == 'ar' ? 'ابحث عن محطة...' : 'Search stations...',
                hintStyle:
                    const TextStyle(color: Color(0x59FFFFFF), fontSize: 15),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: Color(0x66FFFFFF)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: Color(0x66FFFFFF), size: 20),
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
                color: const Color(0xF21A2332),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x14FFFFFF)),
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
                              color: Color.fromRGBO(c.red, c.green, c.blue, 0.5),
                              blurRadius: 4)
                        ],
                      ),
                    ),
                    title: Text(s.localizedName(lang),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(lang == 'ar' ? s.nameEn : s.nameAr,
                        style: const TextStyle(
                            color: Color(0x66FFFFFF), fontSize: 11)),
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
            backgroundColor: const Color(0x61000000),
            elevation: 0,
            toolbarHeight: 64,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.metroMapLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3)),
                Text(l10n.cairoMetroNetworkLabel,
                    style: const TextStyle(
                        color: Color(0x8CFFFFFF), fontSize: 11)),
              ],
            ),
            centerTitle: false,
            actions: [
              _iconBtn(Icons.search_rounded,
                  () => setState(() => _searchOpen = !_searchOpen)),
              const SizedBox(width: 6),
              ScaleTransition(
                scale: _resetBtnAnim,
                child: _iconBtn(
                    Icons.center_focus_strong_rounded, _resetView,
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
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: 20),
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
              color: const Color(0x99000000),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x26FFFFFF)),
            ),
            child: Text('${_scale.toStringAsFixed(1)}×',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5)),
          ),
        ),
        _zoomBtn(Icons.add_rounded, () => _zoomStep(_step), isTop: true),
        Container(
            width: 44, height: 1, color: const Color(0x26FFFFFF)),
        _zoomBtn(Icons.remove_rounded, () => _zoomStep(1 / _step),
            isTop: false),
      ],
    );
  }

  Widget _zoomBtn(IconData icon, VoidCallback onTap, {required bool isTop}) {
    return Material(
      color: const Color(0x21FFFFFF),
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
        splashColor: const Color(0x1AFFFFFF),
        child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: Colors.white, size: 20)),
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
        decoration: const BoxDecoration(
          color: Color(0xD9101828),
          border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(l10n.mapLegendLabel.toUpperCase(),
                  style: const TextStyle(
                      color: Color(0x66FFFFFF),
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
                const Icon(Icons.info_outline_rounded,
                    color: Color(0x40FFFFFF), size: 12),
                const SizedBox(width: 6),
                Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'اضغط على الخط لإظهاره/إخفائه'
                      : 'Tap a line to show/hide it',
                  style: const TextStyle(
                      color: Color(0x40FFFFFF),
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
              ? Color.fromRGBO(color.red, color.green, color.blue, 0.2)
              : const Color(0x0DFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Color.fromRGBO(color.red, color.green, color.blue, 0.5)
                : const Color(0x14FFFFFF),
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
                    : Color.fromRGBO(color.red, color.green, color.blue, 0.3),
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                            color: Color.fromRGBO(
                                color.red, color.green, color.blue, 0.5),
                            blurRadius: 6)
                      ]
                    : [],
              ),
            ),
            const SizedBox(width: 8),
            Text(name,
                style: TextStyle(
                    color: isActive ? Colors.white : const Color(0x59FFFFFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Text(count,
                style: TextStyle(
                    color: isActive
                        ? const Color(0x73FFFFFF)
                        : const Color(0x33FFFFFF),
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
        color: const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          const SizedBox(width: 8),
          const Text('Transfer',
              style: TextStyle(
                  color: Colors.white,
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
    final stationLines =
        lines.where((l) => station.lineIds.contains(l.id)).toList();
    final mainColor = _stationThemeColor(station);

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2332),
            Color.lerp(const Color(0xFF1A2332), mainColor, 0.08)!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Color.fromRGBO(
                mainColor.red, mainColor.green, mainColor.blue, 0.15)),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(
                  mainColor.red, mainColor.green, mainColor.blue, 0.1),
              blurRadius: 30,
              offset: const Offset(0, -4)),
          const BoxShadow(
              color: Color(0x66000000),
              blurRadius: 20,
              offset: Offset(0, -2)),
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
                    color: const Color(0x26FFFFFF),
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
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5)),
                      Text(
                          languageCode == 'ar'
                              ? station.nameEn
                              : station.nameAr,
                          style: const TextStyle(
                              color: Color(0x73FFFFFF),
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
                        color: const Color(0x14FFFFFF),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final line in stationLines) _lineChip(line),
                if (station.isTransfer)
                  _badgeChip(
                      Icons.swap_horiz_rounded, l10n.transferLabel, Colors.amber),
                if (station.isAccessible)
                  _badgeChip(Icons.accessible_rounded, l10n.accessibilityLabel,
                      Colors.blue),
              ],
            ),
            if (station.facilities.isNotEmpty) ...[
              const SizedBox(height: 14),
              _infoRow(
                icon: Icons.business_rounded,
                label: l10n.facilitiesTitle,
                trailing: Wrap(
                  spacing: 6,
                  children:
                      station.facilities.map((f) => _facilityIcon(f)).toList(),
                ),
              ),
            ],
            if (adjacentStations.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                languageCode == 'ar' ? 'المحطات المجاورة' : 'Adjacent Stations',
                style: const TextStyle(
                    color: Color(0x66FFFFFF),
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
                            color: Color.fromRGBO(
                                ac.red, ac.green, ac.blue, 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Color.fromRGBO(
                                    ac.red, ac.green, ac.blue, 0.2)),
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
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: Color(0x4DFFFFFF), size: 10),
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
      Widget? trailing,
      bool useMono = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0x0DFFFFFF),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: const Color(0x66FFFFFF), size: 16),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: const Color(0x8CFFFFFF),
                      fontSize: 12,
                      fontFamily: useMono ? 'monospace' : null,
                      fontWeight: FontWeight.w500))),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _lineChip(MetroLine line) {
    final c = _themeColor(line);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color.fromRGBO(c.red, c.green, c.blue, 0.18),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Color.fromRGBO(c.red, c.green, c.blue, 0.35)),
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

  Widget _badgeChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Color.fromRGBO(color.red, color.green, color.blue, 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Color.fromRGBO(color.red, color.green, color.blue, 0.25)),
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

  Widget _facilityIcon(String facility) {
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
            color: const Color(0x14FFFFFF),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0x99FFFFFF), size: 15),
      ),
    );
  }
}
