import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../providers/pokedex_provider.dart';
import 'pokemon_card.dart';

/// Retractable favorites panel. It reads its expanded/collapsed flag and the
/// favorites list from the Riverpod state, so it stays in sync on every screen
/// that shows it and updates the moment a favorite is added or removed.
class FavoritesPanel extends ConsumerWidget {
  /// Called when a favorite is tapped.
  final void Function(Pokemon pokemon) onSelect;

  const FavoritesPanel({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexProvider);
    final notifier = ref.read(pokedexProvider.notifier);
    final favorites = state.favoritePokemon;
    final expanded = state.favoritesExpanded;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Material(
            color: Colors.white,
            elevation: 1,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header: tap to expand / collapse.
                InkWell(
                  onTap: notifier.toggleFavoritesPanel,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Favorites (${favorites.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        AnimatedRotation(
                          turns: expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.expand_more),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  child: expanded
                      ? _buildBody(favorites, ref)
                      : const SizedBox(width: double.infinity, height: 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<Pokemon> favorites, WidgetRef ref) {
    if (favorites.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Text(
          'No favorites yet. Tap the heart on a Pokémon to add it here.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        itemCount: favorites.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final p = favorites[index];
          final nickname = ref.watch(
            pokedexProvider.select((s) => s.nicknames[p.id]),
          );
          return _FavoriteTile(
            pokemon: p,
            label: nickname ?? p.displayName,
            onTap: () => onSelect(p),
            onRemove: () =>
                ref.read(pokedexProvider.notifier).toggleFavorite(p.id),
          );
        },
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final Pokemon pokemon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteTile({
    required this.pokemon,
    required this.label,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: PokemonCard.colorFor(pokemon.id),
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    pokemon.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.catching_pokemon,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: onRemove,
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
