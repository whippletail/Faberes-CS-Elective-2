import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../providers/pokedex_provider.dart';

class PokemonCard extends ConsumerWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
    this.onLongPress,
  });

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = colorFor(pokemon.id);

    // `select` makes this card rebuild only when ITS nickname / favorite flag
    // changes, not whenever any other Pokémon changes.
    final nickname = ref.watch(
      pokedexProvider.select((s) => s.nicknames[pokemon.id]),
    );
    final isFavorite = ref.watch(
      pokedexProvider.select((s) => s.favoriteIds.contains(pokemon.id)),
    );

    return Material(
      color: color,
      elevation: 2,
      shadowColor: color,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            // Pokéball watermark
            Positioned(
              right: -22,
              bottom: -22,
              child: Icon(
                Icons.catching_pokemon,
                size: 110,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID badge + favorite heart
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
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
                      const Spacer(),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          tooltip: isFavorite
                              ? 'Remove from favorites'
                              : 'Add to favorites',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.75),
                          ),
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black45,
                          ),
                          onPressed: () => ref
                              .read(pokedexProvider.notifier)
                              .toggleFavorite(pokemon.id),
                        ),
                      ),
                    ],
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
                  // Name pill: nickname (if any) on top, original name always shown.
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (nickname != null)
                            Text(
                              nickname,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2B2D42),
                              ),
                            ),
                          Text(
                            pokemon.displayName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: nickname != null
                                ? const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  )
                                : const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2B2D42),
                                  ),
                          ),
                        ],
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
