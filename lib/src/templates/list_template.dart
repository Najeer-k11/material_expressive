import 'package:flutter/material.dart';
import '../core/layout_helpers.dart';

class ListTemplate extends StatelessWidget {
  const ListTemplate({
    super.key,
    required this.title,
    this.sections = const [],
    this.items = const [],
    this.floatingActionButton,
    this.actions = const [],
    this.onRefresh,
  });
  final String title;
  final List<ListSection> sections;
  final List<Widget> items;
  final Widget? floatingActionButton;
  final List<Widget> actions;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    Widget body = ContentWidth(
      child: sections.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: sections.length,
              itemBuilder: (_, i) => sections[i],
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: items.length,
              itemBuilder: (_, i) => items[i],
            ),
    );
    if (onRefresh != null) {
      body = RefreshIndicator(onRefresh: onRefresh!, child: body);
    }
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    this.title,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 0),
  });
  final String? title;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Card(child: Column(children: children)),
        ],
      ),
    );
  }
}
