import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

enum LoadStatus { loading, success, error }

class PokemonProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  static const int _limit = 30;

  // ---- App state ----
  LoadStatus _status = LoadStatus.loading;
  List<Pokemon> _pokemon = [];
  String _errorMessage = '';
  int? _selectedId;

  // ---- Getters (the UI reads only these) ----
  LoadStatus get status => _status;
  List<Pokemon> get pokemon => _pokemon;
  String get errorMessage => _errorMessage;
  bool get isEmpty => _status == LoadStatus.success && _pokemon.isEmpty;

  /// The Pokémon whose detail page is open. Detail page values come from here.
  Pokemon? get selectedPokemon {
    if (_selectedId == null) return null;
    for (final p in _pokemon) {
      if (p.id == _selectedId) return p;
    }
    return null;
  }

  // ---- Actions ----

  /// API call. Also used for refresh: calling it again re-triggers the request.
  Future<void> fetchPokemon() async {
    _status = LoadStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('$_baseUrl?limit=$_limit'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load Pokémon (status ${response.statusCode})',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      _pokemon = results
          .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
          .toList();
      _status = LoadStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = LoadStatus.error;
    }

    notifyListeners();
  }

  Future<void> refresh() => fetchPokemon();

  void selectPokemon(int id) {
    _selectedId = id;
    notifyListeners();
  }
}
