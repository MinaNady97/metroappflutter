import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/data/egypt_cities_data.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// Egypt City Detail Page
// ═══════════════════════════════════════════════════════════════════════════════

class EgyptCityDetailPage extends StatefulWidget {
  final EgyptCity city;
  const EgyptCityDetailPage({super.key, required this.city});

  @override
  State<EgyptCityDetailPage> createState() => _EgyptCityDetailPageState();
}

class _EgyptCityDetailPageState extends State<EgyptCityDetailPage> {
  // Track which transport card is expanded
  final Set<int> _expandedTransport = {};

  EgyptCity get city => widget.city;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = l10n.locale;
    final isAr = locale == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, locale, isAr, isDark),
          SliverToBoxAdapter(
            child: _buildDescription(context, locale, isDark),
          ),
          SliverToBoxAdapter(
            child: _buildTransportSection(context, l10n, locale, isDark),
          ),
          if (city.places.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                context,
                l10n.thingsToDoTitle,
                Icons.place_rounded,
                isDark,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _PlaceCard(
                    place: city.places[i],
                    locale: locale,
                    accentColor: city.accentColor,
                  ),
                  childCount: city.places.length,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Sliver App Bar ────────────────────────────────────────────────────────────

  Widget _buildAppBar(
    BuildContext context,
    String locale,
    bool isAr,
    bool isDark,
  ) {
    const expandedH = 280.0;

    return SliverAppBar(
      expandedHeight: expandedH,
      pinned: true,
      stretch: true,
      backgroundColor:
          isDark ? AppTheme.darkAppBar : city.gradientColors.first,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 20, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final topPad = MediaQuery.of(context).padding.top;
          final minH = kToolbarHeight + topPad;
          final maxH = expandedH + topPad;
          final t =
              ((constraints.maxHeight - minH) / (maxH - minH)).clamp(0.0, 1.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // Hero image
              Image.asset(
                city.heroImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: city.gradientColors,
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.65),
                    ],
                  ),
                ),
              ),
              // City name + emoji
              Positioned(
                left: isAr ? null : 20,
                right: isAr ? 20 : null,
                bottom: 20,
                child: Opacity(
                  opacity: ((t - 0.2) / 0.6).clamp(0.0, 1.0),
                  child: Column(
                    crossAxisAlignment: isAr
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        city.emoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        city.name(locale),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 12,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Description ───────────────────────────────────────────────────────────────

  Widget _buildDescription(
    BuildContext context,
    String locale,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: city.accentColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: city.accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Text(
                city.description(locale),
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.6,
                  color: isDark
                      ? AppTheme.darkTextSub
                      : AppTheme.lightBodyText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Transport Section ─────────────────────────────────────────────────────────

  Widget _buildTransportSection(
    BuildContext context,
    AppLocalizations l10n,
    String locale,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          l10n.gettingThereTitle,
          Icons.directions_rounded,
          isDark,
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
          child: Text(
            l10n.transportNote,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppTheme.darkTextTertiary
                  : Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 4),
        ...city.transportOptions.asMap().entries.map((e) {
          final idx = e.key;
          final opt = e.value;
          final isExpanded = _expandedTransport.contains(idx);
          return _TransportCard(
            option: opt,
            locale: locale,
            l10n: l10n,
            accentColor: city.accentColor,
            isDark: isDark,
            isExpanded: isExpanded,
            onToggle: () {
              HapticFeedback.selectionClick();
              setState(() {
                if (isExpanded) {
                  _expandedTransport.remove(idx);
                } else {
                  _expandedTransport.add(idx);
                }
              });
            },
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Section Header ────────────────────────────────────────────────────────────

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: city.accentColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? AppTheme.darkPrimary : city.gradientColors.first,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Transport Card
// ═══════════════════════════════════════════════════════════════════════════════

class _TransportCard extends StatelessWidget {
  final TransportOption option;
  final String locale;
  final AppLocalizations l10n;
  final Color accentColor;
  final bool isDark;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _TransportCard({
    required this.option,
    required this.locale,
    required this.l10n,
    required this.accentColor,
    required this.isDark,
    required this.isExpanded,
    required this.onToggle,
  });

  IconData get _modeIcon => switch (option.mode) {
        TransportMode.flight => Icons.flight_rounded,
        TransportMode.sleeperTrain => Icons.nightlight_round,
        TransportMode.train => Icons.train_rounded,
        TransportMode.bus => Icons.directions_bus_rounded,
        TransportMode.car => Icons.drive_eta_rounded,
        TransportMode.nileCruise => Icons.sailing_rounded,
        TransportMode.busFromSharm => Icons.airport_shuttle_rounded,
      };

  String _modeLabel(AppLocalizations l10n) => switch (option.mode) {
        TransportMode.flight => l10n.transportFlight,
        TransportMode.sleeperTrain => l10n.transportSleeperTrain,
        TransportMode.train => l10n.transportTrain,
        TransportMode.bus => l10n.transportBus,
        TransportMode.car => l10n.transportCar,
        TransportMode.nileCruise => l10n.transportNileCruise,
        TransportMode.busFromSharm => l10n.transportBusFromSharm,
      };

  @override
  Widget build(BuildContext context) {
    final hasApps = option.apps.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded
                ? accentColor.withOpacity(0.45)
                : (isDark
                    ? AppTheme.darkBorder
                    : const Color(0xFFE0E8EA)),
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // ── Header row ──────────────────────────────────────────────
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: hasApps ? onToggle : null,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Mode icon badge
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_modeIcon, size: 20, color: accentColor),
                    ),
                    const SizedBox(width: 12),
                    // Mode label + time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _modeLabel(l10n),
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppTheme.darkText
                                  : AppTheme.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  option.time(locale),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppTheme.darkTextSub
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Expand chevron
                    if (hasApps)
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: isDark
                              ? AppTheme.darkTextTertiary
                              : Colors.grey.shade400,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // ── App links ─────────────────────────────────────────────────
            if (hasApps && isExpanded) ...[
              Divider(
                height: 1,
                color: isDark ? AppTheme.darkBorder : const Color(0xFFEEF2F3),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bookTicketsTitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.darkTextSub
                            : Colors.grey.shade600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...option.apps.map(
                      (app) => _AppRow(
                        app: app,
                        l10n: l10n,
                        accentColor: accentColor,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// App Store Row
// ═══════════════════════════════════════════════════════════════════════════════

class _AppRow extends StatelessWidget {
  final TransportApp app;
  final AppLocalizations l10n;
  final Color accentColor;
  final bool isDark;

  const _AppRow({
    required this.app,
    required this.l10n,
    required this.accentColor,
    required this.isDark,
  });

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          // App name
          Expanded(
            child: Text(
              app.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Store buttons
          Row(
            children: [
              if (app.androidUrl != null)
                _StoreButton(
                  label: l10n.getOnPlayStore,
                  icon: Icons.android_rounded,
                  color: const Color(0xFF3DDC84),
                  onTap: () => _launch(app.androidUrl!),
                  isDark: isDark,
                ),
              if (app.androidUrl != null && app.iosUrl != null)
                const SizedBox(width: 6),
              if (app.iosUrl != null)
                _StoreButton(
                  label: l10n.getOnAppStore,
                  icon: Icons.apple_rounded,
                  color: accentColor,
                  onTap: () => _launch(app.iosUrl!),
                  isDark: isDark,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _StoreButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Place Card (grid item)
// ═══════════════════════════════════════════════════════════════════════════════

class _PlaceCard extends StatelessWidget {
  final CityPlace place;
  final String locale;
  final Color accentColor;

  const _PlaceCard({
    required this.place,
    required this.locale,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    place.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: accentColor.withOpacity(0.15),
                      child: Icon(Icons.image_not_supported_rounded,
                          color: accentColor.withOpacity(0.4), size: 32),
                    ),
                  ),
                  // Bottom gradient
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black45, Colors.transparent],
                        stops: [0.0, 0.6],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Name
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Text(
                place.name(locale),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale =
        AppLocalizations.of(context)?.locale ?? 'en';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  place.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: accentColor.withOpacity(0.1),
                    child: Icon(Icons.image_not_supported_rounded,
                        color: accentColor.withOpacity(0.4), size: 40),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              place.name(locale),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color:
                    isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              place.desc(locale),
              style: TextStyle(
                fontSize: 13.5,
                height: 1.6,
                color: isDark
                    ? AppTheme.darkTextSub
                    : AppTheme.lightBodyText,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
