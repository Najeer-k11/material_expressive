import 'package:flutter/material.dart';
import '../core/layout_helpers.dart';

class ProductDetailTemplate extends StatelessWidget {
  const ProductDetailTemplate({
    super.key,
    required this.images,
    required this.title,
    required this.price,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    this.description,
    this.specifications = const [],
    this.addToCartButton,
    this.buyNowButton,
  });

  final List<Widget> images;
  final String title;
  final String price;
  final String? originalPrice;
  final double? rating;
  final int? reviewCount;
  final String? description;
  final List<Widget> specifications;
  final Widget? addToCartButton;
  final Widget? buyNowButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: images.length == 1
                  ? images.first
                  : PageView(children: images),
            ),
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
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          price,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.primary,
                          ),
                        ),
                        if (originalPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            originalPrice!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (rating != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              rating! >= i + 1
                                  ? Icons.star
                                  : rating! >= i + 0.5
                                  ? Icons.star_half
                                  : Icons.star_border,
                              size: 18,
                              color: Colors.amber[700],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            rating!.toStringAsFixed(1),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (reviewCount != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '($reviewCount reviews)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    if (description != null) ...[
                      const SizedBox(height: 20),
                      Text(description!, style: theme.textTheme.bodyLarge),
                    ],
                    if (specifications.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Specifications',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...specifications,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: (addToCartButton != null || buyNowButton != null)
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (addToCartButton != null)
                      Expanded(child: addToCartButton!),
                    if (addToCartButton != null && buyNowButton != null)
                      const SizedBox(width: 12),
                    if (buyNowButton != null) Expanded(child: buyNowButton!),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
