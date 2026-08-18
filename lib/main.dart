import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const FruitApp());

class Fruit {
  final String name;
  final String emoji;
  final Color color;
  const Fruit(this.name, this.emoji, this.color);
}

const List<Fruit> fruits = [
  Fruit('apple', '🍎', Colors.redAccent),
  Fruit('banana', '🍌', Colors.amber),
  Fruit('mango', '🥭', Colors.orangeAccent),
];

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const FruitListScreen(),
      routes: [
        // Nested route -> full path becomes "/fruit/:name"
        GoRoute(
          path: 'fruit/:name',
          name: 'fruit-detail',
          builder: (context, state) {
            final name = state.pathParameters['name']!;
            return FruitDetailScreen(name: name);
          },
        ),
      ],
    ),
  ],
);

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fruit Nav Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      routerConfig: _router,
    );
  }
}

// ---------------------------------------------------------------------------
// Page 1 — list of fruits at "/"
// ---------------------------------------------------------------------------
class FruitListScreen extends StatelessWidget {
  const FruitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruits')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: fruits.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          return ListTile(
            leading: Text(fruit.emoji, style: const TextStyle(fontSize: 28)),
            title: Text(fruit.name[0].toUpperCase() + fruit.name.substring(1)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Redirects from "/" to "/fruit/:name"
              context.go('/fruit/${fruit.name}');
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 2 — nested detail page at "/fruit/:name"
// ---------------------------------------------------------------------------
class FruitDetailScreen extends StatelessWidget {
  final String name;
  const FruitDetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final fruit = fruits.firstWhere(
      (f) => f.name == name,
      orElse: () => Fruit(name, '❓', Colors.grey),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(fruit.name[0].toUpperCase() + fruit.name.substring(1)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // "Illustration" of the corresponding fruit
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: fruit.color.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: fruit.color, width: 4),
              ),
              alignment: Alignment.center,
              child: Text(fruit.emoji, style: const TextStyle(fontSize: 90)),
            ),
            const SizedBox(height: 24),
            Text(
              fruit.name[0].toUpperCase() + fruit.name.substring(1),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'URL: /fruit/${fruit.name}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to list'),
            ),
          ],
        ),
      ),
    );
  }
}
