import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pokedex_provider.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/nickname_editor_dialog.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/type_filter_bar.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends ConsumerWidget {
  const PokedexScreen({super.key});

  static const Color _pokeRed = Color(0xFFEE1515);

  void _openDetail(BuildContext context, WidgetRef ref, int id) {
    ref.read(pokedexProvider.notifier).selectPokemon(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PokemonDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexProvider);
    final notifier = ref.read(pokedexProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pokeRed,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.catching_pokemon, size: 30),
            SizedBox(width: 8),
            Text(
              'Pokédex',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            // Re-calls the same fetch() method on the notifier.
            onPressed: state.status == LoadStatus.loading
                ? null
                : () => notifier.fetch(),
          ),
        ],
      ),
      body: Column(
        children: [
          FavoritesPanel(onSelect: (p) => _openDetail(context, ref, p.id)),
          const TypeFilterBar(),
          Expanded(child: _buildBody(context, ref, state)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PokedexState state) {
    final notifier = ref.read(pokedexProvider.notifier);

    // Loading
    if (state.status == LoadStatus.loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: _pokeRed),
            SizedBox(height: 16),
            Text(
              'Catching Pokémon...',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    // Error
    if (state.status == LoadStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.catching_pokemon,
                size: 72,
                color: Colors.black26,
              ),
              const SizedBox(height: 12),
              const Text(
                'Oh no! The Pokémon got away.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                state.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: _pokeRed),
                onPressed: () => notifier.fetch(),
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty (API returned nothing)
    if (state.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.catching_pokemon, size: 72, color: Colors.black26),
            SizedBox(height: 12),
            Text(
              'No Pokémon found.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      );
    }

    // Empty (filter matched nothing)
    final pokemon = state.filteredPokemon;
    if (pokemon.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 72, color: Colors.black26),
            const SizedBox(height: 12),
            Text(
              'No ${state.typeFilter ?? ''} Pokémon found.',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: _pokeRed),
              onPressed: notifier.clearTypeFilter,
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Clear filter'),
            ),
          ],
        ),
      );
    }

    // Success: scrollable grid with pull-to-refresh
    return RefreshIndicator(
      color: _pokeRed,
      onRefresh: () => notifier.fetch(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 190,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.8,
            ),
            itemCount: pokemon.length,
            itemBuilder: (context, index) {
              final p = pokemon[index];
              return PokemonCard(
                key: ValueKey(p.id),
                pokemon: p,
                onTap: () => _openDetail(context, ref, p.id),
                // Long-press a card to add/edit its nickname.
                onLongPress: () => showNicknameEditor(context, p),
              );
            },
          ),
        ),
      ),
    );
  }
}
