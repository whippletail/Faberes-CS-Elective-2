import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'controllers/cart_controller.dart';

class SkimWaveApp extends StatefulWidget {  //stateful cuz them can change while running
  const SkimWaveApp({super.key});

  @override
  State<SkimWaveApp> createState() => _SkimWaveAppState(); //creates the separate state object where the changeable data is stored
}

class _SkimWaveAppState extends State<SkimWaveApp> {
  ThemeMode _themeMode = ThemeMode.light; // initial theme mode is set to light
  final CartController _cart = CartController();

  @override
  void dispose() { _cart.dispose(); super.dispose(); }

  void _toggleTheme() {                   // changed here through toggling
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SkimWave',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,        //decides which theme to use based on the current theme mode
      routerConfig: createRouter(   //values r passed to the router
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
        cart: _cart,
      ),
    );
  }
}
