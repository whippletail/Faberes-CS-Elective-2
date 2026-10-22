import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

enum LoadStatus { loading, success, error }

/// Immutable snapshot of everything the Pokédex UI needs.
/// Riverpod rebuilds listeners whenever the notifier assigns a NEW state object,
/// so every change below creates copies of the maps/sets instead of mutating them.
class PokedexState {
  final LoadStatus status;
  final List<Pokemon> pokemon;
  final String errorMessage;

  /// Pokémon id -> custom nickname.
  final Map<int, String> nicknames;

  /// Ids of favorited Pokémon.
  final Set<int> favoriteIds;

  /// Currently selected type (e.g. `fire`). `null` means no filter.
  final String? typeFilter;

  /// The Pokémon whose detail page is open.
  final int? selectedId;

  /// Whether the favorites panel is expanded.
  final bool favoritesExpanded;

  const PokedexState({
    this.status = LoadStatus.loading,
    this.pokemon = const [],
    this.errorMessage = '',
    this.nicknames = const {},
    this.favoriteIds = const {},
    this.typeFilter,
    this.selectedId,
    this.favoritesExpanded = false,
  });

  PokedexState copyWith({
    LoadStatus? status,
    List<Pokemon>? pokemon,
    String? errorMessage,
    Map<int, String>? nicknames,
    Set<int>? favoriteIds,
    String? typeFilter,
    bool clearTypeFilter = false,
    int? selectedId,
    bool? favoritesExpanded,
  }) {
    return PokedexState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      errorMessage: errorMessage ?? this.errorMessage,
      nicknames: nicknames ?? this.nicknames,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      selectedId: selectedId ?? this.selectedId,
      favoritesExpanded: favoritesExpanded ?? this.favoritesExpanded,
    );
  }

  // ---- Derived values (computed from the state above) ----

  bool get isEmpty => status == LoadStatus.success && pokemon.isEmpty;

  /// Pokémon matching the active type filter (or everything if no filter).
  List<Pokemon> get filteredPokemon {
    final type = typeFilter;
    if (type == null) return pokemon;
    return pokemon.where((p) => p.types.contains(type)).toList();
  }

  /// Every type that appears in the loaded data, sorted alphabetically.
  List<String> get availableTypes {
    final types = <String>{for (final p in pokemon) ...p.types};
    return types.toList()..sort();
  }

  List<Pokemon> get favoritePokemon =>
      pokemon.where((p) => favoriteIds.contains(p.id)).toList();

  Pokemon? get selectedPokemon {
    if (selectedId == null) return null;
    for (final p in pokemon) {
      if (p.id == selectedId) return p;
    }
    return null;
  }
}

class PokedexNotifier extends Notifier<PokedexState> {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  static const int _limit = 30;
  static const Duration _timeout = Duration(seconds: 10);

  bool _isFetching = false;

  @override
  PokedexState build() {
    // Fetch once when the provider is first used (the same job the old
    // `PokemonProvider()..fetchPokemon()` did in main.dart).
    Future.microtask(fetch);
    return const PokedexState();
  }

  // ---------------------------------------------------------------------------
  // 1. Pokémon list management
  // ---------------------------------------------------------------------------

  /// API call. Also used for refresh: calling it again re-triggers the request.
  /// Nicknames, favorites and the type filter live in the same state, so they
  /// survive a refresh.
  Future<void> fetch() async {
    if (_isFetching) return;
    _isFetching = true;

    state = state.copyWith(status: LoadStatus.loading, errorMessage: '');

    try {
      final response = await http
          .get(Uri.parse('$_baseUrl?limit=$_limit'))
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('Failed to load Pokémon (status ${response.statusCode})');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      // The list endpoint has no type data, so load each Pokémon's details
      // (in parallel) to get the real types used by the filter.
      final loaded = await Future.wait(results.map(_fetchWithTypes));

      state = state.copyWith(status: LoadStatus.success, pokemon: loaded);
    } on TimeoutException {
      state = state.copyWith(
        status: LoadStatus.error,
        errorMessage: 'The request timed out. Check your connection and try again.',
      );
    } on http.ClientException {
      state = state.copyWith(
        status: LoadStatus.error,
        errorMessage: 'Could not reach the Pokémon server. Check your connection.',
      );
    } catch (e) {
      state = state.copyWith(
        status: LoadStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<Pokemon> _fetchWithTypes(Map<String, dynamic> listItem) async {
    final base = Pokemon.fromJson(listItem);
    final response = await http
        .get(Uri.parse(listItem['url'] as String))
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load details for ${base.displayName} (status ${response.statusCode})',
      );
    }

    final detail = jsonDecode(response.body) as Map<String, dynamic>;
    return base.copyWith(types: Pokemon.typesFromJson(detail));
  }

  void selectPokemon(int id) {
    state = state.copyWith(selectedId: id);
  }

  // ---------------------------------------------------------------------------
  // 2. Nickname editor
  // ---------------------------------------------------------------------------

  /// Adds or edits a nickname. An empty/blank nickname removes it.
  void setNickname(int id, String nickname) {
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) {
      removeNickname(id);
      return;
    }
    state = state.copyWith(nicknames: {...state.nicknames, id: trimmed});
  }

  void removeNickname(int id) {
    if (!state.nicknames.containsKey(id)) return;
    final next = {...state.nicknames}..remove(id);
    state = state.copyWith(nicknames: next);
  }

  // ---------------------------------------------------------------------------
  // 3 & 4. Favorites (panel + heart indicator both read/write this)
  // ---------------------------------------------------------------------------

  void toggleFavorite(int id) {
    final next = {...state.favoriteIds};
    if (!next.add(id)) next.remove(id);
    state = state.copyWith(favoriteIds: next);
  }

  void toggleFavoritesPanel() {
    state = state.copyWith(favoritesExpanded: !state.favoritesExpanded);
  }

  // ---------------------------------------------------------------------------
  // 5. Type filter
  // ---------------------------------------------------------------------------

  void setTypeFilter(String type) {
    state = state.copyWith(typeFilter: type);
  }

  void clearTypeFilter() {
    state = state.copyWith(clearTypeFilter: true);
  }
}

final pokedexProvider = NotifierProvider<PokedexNotifier, PokedexState>(
  PokedexNotifier.new,
);
