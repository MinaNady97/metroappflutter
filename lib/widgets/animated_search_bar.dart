import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AnimatedSearchBar extends StatefulWidget {
  final String hint;
  final IconData icon;
  final List<String> suggestions;
  final ValueChanged<String> onSelected;
  final String selectedText;

  const AnimatedSearchBar({
    super.key,
    required this.hint,
    required this.icon,
    required this.suggestions,
    required this.onSelected,
    this.selectedText = '',
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final RxBool isExpanded = false.obs;
  final RxList<String> filteredSuggestions = <String>[].obs;
  bool _flashHighlight = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    filteredSuggestions.assignAll(widget.suggestions);
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChanged);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      isExpanded.value = true;
    } else {
      Future<void>.delayed(const Duration(milliseconds: 120), () {
        if (mounted) isExpanded.value = false;
      });
    }
  }

  void _onTextChanged() {
    final query = _controller.text.toLowerCase().trim();
    if (query.isEmpty) {
      filteredSuggestions.assignAll(widget.suggestions);
      return;
    }
    filteredSuggestions.assignAll(
      widget.suggestions.where((s) => s.toLowerCase().contains(query)),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedText != widget.selectedText &&
        widget.selectedText != _controller.text) {
      _controller.text = widget.selectedText;
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
      if (widget.selectedText.isNotEmpty) {
        _triggerHighlightFlash();
      }
      setState(() {});
    }
  }

  void _triggerHighlightFlash() {
    _flashHighlight = true;
    if (mounted) setState(() {});
    Future<void>.delayed(const Duration(milliseconds: 360), () {
      if (!mounted) return;
      _flashHighlight = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _flashHighlight ? const Color(0xFFE8F7EF) : Colors.transparent,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: Icon(widget.icon),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        widget.onSelected('');
                        HapticFeedback.lightImpact();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Obx(
          () => AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: isExpanded.value && filteredSuggestions.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxHeight: 220),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredSuggestions.length,
                      itemBuilder: (_, index) {
                        final suggestion = filteredSuggestions[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: Text(suggestion),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            widget.onSelected(suggestion);
                            _controller.text = suggestion;
                            _focusNode.unfocus();
                          },
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
