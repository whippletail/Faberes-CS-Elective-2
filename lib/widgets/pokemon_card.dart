import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;

  const PokemonCard({super.key, required this.pokemon, required this.onTap});

  static const List<Color> _pastels = [
    Color(0xFFFFD6D6), // pink-red
    Color(0xFFD6ECFF), // sky blue
    Color(0xFFD9F5D6), // grass green
    Color(0xFFFFF1C2), // sunny yellow
    Color(0xFFE6D9FF), // lavender
    Color(0xFFFFE0C2), // peach
    Color(0xFFCFF5F0), // aqua
  ];

  static Color colorFor(int id) => _pastels[id % _pastels.length];

  String get _displayName =>
      pokemon.name[0].toUpperCase() + pokemon.name.substring(1);

  @override
  Widget build(BuildContext context) {
    final color = colorFor(pokemon.id);

    return Material(
      color: color,
      elevation: 2,
      shadowColor: color,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Pokéball watermark
            Positioned(
              right: -22,
              bottom: -22,
              child: Icon(
                Icons.catching_pokemon,
                size: 110,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#${pokemon.id.toString().padLeft(3, '0')}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  // Image
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Center(
                        child: Hero(
                          tag: 'pokemon-${pokemon.id}',
                          child: Image.network(
                            pokemon.imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stack) => const Icon(
                              Icons.catching_pokemon,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Name pill
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _displayName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2B2D42),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
