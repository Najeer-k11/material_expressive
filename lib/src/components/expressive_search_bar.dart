import 'package:flutter/material.dart';

/// An expressive search bar that morphs from collapsed to expanded with spring.
class ExpressiveSearchBar extends StatefulWidget {
  const ExpressiveSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.leading,
    this.trailing,
    this.collapsedWidth = 56,
    this.expandedWidth = double.infinity,
    this.borderRadius = 28,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
    this.autoFocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final Widget? leading;
  final List<Widget>? trailing;
  final double collapsedWidth;
  final double expandedWidth;
  final double borderRadius;
  final Duration duration;
  final Curve curve;
  final bool autoFocus;

  @override
  State<ExpressiveSearchBar> createState() => _ExpressiveSearchBarState();
}

class _ExpressiveSearchBarState extends State<ExpressiveSearchBar> {
  var _expanded = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _expanded = widget.autoFocus;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _expanded) {
        final text = widget.controller?.text ?? '';
        if (text.isEmpty) {
          setState(() => _expanded = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _expand() {
    setState(() => _expanded = true);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      width: _expanded ? widget.expandedWidth : widget.collapsedWidth,
      height: 56,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: _expanded
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child:
                      widget.leading ??
                      Icon(Icons.search, color: scheme.onSurfaceVariant),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                if (widget.trailing != null) ...widget.trailing!,
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.controller?.clear();
                    widget.onChanged?.call('');
                    setState(() => _expanded = false);
                    _focusNode.unfocus();
                  },
                ),
              ],
            )
          : InkWell(
              onTap: () {
                _expand();
                widget.onTap?.call();
              },
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Center(
                child: Icon(Icons.search, color: scheme.onSurfaceVariant),
              ),
            ),
    );
  }
}
