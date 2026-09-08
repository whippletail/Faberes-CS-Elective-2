import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';
import '../pages/product_detail_page.dart';
import '../pages/cart_page.dart';
import '../pages/checkout_confirmation_page.dart';
import '../controllers/cart_controller.dart';

GoRouter createRouter({
  required bool isDarkMode,
  required VoidCallback onToggleTheme,
  required CartController cart,
}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(
          isDarkMode: isDarkMode,
          onToggleTheme: onToggleTheme,
          cart: cart,
        ),
      ),
      GoRoute(
        path: '/products/:productId',     //dynamic route for product details
        builder: (context, state) => ProductDetailPage(
          productId: state.pathParameters['productId']!,
          cart: cart,
        ),
      ),
      GoRoute(path: '/cart', builder: (context, state) => CartPage(cart: cart)),
      GoRoute(path: '/checkout', redirect: (context, state) => cart.isEmpty ? '/cart' : null, builder: (context, state) => CheckoutConfirmationPage(cart: cart)),
    ],
  );
}
