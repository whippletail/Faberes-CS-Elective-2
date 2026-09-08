import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/cart_controller.dart';
import '../utils/currency_formatter.dart';

class CheckoutConfirmationPage extends StatelessWidget {
  const CheckoutConfirmationPage({
    super.key,
    required this.cart,
  });

  final CartController cart;

  @override
  Widget build(BuildContext context) {
    final items = cart.items;
    final total = cart.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDER CONFIRMED'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 720,
            ),
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your next wave is on the way!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Thanks for choosing SkimWave. '
                  'Here is your order summary.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ...items.map(
                          (item) {
                            final isDarkMode =
                                Theme.of(context).brightness ==
                                    Brightness.dark;

                            final selectedImage = isDarkMode
                                ? item.product.darkImageAsset
                                : item.product.imageAsset;

                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 14),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    child: Image.asset(
                                      selectedImage,
                                      width: 58,
                                      height: 58,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontWeight:
                                                FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '${item.quantity} x '
                                          '${formatPhp(item.product.price)}',
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Formatted item subtotal
                                  Text(
                                    formatPhp(item.subtotal),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                'ORDER TOTAL',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                              const Spacer(),

                              // Formatted final total
                              Text(
                                formatPhp(total),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: () {
                    cart.clear();
                    context.go('/');
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('BACK TO HOME'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}