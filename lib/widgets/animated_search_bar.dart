import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AnimatedSearchBar  — tap-to-open bottom-sheet station picker
// ─────────────────────────────────────────────────────────────────────────────

class AnimatedSearchBar extends StatefulWidget {
  final String hint;
  final IconData icon;
  final List<String> suggestions;
  final ValueChanged<String> onSelected;
  final String selectedText;
  final Map<String, List<String>>? stationLines;

  /// Maximum height of the dropdown list in logical pixels (unused now, kept
  /// for API compat).
  final double maxDropdownHeight;

  const AnimatedSearchBar({
    super.key,
    required this.hint,
    required this.icon,
    required this.suggestions,
    required this.onSelected,
    this.selectedText = '',
    this.stationLines,
    this.maxDropdownHeight = 320,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _flashHighlight = false;

  // ── External update ───────────────────────────────────────────────────────

  @override
  void didUpdateWidget(covariant AnimatedSearchBar old) {
    super.didUpdateWidget(old);
    if (old.selectedText != widget.selectedText &&
        widget.selectedText.isNotEmpty) {
      _flash();
    }
  }

  // ── Open bottom sheet ─────────────────────────────────────────────────────

  Future<void> _openSearch() async {
    HapticFeedback.selectionClick();
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _StationSearchSheet(
        suggestions: widget.suggestions,
        stationLines: widget.stationLines,
        selectedText: widget.selectedText,
        hint: widget.hint,
        icon: widget.icon,
      ),
    );
    if (result != null && mounted) {
      widget.onSelected(result);
      _flash();
    }
  }

  void _flash() {
    _flashHighlight = true;
    if (mounted) setState(() {});
    Future<void>.delayed(const Duration(milliseconds: 380), () {
      if (!mounted) return;
      _flashHighlight = false;
      setState(() {});
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.selectedText.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    if (_flashHighlight) {
      bgColor = isDark ? AppTheme.darkFlashHighlight : const Color(0xFFE8F7EF);
    } else if (hasValue) {
      bgColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    } else {
      bgColor = isDark ? AppTheme.darkSurface : AppTheme.lightSubtle;
    }

    return GestureDetector(
      onTap: _openSearch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: bgColor,
          border: Border.all(
            color: hasValue
                ? AppTheme.primaryNile
                : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            width: hasValue ? 1.5 : 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 13),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  widget.icon,
                  size: 17,
                  color: hasValue
                      ? AppTheme.primaryNile
                      : (isDark
                          ? AppTheme.darkTextTertiary
                          : Colors.grey.shade400),
                ),
              ),
              Expanded(
                child: Text(
                  hasValue ? widget.selectedText : widget.hint,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                    color: hasValue
                        ? (isDark
                            ? AppTheme.darkPrimary
                            : AppTheme.primaryNile)
                        : (isDark
                            ? AppTheme.darkTextTertiary
                            : Colors.grey.shade400),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasValue)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onSelected('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.close_rounded,
                        size: 16,
                        color: isDark
                            ? AppTheme.darkTextTertiary
                            : Colors.grey.shade400),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Bottom-sheet station picker
// ═══════════════════════════════════════════════════════════════════════════════

class _StationSearchSheet extends StatefulWidget {
  final List<String> suggestions;
  final Map<String, List<String>>? stationLines;
  final String selectedText;
  final String hint;
  final IconData icon;

  const _StationSearchSheet({
    required this.suggestions,
    this.stationLines,
    required this.selectedText,
    required this.hint,
    required this.icon,
  });

  @override
  State<_StationSearchSheet> createState() => _StationSearchSheetState();
}

class _StationSearchSheetState extends State<_StationSearchSheet> {
  late final TextEditingController _searchCtrl;
  late final FocusNode _searchFocus;
  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _searchFocus = FocusNode();
    _filtered = List.from(widget.suggestions);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _filter(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      _filtered = q.isEmpty
          ? List.from(widget.suggestions)
          : widget.suggestions
              .where((s) => s.toLowerCase().contains(q))
              .toList();
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppTheme.darkSurface : AppTheme.lightCard;

    return GestureDetector(
      // Dismiss keyboard if user taps blank area inside sheet
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        // Constrain to at most 75 % of screen, adjust for keyboard
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * 0.75,
        ),
        padding: EdgeInsets.only(bottom: bottomInset),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),
            _searchField(),
            if (_filtered.isEmpty) _emptyState() else _stationList(),
          ],
        ),
      ),
    );
  }

  // ── Drag handle ───────────────────────────────────────────────────────────

  Widget _handle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkBorder : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  // ── Search field ──────────────────────────────────────────────────────────

  Widget _searchField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: _searchCtrl,
        focusNode: _searchFocus,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? AppTheme.darkPrimary : const Color(0xFF1A535C),
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark ? AppTheme.darkTextTertiary : Colors.grey.shade400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(widget.icon, size: 18, color: AppTheme.primaryNile),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 42, minHeight: 0),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 16,
                      color: isDark
                          ? AppTheme.darkTextTertiary
                          : Colors.grey.shade400),
                  onPressed: () {
                    _searchCtrl.clear();
                    _filter('');
                  },
                )
              : null,
          filled: true,
          fillColor:
              isDark ? AppTheme.darkElevated : AppTheme.lightSubtle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark
                  ? AppTheme.darkBorder
                  : AppTheme.lightBorder,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppTheme.primaryNile, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 13),
        ),
        onChanged: (v) {
          _filter(v);
          setState(() {}); // update suffix icon
        },
      ),
    );
  }

  // ── Station list ──────────────────────────────────────────────────────────

  Widget _stationList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        itemCount: _filtered.length,
        itemBuilder: (_, i) => _buildItem(_filtered[i]),
      ),
    );
  }

  Widget _buildItem(String name) {
    final isSelected = name == widget.selectedText;
    final lines = widget.stationLines?[name] ?? <String>[];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context, name);
      },
      splashColor: AppTheme.primaryNile.withOpacity(0.08),
      highlightColor: AppTheme.primaryNile.withOpacity(0.05),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        color: isSelected
            ? AppTheme.primaryNile.withOpacity(isDark ? 0.15 : 0.07)
            : null,
        child: Row(
          children: [
            _buildLineIndicator(lines, isSelected),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primaryNile
                      : (isDark
                          ? AppTheme.darkTextSub
                          : AppTheme.lightStationText),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(Icons.check_rounded,
                  size: 16, color: AppTheme.primaryNile),
            ],
          ],
        ),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _emptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 40,
                  color: isDark
                      ? AppTheme.darkBorder
                      : Colors.grey.shade300),
              const SizedBox(height: 8),
              Text(
                'No stations found',
                style: TextStyle(
                    color: isDark
                        ? AppTheme.darkTextTertiary
                        : Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Line indicator ────────────────────────────────────────────────────────

  Widget _buildLineIndicator(List<String> lines, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (lines.isEmpty) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryNile.withOpacity(0.14)
              : (isDark ? AppTheme.darkElevated : const Color(0xFFF0F5F6)),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.directions_subway_rounded,
          size: 14,
          color: isSelected
              ? AppTheme.primaryNile
              : (isDark ? AppTheme.darkTextTertiary : Colors.grey.shade500),
        ),
      );
    }

    if (lines.length == 1) {
      return _lineCircle(lines[0], 30);
    }

    const size = 24.0;
    const shift = 14.0;
    final totalW = size + (lines.length - 1) * shift;
    final borderColor =
        isDark ? AppTheme.darkSurface : AppTheme.lightCard;

    return SizedBox(
      width: totalW,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(lines.length, (i) {
          return Positioned(
            left: i * shift,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: _lineCircle(lines[i], size),
            ),
          );
        }),
      ),
    );
  }

  Widget _lineCircle(String line, double size) {
    final color = _lineColor(line);
    final isLrt = line == 'LRT';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          isLrt ? 'L' : line,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * (isLrt ? 0.33 : 0.40),
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1,
          ),
        ),
      ),
    );
  }

  Color _lineColor(String line) => switch (line) {
        '1' => AppTheme.line1,
        '2' => AppTheme.line2,
        '3' => AppTheme.line3,
        'LRT' => AppTheme.lrt,
        _ => AppTheme.primaryNile,
      };
}
