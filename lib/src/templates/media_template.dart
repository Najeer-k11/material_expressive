import 'package:flutter/material.dart';
import '../core/layout_helpers.dart';

class MediaTemplate extends StatelessWidget {
  const MediaTemplate({
    super.key,
    required this.heroImage,
    required this.title,
    this.subtitle,
    this.metadata,
    this.actions = const [],
    this.content = const [],
    this.relatedItems = const [],
    this.relatedTitle = 'Related',
  });

  final Widget heroImage;
  final String title;
  final String? subtitle;
  final String? metadata;
  final List<Widget> actions;
  final List<Widget> content;
  final List<Widget> relatedItems;
  final String relatedTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(background: heroImage),
          ),
          SliverToBoxAdapter(
            child: ContentWidth(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (metadata != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        metadata!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (actions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(spacing: 8, runSpacing: 8, children: actions),
                    ],
                    if (content.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      ...content,
                    ],
                    if (relatedItems.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Text(relatedTitle, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (relatedItems.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: relatedItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => relatedItems[i],
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
