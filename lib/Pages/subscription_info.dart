import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:flutter/material.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionInfoPage extends StatefulWidget {
  const SubscriptionInfoPage({super.key});

  @override
  State<SubscriptionInfoPage> createState() => _SubscriptionInfoPageState();
}

class _SubscriptionInfoPageState extends State<SubscriptionInfoPage> {
  int? _expandedIndex;

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _toggleCard(int index) =>
      setState(() => _expandedIndex = _expandedIndex == index ? null : index);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSand,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(l10n),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Where to buy
                  _sectionLabel(
                    l10n.whereToBuyTitle,
                    Icons.storefront_rounded,
                    AppTheme.primaryNile,
                  ),
                  const SizedBox(height: 10),
                  _infoCard(l10n.whereToBuyDescription),
                  const SizedBox(height: 28),

                  // Ticket types
                  _sectionLabel(
                    l10n.ticketsTitle,
                    Icons.confirmation_number_rounded,
                    AppTheme.line2,
                  ),
                  const SizedBox(height: 10),
                  _expandableCard(
                    index: 0,
                    icon: Icons.confirmation_number_rounded,
                    color: AppTheme.line2,
                    title: l10n.ticketsTitle,
                    bullets: [
                      l10n.ticketsBullet1,
                      l10n.ticketsBullet2,
                      l10n.ticketsBullet3,
                    ],
                    l10n: l10n,
                  ),
                  const SizedBox(height: 12),
                  _expandableCard(
                    index: 1,
                    icon: Icons.credit_card_rounded,
                    color: AppTheme.line3,
                    title: l10n.walletCardTitle,
                    bullets: [
                      l10n.walletBullet1,
                      l10n.walletBullet2,
                      l10n.walletBullet3,
                      l10n.walletBullet4,
                      l10n.walletBullet5,
                    ],
                    l10n: l10n,
                  ),
                  const SizedBox(height: 12),
                  _expandableCard(
                    index: 2,
                    icon: Icons.card_membership_rounded,
                    color: AppTheme.line1,
                    title: l10n.seasonalCardTitle,
                    bullets: [
                      l10n.seasonalBullet1,
                      '',
                      l10n.requirementsTitle,
                      l10n.seasonalBullet2,
                      l10n.seasonalBullet3,
                      '',
                      l10n.additionalRequirementsTitle,
                      l10n.studentReq,
                      l10n.elderlyReq,
                      l10n.specialNeedsReq,
                    ],
                    l10n: l10n,
                  ),
                  const SizedBox(height: 28),

                  // Fare zones image
                  _sectionLabel(
                    'Fare Zones',
                    Icons.map_rounded,
                    AppTheme.lrt,
                  ),
                  const SizedBox(height: 10),
                  _fareZonesCard(),
                  const SizedBox(height: 32),

                  // Learn more button
                  _learnMoreButton(l10n),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────

  Widget _buildAppBar(AppLocalizations l10n) {
    const expandedH = 150.0;

    return SliverAppBar(
      expandedHeight: expandedH,
      pinned: true,
      backgroundColor: AppTheme.primaryNile,
      elevation: 0,
      // Hide the default title — we draw our own inside LayoutBuilder
      title: const SizedBox.shrink(),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final topPad = MediaQuery.of(context).padding.top;
          final minH = kToolbarHeight + topPad;
          final maxH = expandedH + topPad;

          // t = 1 fully expanded, t = 0 fully collapsed
          final t =
              ((constraints.maxHeight - minH) / (maxH - minH)).clamp(0.0, 1.0);

          // ── Text positioning ────────────────────────────────────────────
          // Collapsed : text sits centred in toolbar, indented past back-arrow
          // Expanded  : text sits near the bottom of the hero area
          final textBottom = lerpDouble(10, 10, t)!;
          final textLeft = lerpDouble(56.0, 35.0, t)!;
          final titleSize = lerpDouble(15.0, 20.0, t)!;
          final subtitleOpacity = 1.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Gradient background ──────────────────────────────────────
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0D3B52),
                      AppTheme.primaryNile,
                      Color(0xFF1E7A8A),
                    ],
                  ),
                ),
              ),

              // ── Decorative circles ───────────────────────────────────────
              Positioned(
                right: -40,
                top: -20,
                child: Opacity(
                  opacity: t,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 40,
                bottom: -30,
                child: Opacity(
                  opacity: t,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),
              ),

              // ── Watermark icon ───────────────────────────────────────────
              Positioned(
                right: 24,
                top: topPad + 8,
                child: Opacity(
                  opacity: 0.12 * t,
                  child: const Icon(
                    Icons.confirmation_number_rounded,
                    size: 88,
                    color: Colors.white,
                  ),
                ),
              ),

              // ── Title + subtitle ─────────────────────────────────────────
              Positioned(
                left: textLeft,
                right: 20,
                bottom: textBottom,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.subscriptionInfoTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (subtitleOpacity > 0)
                      Opacity(
                        opacity: subtitleOpacity,
                        child: Text(
                          l10n.subscriptionInfoSubtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Section label ──────────────────────────────────────────────────────────

  Widget _sectionLabel(String label, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  // ── Info card ──────────────────────────────────────────────────────────────

  Widget _infoCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          height: 1.6,
        ),
      ),
    );
  }

  // ── Expandable card ────────────────────────────────────────────────────────

  Widget _expandableCard({
    required int index,
    required IconData icon,
    required Color color,
    required String title,
    required List<String> bullets,
    required AppLocalizations l10n,
  }) {
    final isOpen = _expandedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isOpen
                ? color.withOpacity(0.12)
                : Colors.black.withOpacity(0.04),
            blurRadius: isOpen ? 20 : 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isOpen ? color.withOpacity(0.25) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Header row (always visible)
          InkWell(
            onTap: () => _toggleCard(index),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 280),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isOpen
                            ? color.withOpacity(0.1)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isOpen ? color : Colors.grey.shade400,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded body
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 280),
            crossFadeState:
                isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                Divider(
                  height: 1,
                  color: color.withOpacity(0.15),
                  indent: 16,
                  endIndent: 16,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bullets.map((bullet) {
                      if (bullet.isEmpty) return const SizedBox(height: 8);

                      final isSubHeader = bullet == l10n.requirementsTitle ||
                          bullet == l10n.additionalRequirementsTitle;

                      if (isSubHeader) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 6),
                          child: Text(
                            bullet,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: color,
                              letterSpacing: 0.2,
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6, right: 10),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                bullet,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.grey.shade700,
                                  height: 1.55,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Fare zones card ────────────────────────────────────────────────────────

  Widget _fareZonesCard() {
    return GestureDetector(
      onTap: () => _showFullScreenImage(context),
      child: Hero(
        tag: 'fare-zones-image',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/subscriptionGuide.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 210,
              ),
              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.65),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.55],
                    ),
                  ),
                ),
              ),
              // Label
              Positioned(
                bottom: 14,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fare Zones Guide',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Tap to view full screen',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Fullscreen icon
              Positioned(
                top: 12,
                right: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      color: Colors.black.withOpacity(0.3),
                      child: const Icon(
                        Icons.fullscreen_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Learn more button ──────────────────────────────────────────────────────

  Widget _learnMoreButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [AppTheme.primaryNile, Color(0xFF1E7A8A)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryNile.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => _launchWebsite(context),
          icon: const Icon(Icons.open_in_new_rounded, size: 17),
          label: Text(l10n.learnMore),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: PhotoView(
            imageProvider:
                const AssetImage('assets/images/subscriptionGuide.png'),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 3,
            heroAttributes:
                const PhotoViewHeroAttributes(tag: 'fare-zones-image'),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Future<void> _launchWebsite(BuildContext context) async {
    const url = 'https://www.mobilitycairo.com/en/tickets/choose-your-ticket';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not launch website'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }
}
