class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  /// Type names such as `fire` or `water`. The list endpoint does not return
  /// types, so they are filled in from the per-Pokémon detail endpoint.
  final List<String> types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const [],
  });

  /// Original name with the first letter capitalised (e.g. `Bulbasaur`).
  String get displayName =>
      name.isEmpty ? name : name[0].toUpperCase() + name.substring(1);

  /// The list endpoint only returns `name` and `url`
  /// (e.g. https://pokeapi.co/api/v2/pokemon/1/), so the ID is parsed from the URL.
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final segments = Uri.parse(url).pathSegments.where((s) => s.isNotEmpty).toList();
    final id = int.parse(segments.last);

    return Pokemon(
      id: id,
      name: json['name'] as String,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }

  /// Reads the type names from a detail response (`/pokemon/{id}`).
  static List<String> typesFromJson(Map<String, dynamic> detailJson) {
    final raw = detailJson['types'] as List<dynamic>? ?? const [];
    return raw
        .map(
          (t) =>
              ((t as Map<String, dynamic>)['type'] as Map<String, dynamic>)['name']
                  as String,
        )
        .toList();
  }

  Pokemon copyWith({List<String>? types}) {
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      types: types ?? this.types,
    );
  }
}
