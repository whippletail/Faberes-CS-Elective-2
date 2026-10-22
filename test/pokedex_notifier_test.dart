import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/providers/pokedex_provider.dart';

/// Starts with data already loaded so the tests never touch the network.
class _SeededNotifier extends PokedexNotifier {
  @override
  PokedexState build() => const PokedexState(
    status: LoadStatus.success,
    pokemon: [
      Pokemon(id: 1, name: 'bulbasaur', imageUrl: '', types: ['grass', 'poison']),
      Pokemon(id: 4, name: 'charmander', imageUrl: '', types: ['fire']),
      Pokemon(id: 7, name: 'squirtle', imageUrl: '', types: ['water']),
    ],
  );
}

void main() {
  late ProviderContainer container;
  late PokedexNotifier notifier;

  PokedexState read() => container.read(pokedexProvider);

  setUp(() {
    container = ProviderContainer(
      overrides: [pokedexProvider.overrideWith(_SeededNotifier.new)],
    );
    notifier = container.read(pokedexProvider.notifier);
  });

  tearDown(() => container.dispose());

  test('nickname can be added, edited, and removed', () {
    notifier.setNickname(1, '  Bulby ');
    expect(read().nicknames[1], 'Bulby');

    notifier.setNickname(1, 'Sprout');
    expect(read().nicknames[1], 'Sprout');

    notifier.removeNickname(1);
    expect(read().nicknames.containsKey(1), isFalse);
  });

  test('blank nickname removes the existing one', () {
    notifier.setNickname(4, 'Flame');
    notifier.setNickname(4, '   ');
    expect(read().nicknames.containsKey(4), isFalse);
  });

  test('toggleFavorite adds then removes, and updates favoritePokemon', () {
    notifier.toggleFavorite(7);
    expect(read().favoriteIds, {7});
    expect(read().favoritePokemon.map((p) => p.name), ['squirtle']);

    notifier.toggleFavorite(7);
    expect(read().favoriteIds, isEmpty);
    expect(read().favoritePokemon, isEmpty);
  });

  test('favorites panel toggles open and closed', () {
    expect(read().favoritesExpanded, isFalse);
    notifier.toggleFavoritesPanel();
    expect(read().favoritesExpanded, isTrue);
    notifier.toggleFavoritesPanel();
    expect(read().favoritesExpanded, isFalse);
  });

  test('type filter narrows the list and can be cleared', () {
    expect(read().availableTypes, ['fire', 'grass', 'poison', 'water']);

    notifier.setTypeFilter('fire');
    expect(read().filteredPokemon.map((p) => p.name), ['charmander']);

    // Dual-type Pokémon match either of their types.
    notifier.setTypeFilter('poison');
    expect(read().filteredPokemon.map((p) => p.name), ['bulbasaur']);

    notifier.clearTypeFilter();
    expect(read().typeFilter, isNull);
    expect(read().filteredPokemon.length, 3);
  });
}
