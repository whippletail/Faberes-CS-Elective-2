class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

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
}
