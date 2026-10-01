import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http; 
import '../models/pokemon.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> fetchPokemon({int limit = 30}) async {
    final response = await http
        .get(Uri.parse('$_baseUrl?limit=$limit'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokémon (status ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    return results
        .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
