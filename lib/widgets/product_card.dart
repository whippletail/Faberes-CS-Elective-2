import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../utils/currency_formatter.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final selectedImage = isDarkMode
        ? product.darkImageAsset
        : product.imageAsset;

    return Card(
      child: InkWell(
        onTap: () {
          context.go('/products/${product.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    selectedImage,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        child: Text(
                          product.badge,
                          style: TextStyle(
                            color: colors.onSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 18,
                              ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        product.tagline,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: colors.tertiary,
                        ),
                        const SizedBox(width: 3),
                        Text('${product.rating}'),
                        const Spacer(),

                        // Price with comma formatting
                        Text(
                          formatPhp(product.price),
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}