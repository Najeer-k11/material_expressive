import 'package:flutter/material.dart';
import '../core/layout_helpers.dart';

class SearchTemplate extends StatelessWidget {
  const SearchTemplate({
    super.key,
    required this.searchController,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.suggestions = const [],
    this.results = const [],
    this.leading,
    this.trailing,
    this.isLoading = false,
  });

  final TextEditingController searchController;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<Widget> suggestions;
  final List<Widget> results;
  final Widget? leading;
  final List<Widget>? trailing;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ContentWidth(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBar(
                  controller: searchController,
                  hintText: hintText,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  leading: leading ?? const Icon(Icons.search),
                  trailing: trailing,
                ),
              ),
              if (isLoading) const LinearProgressIndicator(),
              Expanded(
                child: results.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: results.length,
                        itemBuilder: (_, i) => results[i],
                      )
                    : suggestions.isNotEmpty
                    ? ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 16,
                              bottom: 8,
                            ),
                            child: Text(
                              'Suggestions',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          ...suggestions,
                        ],
                      )
                    : Center(
                        child: Text(
                          'Start typing to search',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
