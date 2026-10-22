# pokemon

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Midterm Exam: Riverpod

State management was migrated to **flutter_riverpod** (`NotifierProvider`).

- `lib/providers/pokedex_provider.dart`: `PokedexState` (immutable) + `PokedexNotifier`
  with `fetch()`, `selectPokemon()`, `setNickname()`, `removeNickname()`, `toggleFavorite()`,
  `toggleFavoritesPanel()`, `setTypeFilter()`, `clearTypeFilter()`.
- Refresh (AppBar button, pull-to-refresh, "Try again") all call the same `fetch()`.
- Long-press a card to edit its nickname; the detail screen also has an Add/Edit nickname button.
- Run tests with `flutter test`.
