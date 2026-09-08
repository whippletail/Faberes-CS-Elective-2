import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../utils/currency_formatter.dart';
import '../widgets/cart_action.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.cart,
  });

  final String productId;
  final CartController cart;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  bool _justAdded = false;

  Product? get _product {
    for (final product in products) {
      if (product.id == widget.productId) {
        return product;
      }
    }

    return null;
  }

void _addToCart(Product product) {
  widget.cart.add(
    product,
    quantity: _quantity,
  );

  setState(() {
    _justAdded = true;
  });

  final messenger = ScaffoldMessenger.of(context);

  messenger.removeCurrentSnackBar();

  messenger.showSnackBar(
    SnackBar(
      content: Text(
        '$_quantity ${product.name} added to your cart.',
      ),
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final product = _product;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('PRODUCT NOT FOUND'),
        ),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('BACK TO SHOP'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('BOARD DETAILS'),
        actions: [
          CartAction(cart: widget.cart),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth >= 760;

          final productImage = _ProductImage(
            product: product,
          );

          final productInformation = _ProductInfo(
            product: product,
            quantity: _quantity,
            justAdded: _justAdded,
            onDecrement: () {
              setState(() {
                if (_quantity > 1) {
                  _quantity--;
                }

                _justAdded = false;
              });
            },
            onIncrement: () {
              setState(() {
                _quantity++;
                _justAdded = false;
              });
            },
            onAdd: () {
              _addToCart(product);
            },
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              isWideScreen ? 40 : 18,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1180,
                ),
                child: isWideScreen
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: productImage,
                          ),
                          const SizedBox(width: 44),
                          Expanded(
                            child: productInformation,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          productImage,
                          const SizedBox(height: 24),
                          productInformation,
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final selectedImage = isDarkMode
        ? product.darkImageAsset
        : product.imageAsset;

    return Card(
      child: AspectRatio(
        aspectRatio: 1.05,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              selectedImage,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Chip(
                avatar: const Icon(
                  Icons.waves_rounded,
                  size: 18,
                ),
                label: Text(product.badge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({
    required this.product,
    required this.quantity,
    required this.justAdded,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAdd,
  });

  final Product product;
  final int quantity;
  final bool justAdded;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: colors.tertiary,
            ),
            const SizedBox(width: 5),
            Text('${product.rating} / 5'),
            const Spacer(),
            Text(
              product.badge,
              style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Text(
          product.name,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),

        Text(
          product.tagline,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 20),

        Text(
          formatPhp(product.price),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colors.primary,
              ),
        ),
        const SizedBox(height: 22),

        Text(
          product.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 22),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _Spec(
              icon: Icons.straighten_rounded,
              label: product.length,
            ),
            _Spec(
              icon: Icons.speed_rounded,
              label: product.skillLevel,
            ),
            const _Spec(
              icon: Icons.shield_outlined,
              label: '1-year warranty',
            ),
          ],
        ),
        const SizedBox(height: 28),

        Text(
          'QUANTITY',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            IconButton.filledTonal(
              onPressed: quantity > 1 ? onDecrement : null,
              icon: const Icon(Icons.remove_rounded),
            ),
            SizedBox(
              width: 52,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton.filledTonal(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 22),

        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onAdd,
            icon: Icon(
              justAdded
                  ? Icons.check_rounded
                  : Icons.shopping_bag_outlined,
            ),
            label: Text(
              justAdded
                  ? 'ADDED TO CART'
                  : 'ADD TO CART',
            ),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/cart'),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('VIEW CART'),
          ),
        ),
      ],
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
      ),
      label: Text(label),
    );
  }
}