import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../providers/pokedex_provider.dart';

/// Opens the nickname editor for [pokemon].
Future<void> showNicknameEditor(BuildContext context, Pokemon pokemon) {
  return showDialog<void>(
    context: context,
    builder: (_) => NicknameEditorDialog(pokemon: pokemon),
  );
}

class NicknameEditorDialog extends ConsumerStatefulWidget {
  final Pokemon pokemon;

  const NicknameEditorDialog({super.key, required this.pokemon});

  @override
  ConsumerState<NicknameEditorDialog> createState() =>
      _NicknameEditorDialogState();
}

class _NicknameEditorDialogState extends ConsumerState<NicknameEditorDialog> {
  late final TextEditingController _controller;
  late final bool _hasNickname;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(pokedexProvider).nicknames[widget.pokemon.id];
    _hasNickname = existing != null;
    _controller = TextEditingController(text: existing ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(pokedexProvider.notifier).setNickname(widget.pokemon.id, text);
    Navigator.of(context).pop();
  }

  void _remove() {
    ref.read(pokedexProvider.notifier).removeNickname(widget.pokemon.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_hasNickname ? 'Edit nickname' : 'Add nickname'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Original name: ${widget.pokemon.displayName}',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 20,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nickname',
              hintText: 'e.g. Sparky',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _save(),
          ),
        ],
      ),
      actions: [
        if (_hasNickname)
          TextButton(
            onPressed: _remove,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Save is only enabled while there is text to save.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) => FilledButton(
            onPressed: value.text.trim().isEmpty ? null : _save,
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}
