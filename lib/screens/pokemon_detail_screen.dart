import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pokedex_provider.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/nickname_editor_dialog.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/type_badge.dart';

class PokemonDetailScreen extends ConsumerWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Everything on this page comes from the Riverpod state.
    final state = ref.watch(pokedexProvider);
    final notifier = ref.read(pokedexProvider.notifier);
    final pokemon = state.selectedPokemon;

    if (pokemon == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No Pokémon selected.')),
      );
    }

    final color = PokemonCard.colorFor(pokemon.id);
    final nickname = state.nicknames[pokemon.id];
    final isFavorite = state.favoriteIds.contains(pokemon.id);

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        elevation: 0,
        foregroundColor: const Color(0xFF2B2D42),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () => notifier.toggleFavorite(pokemon.id),
          ),
        ],
      ),
      body: Column(
        children: [
          // The same favorites panel is available here too. Tapping a favorite
          // just changes the selected Pokémon, so this page updates in place.
          FavoritesPanel(onSelect: (p) => notifier.selectPokemon(p.id)),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  right: -60,
                  top: 20,
                  child: Icon(
                    Icons.catching_pokemon,
                    size: 320,
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Hero(
                              tag: 'pokemon-${pokemon.id}',
                              child: Image.network(
                                pokemon.imageUrl,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stack) =>
                                    const Icon(
                                      Icons.catching_pokemon,
                                      size: 96,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(36),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Nickname (if any) is the headline; the original
                              // name is always kept visible.
                              Text(
                                nickname ?? pokemon.displayName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2B2D42),
                                ),
                              ),
                              if (nickname != null)
                                Text(
                                  'Original name: ${pokemon.displayName}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '#${pokemon.id.toString().padLeft(3, '0')}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  for (final type in pokemon.types)
                                    TypeBadge(type: type),
                                ],
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    showNicknameEditor(context, pokemon),
                                icon: const Icon(Icons.edit),
                                label: Text(
                                  nickname == null
                                      ? 'Add nickname'
                                      : 'Edit nickname',
                                ),
                              ),
                            ],
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
    );
  }
}
