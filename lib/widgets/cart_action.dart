import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/cart_controller.dart';

class CartAction extends StatelessWidget {
  const CartAction({super.key, required this.cart});
  final CartController cart;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: cart,
    builder: (context, _) => Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(tooltip: 'View cart', onPressed: () => context.go('/cart'), icon: Badge(isLabelVisible: cart.itemCount > 0, label: Text('${cart.itemCount}'), child: const Icon(Icons.shopping_bag_outlined))),
    ),
  );
}
