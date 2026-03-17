import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:metroappflutter/Controllers/languagecontroller.dart';
import 'package:metroappflutter/Pages/homepage.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

// ── Entry-point helpers ───────────────────────────────────────────────────────

const _kDoneKey = 'onboarding_done';

Future<bool> isOnboardingDone() async {
  final p = await SharedPreferences.getInstance();
  return p.getBool(_kDoneKey) ?? false;
}

Future<void> markOnboardingDone() async {
  final p = await SharedPreferences.getInstance();
  await p.setBool(_kDoneKey, true);
}

// ── Language metadata ─────────────────────────────────────────────────────────

class _Lang {
  final String code;
  final String label;
  final String native;
  const _Lang(this.code, this.label, this.native);
}

const _langs = [
  _Lang('en', 'English',    'English'),
  _Lang('ar', 'Arabic',     'العربية'),
  _Lang('fr', 'French',     'Français'),
  _Lang('de', 'German',     'Deutsch'),
  _Lang('es', 'Spanish',    'Español'),
  _Lang('it', 'Italian',    'Italiano'),
  _Lang('pt', 'Portuguese', 'Português'),
  _Lang('ru', 'Russian',    'Русский'),
  _Lang('zh', 'Chinese',    '中文'),
  _Lang('tr', 'Turkish',    'Türkçe'),
  _Lang('ja', 'Japanese',   '日本語'),
];

// ── Main widget ───────────────────────────────────────────────────────────────

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _page = 0;

  // Fade-in controller for page content
  late final AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 420));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _next() {
    HapticFeedback.selectionClick();
    if (_page < 2) {
      _fadeCtrl.reset();
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 380), curve: Curves.easeInOut);
      _fadeCtrl.forward();
    } else {
      _finish();
    }
  }

  void _finish() async {
    await markOnboardingDone();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => Homepage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _showLanguagePicker() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _LanguagePicker(
        onSelected: (code) {
          Get.find<LanguageController>().switchLanguage(code);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = l10n.locale == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.darkBackground : AppTheme.backgroundSand,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: language + skip ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  // Language picker button
                  _TopButton(
                    icon: Icons.language_rounded,
                    label: l10n.onboardingLanguagePrompt,
                    onTap: _showLanguagePicker,
                    isDark: isDark,
                  ),
                  const Spacer(),
                  // Skip button (hidden on last page)
                  if (_page < 2)
                    _TopButton(
                      icon: null,
                      label: l10n.onboardingSkip,
                      onTap: _finish,
                      isDark: isDark,
                    ),
                ],
              ),
            ),

            // ── PageView ──────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (p) {
                  _fadeCtrl.reset();
                  _fadeCtrl.forward();
                  setState(() => _page = p);
                },
                children: [
                  _OnboardingStep(
                    fadeAnim: _fadeAnim,
                    illustration: const _IllustrationRoute(),
                    title: l10n.onboardingTitle1,
                    subtitle: l10n.onboardingSubtitle1,
                    isAr: isAr,
                    isDark: isDark,
                  ),
                  _OnboardingStep(
                    fadeAnim: _fadeAnim,
                    illustration: _IllustrationLines(l10n: l10n),
                    title: l10n.onboardingTitle2,
                    subtitle: l10n.onboardingSubtitle2,
                    isAr: isAr,
                    isDark: isDark,
                  ),
                  _OnboardingStep(
                    fadeAnim: _fadeAnim,
                    illustration: _IllustrationActions(l10n: l10n),
                    title: l10n.onboardingTitle3,
                    subtitle: l10n.onboardingSubtitle3,
                    isAr: isAr,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            // ── Dot indicators ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _page == i
                          ? AppTheme.primaryNile
                          : (isDark
                              ? AppTheme.darkBorder
                              : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // ── CTA button ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: ElevatedButton(
                    key: ValueKey(_page),
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryNile,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _page == 2
                              ? l10n.onboardingGetStarted
                              : l10n.onboardingNext,
                        ),
                        if (_page < 2) ...[
                          const SizedBox(width: 8),
                          Icon(
                            isAr
                                ? Icons.arrow_back_rounded
                                : Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single onboarding step ────────────────────────────────────────────────────

class _OnboardingStep extends StatelessWidget {
  final Animation<double> fadeAnim;
  final Widget illustration;
  final String title;
  final String subtitle;
  final bool isAr;
  final bool isDark;

  const _OnboardingStep({
    required this.fadeAnim,
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.isAr,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Illustration area
            Expanded(
              flex: 5,
              child: Center(child: illustration),
            ),
            // Text area
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: isAr
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppTheme.darkText
                          : AppTheme.lightTextPrimary,
                      height: 1.2,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subtitle,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: isDark
                          ? AppTheme.darkTextSub
                          : AppTheme.lightBodyText,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top bar button ─────────────────────────────────────────────────────────────

class _TopButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _TopButton(
      {required this.icon,
      required this.label,
      required this.onTap,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.darkElevated
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : Colors.grey.shade200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15,
                  color: isDark ? AppTheme.darkTextSub : AppTheme.primaryNile),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkTextSub : AppTheme.primaryNile,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Illustration 1: Route planner ─────────────────────────────────────────────

class _IllustrationRoute extends StatelessWidget {
  const _IllustrationRoute();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final borderColor = isDark ? AppTheme.darkBorder : Colors.grey.shade100;

    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mock planner card
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryNile.withOpacity(isDark ? 0.08 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Departure row
                _StationRow(
                  icon: Icons.radio_button_on_rounded,
                  color: AppTheme.primaryNile,
                  label: 'Adly Mansour',
                  isDark: isDark,
                  borderColor: borderColor,
                ),
                // Connector
                Padding(
                  padding: const EdgeInsets.only(left: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      3,
                      (_) => Container(
                        width: 2,
                        height: 6,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        color: isDark
                            ? AppTheme.darkBorder
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                // Arrival row
                _StationRow(
                  icon: Icons.location_on_rounded,
                  color: AppTheme.line2,
                  label: 'Sadat',
                  isDark: isDark,
                  borderColor: borderColor,
                ),
                const SizedBox(height: 16),
                // Route summary chips
                Row(
                  children: [
                    _SummaryChip(
                        icon: Icons.train_rounded,
                        label: '14 stops',
                        color: AppTheme.primaryNile,
                        isDark: isDark),
                    const SizedBox(width: 8),
                    _SummaryChip(
                        icon: Icons.access_time_rounded,
                        label: '42 min',
                        color: AppTheme.line3,
                        isDark: isDark),
                    const SizedBox(width: 8),
                    _SummaryChip(
                        icon: Icons.payments_rounded,
                        label: '10 EGP',
                        color: AppTheme.accentGold,
                        isDark: isDark),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StationRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool isDark;
  final Color borderColor;

  const _StationRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkElevated : const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _SummaryChip(
      {required this.icon,
      required this.label,
      required this.color,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Illustration 2: Metro lines ───────────────────────────────────────────────

class _IllustrationLines extends StatelessWidget {
  final AppLocalizations l10n;
  const _IllustrationLines({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LineRow(
            color: AppTheme.line1,
            label: l10n.onboardingLine1,
            showTransfer: false,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _LineRow(
            color: AppTheme.line2,
            label: l10n.onboardingLine2,
            showTransfer: true,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _LineRow(
            color: AppTheme.line3,
            label: l10n.onboardingLine3,
            showTransfer: true,
            isDark: isDark,
          ),
          const SizedBox(height: 24),
          // Transfer legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppTheme.darkCard : Colors.white,
                  border: Border.all(
                      color: AppTheme.primaryNile.withOpacity(0.6), width: 2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.onboardingTransfer,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.darkTextSub : AppTheme.lightBodyText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  final Color color;
  final String label;
  final bool showTransfer;
  final bool isDark;

  const _LineRow({
    required this.color,
    required this.label,
    required this.showTransfer,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Station dot start
        _Dot(color: color, isDark: isDark, transfer: false),
        // Track line
        Expanded(
          child: Container(height: 4, color: color),
        ),
        // Transfer dot (mid) if applicable
        if (showTransfer) ...[
          _Dot(color: color, isDark: isDark, transfer: true),
          Expanded(child: Container(height: 4, color: color)),
        ],
        // Station dot end
        _Dot(color: color, isDark: isDark, transfer: false),
        const SizedBox(width: 12),
        // Line label
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.darkTextSub : AppTheme.lightBodyText,
            ),
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final bool isDark;
  final bool transfer;

  const _Dot(
      {required this.color, required this.isDark, required this.transfer});

  @override
  Widget build(BuildContext context) {
    if (transfer) {
      // Transfer: white circle with color border
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppTheme.darkCard : Colors.white,
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 1)
          ],
        ),
      );
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ── Illustration 3: Quick actions ─────────────────────────────────────────────

class _IllustrationActions extends StatelessWidget {
  final AppLocalizations l10n;
  const _IllustrationActions({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Row(
        children: [
          _ActionCard(
            icon: Icons.near_me_rounded,
            label: l10n.nearestStationLabel,
            color: AppTheme.primaryNile,
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _ActionCard(
            icon: Icons.map_rounded,
            label: l10n.metroMapLabel,
            color: AppTheme.line3,
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _ActionCard(
            icon: Icons.place_rounded,
            label: l10n.touristGuideTitle,
            color: AppTheme.accentGold,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
                  height: 1.3,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Language picker sheet ─────────────────────────────────────────────────────

class _LanguagePicker extends StatelessWidget {
  final ValueChanged<String> onSelected;
  const _LanguagePicker({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final current = l10n.locale;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBorder : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Text(
              l10n.onboardingLanguagePrompt,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.darkText : AppTheme.lightTextPrimary,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          const Divider(height: 1),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _langs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (_, i) {
                final lang = _langs[i];
                final isActive = lang.code == current;
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  leading: Text(
                    lang.native,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? AppTheme.primaryNile
                          : (isDark
                              ? AppTheme.darkText
                              : AppTheme.lightTextPrimary),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  title: Text(
                    lang.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppTheme.darkTextSub
                          : AppTheme.lightBodyText,
                    ),
                  ),
                  trailing: isActive
                      ? Icon(Icons.check_circle_rounded,
                          color: AppTheme.primaryNile, size: 20)
                      : null,
                  onTap: () => onSelected(lang.code),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
