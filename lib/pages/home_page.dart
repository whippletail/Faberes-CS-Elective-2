import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/hero_banner.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_action.dart';
import '../controllers/cart_controller.dart';

class HomePage extends StatelessWidget {    //
  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.cart,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final CartController cart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(        //provides standard page structure
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.waves_rounded),
            SizedBox(width: 10),
            Text('SKIMWAVE'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isDarkMode ? 'Use light mode' : 'Use dark mode',
            onPressed: onToggleTheme,
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
          ),
          CartAction(cart: cart),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: HeroBanner()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 18),
              child: Column(
                children: [
                  Text(
                    'HOT BOARDS',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 68,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hand-picked favorites for your next shoreline session.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 36),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final columns = width >= 1050 ? 4 : (width >= 650 ? 3 : 2);
                final ratio = width < 390 ? .59 : (columns == 2 ? .66 : .72);

                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: ratio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: products[index]),
                    childCount: products.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
