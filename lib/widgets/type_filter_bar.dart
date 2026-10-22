import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pokedex_provider.dart';
import 'type_badge.dart';

/// Chip selector for filtering by Pokémon type. The chips are built from the
/// types found in the loaded data, so the filter always uses real type data.
class TypeFilterBar extends ConsumerWidget {
  const TypeFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexProvider);
    final notifier = ref.read(pokedexProvider.notifier);
    final types = state.availableTypes;

    if (state.status != LoadStatus.success || types.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    // "All" = no filter.
                    ChoiceChip(
                      label: const Text('All'),
                      selected: state.typeFilter == null,
                      onSelected: (_) => notifier.clearTypeFilter(),
                    ),
                    for (final type in types) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(TypeBadge.label(type)),
                        selected: state.typeFilter == type,
                        selectedColor: TypeBadge.colorFor(type).withValues(
                          alpha: 0.35,
                        ),
                        onSelected: (selected) => selected
                            ? notifier.setTypeFilter(type)
                            : notifier.clearTypeFilter(),
                      ),
                    ],
                  ],
                ),
              ),
              if (state.typeFilter != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton.icon(
                    onPressed: notifier.clearTypeFilter,
                    icon: const Icon(Icons.filter_alt_off, size: 18),
                    label: const Text('Clear'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
