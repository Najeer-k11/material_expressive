import 'package:flutter/material.dart';
import '../core/layout_helpers.dart';

class DashboardTemplate extends StatelessWidget {
  const DashboardTemplate({
    super.key,
    required this.title,
    this.greeting,
    this.actions = const [],
    required this.cards,
    this.bottomNavItems,
    this.floatingActionButton,
  });

  final String title;
  final String? greeting;
  final List<Widget> actions;
  final List<Widget> cards;
  final List<BottomNavigationBarItem>? bottomNavItems;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1200
        ? 4
        : w >= 840
        ? 3
        : w >= 600
        ? 2
        : 1;
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: ContentWidth(
        maxWidth: 1400,
        child: CustomScrollView(
          slivers: [
            if (greeting != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Text(greeting!, style: theme.textTheme.headlineSmall),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: cols == 1 ? 2.0 : 1.4,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => cards[i],
                  childCount: cards.length,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavItems != null
          ? NavigationBar(
              destinations: bottomNavItems!
                  .map(
                    (i) => NavigationDestination(
                      icon: i.icon,
                      label: i.label ?? '',
                      selectedIcon: i.activeIcon,
                    ),
                  )
                  .toList(),
            )
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}

class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.trend,
    this.trendPositive,
    this.onTap,
  });
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final String? trend;
  final bool? trendPositive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: scheme.primary),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (trend != null || subtitle != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (trend != null) ...[
                      Icon(
                        trendPositive == true
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 16,
                        color: trendPositive == true
                            ? Colors.green
                            : scheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: trendPositive == true
                              ? Colors.green
                              : scheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (subtitle != null) ...[
                      if (trend != null) const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
