import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/cart_controller.dart';
import '../models/cart_item.dart';
import '../utils/currency_formatter.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
    required this.cart,
  });

  final CartController cart;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    widget.cart.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.cart.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('YOUR CART'),
      ),
      body: widget.cart.isEmpty
          ? const _EmptyCart()
          : _CartContent(cart: widget.cart),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 84,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              'Your cart is waiting for a wave.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a board from the collection to get started.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.storefront_rounded),
              label: const Text('EXPLORE BOARDS'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent({
    required this.cart,
  });

  final CartController cart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 850;

        final cartItems = Column(
          children: cart.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _CartItemCard(
                item: item,
                cart: cart,
              ),
            );
          }).toList(),
        );

        final orderSummary = _OrderSummary(
          cart: cart,
        );

        return SingleChildScrollView(
          padding: EdgeInsets.all(
            isWideScreen ? 36 : 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1120,
              ),
              child: isWideScreen
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: cartItems,
                        ),
                        const SizedBox(width: 28),
                        Expanded(
                          flex: 2,
                          child: orderSummary,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        cartItems,
                        const SizedBox(height: 8),
                        orderSummary,
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.cart,
  });

  final CartItem item;
  final CartController cart;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final selectedImage = isDarkMode
        ? item.product.darkImageAsset
        : item.product.imageAsset;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                selectedImage,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),

                  // Formatted individual price
                  Text(
                    '${formatPhp(item.product.price)} each',
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () {
                          cart.decrement(item.product.id);
                        },
                        icon: const Icon(Icons.remove_rounded),
                      ),
                      SizedBox(
                        width: 42,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () {
                          cart.increment(item.product.id);
                        },
                        icon: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Formatted item subtotal
                Text(
                  formatPhp(item.subtotal),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        color:
                            Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                IconButton(
                  tooltip: 'Remove item',
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () {
                    cart.remove(item.product.id);
                  },
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.cart,
  });

  final CartController cart;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ORDER SUMMARY',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '${cart.itemCount} '
                  'item${cart.itemCount == 1 ? '' : 's'}',
                ),
                const Spacer(),

                // Formatted summary subtotal
                Text(
                  formatPhp(cart.total),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),

                // Formatted final total
                Text(
                  formatPhp(cart.total),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        color:
                            Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: cart.isEmpty
                  ? null
                  : () => context.go('/checkout'),
              icon: const Icon(Icons.lock_outline_rounded),
              label: const Text('CHECKOUT SECURELY'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('CONTINUE SHOPPING'),
            ),
          ],
        ),
      ),
    );
  }
}