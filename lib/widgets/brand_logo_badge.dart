import 'package:flutter/material.dart';

/// Branded "amulet" badge that frames `transparent_enhanced_logo_v1.png` on a
/// dark navy plate matching the logo's own interior, ringed in bright gold
/// with a dual amber+teal outer halo.
///
/// The dark plate makes the logo's transparent edges blend seamlessly so only
/// the gold/teal eye-of-Horus + M details "pop", and the gold ring defines
/// the badge's boundary against any background (dark teal app bar, dark card,
/// light card alike).
class BrandLogoBadge extends StatefulWidget {
  final double size;

  /// If true, the outer gold halo gently breathes — use for hero spots like
  /// a welcome tooltip. For static chrome (app bar) leave it off.
  final bool animated;

  const BrandLogoBadge({
    super.key,
    required this.size,
    this.animated = false,
  });

  @override
  State<BrandLogoBadge> createState() => BrandLogoBadgeState();
}

class BrandLogoBadgeState extends State<BrandLogoBadge>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseCtrl;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _pulseCtrl = AnimationController(
        duration: const Duration(milliseconds: 1800),
        vsync: this,
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final core = _buildCore(pulse: 0.0);
    if (_pulseCtrl == null) return core;
    return AnimatedBuilder(
      animation: _pulseCtrl!,
      builder: (_, __) => _buildCore(pulse: _pulseCtrl!.value),
    );
  }

  Widget _buildCore({required double pulse}) {
    final s = widget.size;
    // Glow: animated hero spots get an expansive dual halo; static chrome
    // (app bar / info-sheet rows) gets a tight rim glow that stays inside
    // the badge's footprint so it doesn't bleed into adjacent text.
    final amberA = widget.animated ? 0.40 + 0.25 * pulse : 0.55;
    final tealA = widget.animated ? 0.18 + 0.12 * pulse : 0.0;
    final amberBlur = widget.animated ? 14.0 + 8.0 * pulse : 5.0;
    final tealBlur = widget.animated ? 22.0 + 10.0 * pulse : 0.0;
    final amberSpread = widget.animated ? 0.5 : 0.0;
    final tealSpread = widget.animated ? 1.0 : 0.0;

    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ── Dark navy plate with subtle dimensional gradient ──────────
          Container(
            width: s,
            height: s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFF1B2D4D), // soft highlight at center
                  Color(0xFF0C1B33), // logo's own bg color
                  Color(0xFF06101F), // darker rim shadow
                ],
                stops: [0.0, 0.65, 1.0],
                radius: 0.85,
              ),
              border: Border.all(
                color: const Color(0xFFF4D26B),
                width: s >= 70 ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF4A11D).withValues(alpha: amberA),
                  blurRadius: amberBlur,
                  spreadRadius: amberSpread,
                ),
                if (tealA > 0)
                  BoxShadow(
                    color: const Color(0xFF4DD0E1).withValues(alpha: tealA),
                    blurRadius: tealBlur,
                    spreadRadius: tealSpread,
                  ),
              ],
            ),
          ),

          // ── Logo, centered, slightly inset so the rim is visible ──────
          Padding(
            padding: EdgeInsets.all(s * 0.06),
            child: Image.asset(
              'assets/transparent_enhanced_logo_v1.png',
              fit: BoxFit.contain,
            ),
          ),

          // ── Top specular highlight: glassy "coin" sheen ───────────────
          Positioned(
            top: s * 0.08,
            child: Container(
              width: s * 0.55,
              height: s * 0.18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(s),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.16),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
