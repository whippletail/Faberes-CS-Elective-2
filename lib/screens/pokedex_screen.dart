import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({super.key});

  static const Color _pokeRed = Color(0xFFEE1515);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

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
            onPressed: provider.status == LoadStatus.loading
                ? null
                : () => context.read<PokemonProvider>().refresh(),
          ),
        ],
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, PokemonProvider provider) {
    // Loading
    if (provider.status == LoadStatus.loading) {
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
    if (provider.status == LoadStatus.error) {
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
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: _pokeRed),
                onPressed: () => context.read<PokemonProvider>().refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty
    if (provider.isEmpty) {
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

    // Success: scrollable grid with pull-to-refresh
    final pokemon = provider.pokemon;
    return RefreshIndicator(
      color: _pokeRed,
      onRefresh: () => context.read<PokemonProvider>().refresh(),
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
              childAspectRatio: 0.85,
            ),
            itemCount: pokemon.length,
            itemBuilder: (context, index) {
              final p = pokemon[index];
              return PokemonCard(
                pokemon: p,
                onTap: () {
                  context.read<PokemonProvider>().selectPokemon(p.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PokemonDetailScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
