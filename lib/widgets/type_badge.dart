import 'package:flutter/material.dart';

/// Small colored pill showing a Pokémon type (e.g. Fire, Water).
class TypeBadge extends StatelessWidget {
  final String type;

  const TypeBadge({super.key, required this.type});

  static const Map<String, Color> _colors = {
    'normal': Color(0xFFA8A77A),
    'fire': Color(0xFFEE8130),
    'water': Color(0xFF6390F0),
    'electric': Color(0xFFD9A800),
    'grass': Color(0xFF4CAF50),
    'ice': Color(0xFF4FC3C3),
    'fighting': Color(0xFFC22E28),
    'poison': Color(0xFFA33EA1),
    'ground': Color(0xFFB8924A),
    'flying': Color(0xFF8E7CE0),
    'psychic': Color(0xFFF95587),
    'bug': Color(0xFF91A119),
    'rock': Color(0xFFB6A136),
    'ghost': Color(0xFF735797),
    'dragon': Color(0xFF6F35FC),
    'dark': Color(0xFF705746),
    'steel': Color(0xFF7A7AA0),
    'fairy': Color(0xFFD685AD),
  };

  static Color colorFor(String type) => _colors[type] ?? Colors.grey;

  static String label(String type) =>
      type.isEmpty ? type : type[0].toUpperCase() + type.substring(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: colorFor(type),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label(type),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
