import 'package:flutter/material.dart';
import '../core/layout_helpers.dart';

class ProfileTemplate extends StatelessWidget {
  const ProfileTemplate({
    super.key,
    required this.avatar,
    required this.name,
    this.subtitle,
    this.coverImage,
    this.actions = const [],
    this.stats = const [],
    this.content = const [],
  });

  final Widget avatar;
  final String name;
  final String? subtitle;
  final Widget? coverImage;
  final List<Widget> actions;
  final List<ProfileStat> stats;
  final List<Widget> content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: coverImage != null ? 200 : 0,
            pinned: true,
            flexibleSpace: coverImage != null
                ? FlexibleSpaceBar(background: coverImage!)
                : null,
          ),
          SliverToBoxAdapter(
            child: ContentWidth(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Transform.translate(
                      offset: coverImage != null
                          ? const Offset(0, -40)
                          : Offset.zero,
                      child: Column(
                        children: [
                          avatar,
                          const SizedBox(height: 16),
                          Text(
                            name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          if (stats.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  stats
                                      .expand(
                                        (s) => [s, const SizedBox(width: 32)],
                                      )
                                      .toList()
                                    ..removeLast(),
                            ),
                          ],
                          if (actions.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  actions
                                      .expand(
                                        (a) => [a, const SizedBox(width: 12)],
                                      )
                                      .toList()
                                    ..removeLast(),
                            ),
                          ],
                        ],
                      ),
                    ),
                    ...content,
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

class ProfileStat extends StatelessWidget {
  const ProfileStat({super.key, required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
