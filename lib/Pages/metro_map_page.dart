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
// MetroMapPage — Interactive Cairo Metro + LRT Map  v3
// ─────────────────────────────────────────────────────────────────────────────

class MetroMapPage extends StatefulWidget {
  const MetroMapPage({super.key});
  @override
  State<MetroMapPage> createState() => _MetroMapPageState();
}

class _MetroMapPageState extends State<MetroMapPage>
    with TickerProviderStateMixin {
  final TransformationController _transform = TransformationController();

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

  double _scale = 1.0;
  bool _legendVisible = true;

  List<MetroLine> _lines = [];
  Map<String, Station> _stationMap = {};
  bool _loading = true;

  String? _selectedStationId;
  final Map<String, Offset> _stationPositions = {};
  final Set<String> _visibleLineIds = {'L1', 'L2', 'L3', 'LRT'};

  bool _searchOpen = false;
  final _searchCtrl = TextEditingController();
  List<Station> _searchResults = [];

  // User location
  Offset? _userLocationCanvas;
  Position? _userGpsPosition;
  bool _locationLoading = false;

  // We keep a reference to the painter's projection for GPS→canvas
  MetroMapPainter? _lastPainter;

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
        vsync: this, duration: const Duration(seconds: 14))
      ..repeat();

    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _entranceAnim =
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic);

    _userLocPulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();

    _searchCtrl.addListener(_onSearchChanged);
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = Get.find<MetroRepository>();
    final stations = await repo.getAllStations();
    final lines = await repo.getAllLines();
    if (!mounted) return;
    setState(() {
      _stationMap = {for (final s in stations) s.id: s};
      _lines = lines;
      _loading = false;
    });

    // Start entrance, then fit map after a frame
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

  // ── Fit all stations in view ────────────────────────────────────────────

  void _fitAllStations() {
    if (_stationPositions.isEmpty) return;
    final sz = MediaQuery.of(context).size;

    // Create a temporary painter to get canvas size
    final painter = MetroMapPainter(
      lines: _lines,
      stationMap: _stationMap,
      languageCode: 'en',
      zoom: 1,
      stationPositions: _stationPositions,
      visibleLineIds: _visibleLineIds,
    );
    final canvasSize = painter.canvasSize;

    // Compute scale to fit canvas in viewport
    final scaleX = sz.width / canvasSize.width;
    final scaleY = (sz.height - 200) / canvasSize.height; // account for appbar+legend
    final fitScale = (scaleX < scaleY ? scaleX : scaleY) * 0.92;

    // Center the canvas
    final scaledW = canvasSize.width * fitScale;
    final scaledH = canvasSize.height * fitScale;
    final tx = (sz.width - scaledW) / 2;
    final ty = (sz.height - scaledH) / 2;

    _transform.value = Matrix4.identity()
      ..translate(tx, ty)
      ..scale(fitScale);
  }

  // ── Zoom ────────────────────────────────────────────────────────────────

  void _onTransformChanged() {
    final s = _transform.value.getMaxScaleOnAxis();
    if ((s - _scale).abs() < 0.01) return;
    setState(() => _scale = s);
    s > 0.35 ? _resetBtnCtrl.forward() : _resetBtnCtrl.reverse();
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

  // ── Zoom to station ─────────────────────────────────────────────────────

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

  // ── Tap ─────────────────────────────────────────────────────────────────

  void _onTapUp(TapUpDetails details) {
    if (_stationPositions.isEmpty) return;
    final scene = _transform.toScene(details.localPosition);
    final hit = _findStation(scene);

    if (hit != null) {
      HapticFeedback.lightImpact();
      setState(() => _selectedStationId = hit.id);
      _pulseCtrl..reset()..repeat();
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
      _pulseCtrl..reset()..repeat();
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
      if (lid == 'L3A' || lid == 'L3B') return _visibleLineIds.contains('L3');
      return _visibleLineIds.contains(lid);
    });
  }

  // ── User location ───────────────────────────────────────────────────────

  Future<void> _fetchUserLocation() async {
    if (_locationLoading) return;
    setState(() => _locationLoading = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.locationServicesDisabled),
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
              content: Text(AppLocalizations.of(context)!.locationPermissionDenied),
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
            content: Text(AppLocalizations.of(context)!.locationPermissionDenied),
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
      // Canvas projection happens in build via _lastPainter
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
    if (_userGpsPosition == null || _lastPainter == null) return;
    setState(() {
      _userLocationCanvas = _lastPainter!.projectGps(
        _userGpsPosition!.latitude,
        _userGpsPosition!.longitude,
      );
    });
  }

  // ── Search ──────────────────────────────────────────────────────────────

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
    _pulseCtrl..reset()..repeat();

    // Ensure line visible
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

  // ── Line filter ─────────────────────────────────────────────────────────

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

  // ── Station sheet ───────────────────────────────────────────────────────

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
          _pulseCtrl..reset()..repeat();
          _zoomToStation(s.id);
          Future.delayed(
              const Duration(milliseconds: 200), () => _showStationSheet(s));
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════

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
            // ── Map ───────────────────────────────────────────────
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
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _pulseAnim,
                        _trainCtrl,
                        _entranceAnim,
                        _userLocPulseCtrl,
                      ]),
                      builder: (context, _) {
                        final painter = MetroMapPainter(
                          lines: _lines,
                          stationMap: _stationMap,
                          languageCode: lang,
                          zoom: _scale,
                          stationPositions: _stationPositions,
                          visibleLineIds: _visibleLineIds,
                          selectedStationId: _selectedStationId,
                          selectionAnimValue: _pulseAnim.value,
                          trainProgress: _trainCtrl.value,
                          entranceProgress: _entranceAnim.value,
                          userLocation: _userLocationCanvas,
                          userLocPulse: _userLocPulseCtrl.value,
                        );
                        _lastPainter = painter;

                        // Update user location projection if needed
                        if (_userGpsPosition != null &&
                            _userLocationCanvas == null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _updateUserCanvasPosition();
                          });
                        }

                        return SizedBox(
                          width: painter.canvasSize.width,
                          height: painter.canvasSize.height,
                          child: CustomPaint(painter: painter),
                        );
                      },
                    ),
                  ),
                ),
              ),

            // ── Vignette ──────────────────────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0A1628).withOpacity(0.8),
                        Colors.transparent,
                        Colors.transparent,
                        const Color(0xFF0A1628).withOpacity(0.85),
                      ],
                      stops: const [0.0, 0.12, 0.80, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // ── Search overlay ─────────────────────────────────────
            if (_searchOpen) _buildSearchOverlay(topPad, lang),

            // ── Hint chip ─────────────────────────────────────────
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
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app_rounded,
                              color: Colors.white.withOpacity(0.65),
                              size: 16),
                          const SizedBox(width: 8),
                          Text(
                            lang == 'ar'
                                ? 'اضغط على محطة · انقر مرتين للتكبير'
                                : 'Tap station · Double-tap to zoom',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
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

            // ── Location button (bottom left) ─────────────────────
            Positioned(
              left: 16,
              bottom: legendH + 70,
              child: _locationButton(),
            ),

            // ── Station count (bottom left) ───────────────────────
            if (!_loading && !_searchOpen)
              Positioned(
                left: 16,
                bottom: legendH + 16,
                child: _stationCountBadge(),
              ),

            // ── Zoom controls ─────────────────────────────────────
            Positioned(
              right: 16,
              bottom: legendH + 16,
              child: _buildZoomControls(),
            ),

            // ── Legend ─────────────────────────────────────────────
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: _buildLegend(l10n, bottomPad),
            ),
          ],
        ),
      ),
    );
  }

  // ── Location button ─────────────────────────────────────────────────────

  Widget _locationButton() {
    final hasLoc = _userLocationCanvas != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: hasLoc
              ? const Color(0xFF4285F4).withOpacity(0.25)
              : Colors.white.withOpacity(0.1),
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
                      ? const Color(0xFF4285F4).withOpacity(0.4)
                      : Colors.white.withOpacity(0.08),
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
                      color: hasLoc
                          ? const Color(0xFF4285F4)
                          : Colors.white.withOpacity(0.6),
                      size: 20),
            ),
          ),
        ),
      ),
    );
  }

  // ── Station count ───────────────────────────────────────────────────────

  Widget _stationCountBadge() {
    final count = _stationMap.length;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.train_rounded,
                  color: Colors.white.withOpacity(0.6), size: 14),
              const SizedBox(width: 6),
              Text('$count',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 3),
              Text('stations',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search ──────────────────────────────────────────────────────────────

  Widget _buildSearchOverlay(double topPad, String lang) {
    return Positioned(
      left: 12, right: 12, top: topPad + 64,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2332).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: lang == 'ar'
                        ? 'ابحث عن محطة...'
                        : 'Search stations...',
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.35), fontSize: 15),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: Colors.white.withOpacity(0.4)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close_rounded,
                          color: Colors.white.withOpacity(0.4), size: 20),
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          if (_searchResults.isNotEmpty) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2332).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _searchResults.map((s) {
                      final c = _colorForStation(s);
                      return ListTile(
                        dense: true,
                        leading: Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            color: c, shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: c.withOpacity(0.5), blurRadius: 4)],
                          ),
                        ),
                        title: Text(s.localizedName(lang),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(lang == 'ar' ? s.nameEn : s.nameAr,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 11)),
                        trailing: s.isTransfer
                            ? Icon(Icons.swap_horiz_rounded,
                                color: Colors.amber.withOpacity(0.6),
                                size: 16)
                            : null,
                        onTap: () => _selectSearchResult(s),
                      );
                    }).toList(),
                  ),
                ),
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
        case 'L1': return AppTheme.line1;
        case 'L2': return AppTheme.line2;
        case 'L3': case 'L3A': case 'L3B': return AppTheme.line3;
        case 'LRT_MAIN': case 'LRT_BRANCH_NAC': case 'LRT_BRANCH_10TH':
          return AppTheme.lrt;
      }
    }
    return AppTheme.primaryNile;
  }

  // ── App bar ─────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: AppBar(
            backgroundColor: Colors.black.withOpacity(0.38),
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
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11)),
              ],
            ),
            centerTitle: false,
            actions: [
              _glassIconBtn(Icons.search_rounded,
                  () => setState(() => _searchOpen = !_searchOpen)),
              const SizedBox(width: 6),
              ScaleTransition(
                scale: _resetBtnAnim,
                child: _glassIconBtn(
                    Icons.center_focus_strong_rounded, _resetView,
                    tooltip: l10n.resetViewLabel),
              ),
              const SizedBox(width: 6),
              _glassIconBtn(
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

  Widget _glassIconBtn(IconData icon, VoidCallback onTap, {String? tooltip}) {
    return Tooltip(
      message: tooltip ?? '',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.white.withOpacity(0.12),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Zoom controls ───────────────────────────────────────────────────────

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
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
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
            width: 44, height: 1, color: Colors.white.withOpacity(0.15)),
        _zoomBtn(Icons.remove_rounded, () => _zoomStep(1 / _step),
            isTop: false),
      ],
    );
  }

  Widget _zoomBtn(IconData icon, VoidCallback onTap, {required bool isTop}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isTop ? 14 : 0),
        topRight: Radius.circular(isTop ? 14 : 0),
        bottomLeft: Radius.circular(isTop ? 0 : 14),
        bottomRight: Radius.circular(isTop ? 0 : 14),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: Colors.white.withOpacity(0.13),
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.1),
            child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(icon, color: Colors.white, size: 20)),
          ),
        ),
      ),
    );
  }

  // ── Legend + filters ─────────────────────────────────────────────────────

  Widget _buildLegend(AppLocalizations l10n, double bottomPad) {
    return SizeTransition(
      sizeFactor: _legendAnim,
      axisAlignment: 1,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.08))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 10),
                  child: Text(l10n.mapLegendLabel.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
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
                        color: Colors.white.withOpacity(0.25), size: 12),
                    const SizedBox(width: 6),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'اضغط على الخط لإظهاره/إخفائه'
                          : 'Tap a line to show/hide it',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.25),
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
              ? color.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? color.withOpacity(0.5)
                : Colors.white.withOpacity(0.08),
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
                color: isActive ? color : color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)]
                    : [],
              ),
            ),
            const SizedBox(width: 8),
            Text(name,
                style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.35),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Text(count,
                style: TextStyle(
                    color: isActive
                        ? Colors.white.withOpacity(0.45)
                        : Colors.white.withOpacity(0.2),
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
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12, height: 12,
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

// ═══════════════════════════════════════════════════════════════════════════════
// Station Info Bottom Sheet
// ═══════════════════════════════════════════════════════════════════════════════

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
      case 'L1': return AppTheme.line1;
      case 'L2': return AppTheme.line2;
      case 'L3': case 'L3A': case 'L3B': return AppTheme.line3;
      case 'LRT_MAIN': case 'LRT_BRANCH_NAC': case 'LRT_BRANCH_10TH':
        return AppTheme.lrt;
      default: return line.color;
    }
  }

  Color _stationThemeColor(Station s) {
    for (final lid in s.lineIds) {
      switch (lid) {
        case 'L1': return AppTheme.line1;
        case 'L2': return AppTheme.line2;
        case 'L3': case 'L3A': case 'L3B': return AppTheme.line3;
        case 'LRT_MAIN': case 'LRT_BRANCH_NAC': case 'LRT_BRANCH_10TH':
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
        border: Border.all(color: mainColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
              color: mainColor.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, -4)),
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
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
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 4, height: 44,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                          color: mainColor.withOpacity(0.4), blurRadius: 8),
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
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.45),
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
                        color: Colors.white.withOpacity(0.08),
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
                  _badgeChip(Icons.swap_horiz_rounded, l10n.transferLabel,
                      Colors.amber),
                if (station.isAccessible)
                  _badgeChip(Icons.accessible_rounded,
                      l10n.accessibilityLabel, Colors.blue),
              ],
            ),
            if (station.facilities.isNotEmpty) ...[
              const SizedBox(height: 14),
              _infoRow(
                icon: Icons.business_rounded,
                label: l10n.facilitiesTitle,
                trailing: Wrap(
                  spacing: 6,
                  children: station.facilities
                      .map((f) => _facilityIcon(f))
                      .toList(),
                ),
              ),
            ],
            if (adjacentStations.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                languageCode == 'ar'
                    ? 'المحطات المجاورة'
                    : 'Adjacent Stations',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
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
                            color: ac.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ac.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6, height: 6,
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
                              Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white.withOpacity(0.3),
                                  size: 10),
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
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.4), size: 16),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
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
        color: c.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              color: c, shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: c.withOpacity(0.5), blurRadius: 4)],
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
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
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
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white.withOpacity(0.6), size: 15),
      ),
    );
  }
}
