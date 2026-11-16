import 'package:material_ui/material_ui.dart';

import '../theme/expressive_theme.dart';

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
    this.borderRadius,
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

  /// Defaults to the theme's `radius.xxl`.
  final double? borderRadius;
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
    final tokens = ExpressiveTheme.of(context);
    final radius = widget.borderRadius ?? tokens.radius.xxl;

    return AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      width: _expanded ? widget.expandedWidth : widget.collapsedWidth,
      height: 56,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: _expanded
          ? Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: tokens.spacing.lg),
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
                    autofocus: widget.autoFocus,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: tokens.spacing.md,
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
              borderRadius: BorderRadius.circular(radius),
              child: Center(
                child: Icon(Icons.search, color: scheme.onSurfaceVariant),
              ),
            ),
    );
  }
}
