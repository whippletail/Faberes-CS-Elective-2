import 'package:flutter/material.dart';
import 'screens/pokedex_screen.dart';

void main() => runApp(const PokedexApp());

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFEE1515),
        scaffoldBackgroundColor: const Color(0xFFF4F5F9),
      ),
      home: const PokedexScreen(),
    );
  }
}
