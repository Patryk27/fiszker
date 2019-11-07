import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';

/// This widget models the "Deck name" form field.
/// It's a part of the [DeckForm], not meant for standalone use.
class DeckNameField extends StatefulWidget {
  final DeckModel deck;

  DeckNameField({
    @required this.deck,
  }) : assert(deck != null);

  @override
  State<DeckNameField> createState() => _DeckNameFieldState();
}

class _DeckNameFieldState extends State<DeckNameField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.deck.name.isEmpty,
      controller: controller,

      decoration: const InputDecoration(
        labelText: 'Nazwa',
        hintText: 'np.: francuski',
        alignLabelWithHint: true,
      ),

      validator: (value) {
        return value.isEmpty ? 'Nazwa zestawu nie może być pusta.' : null;
      },

      onEditingComplete: () {
        // When user finishes editing, dismiss the keyboard
        FocusScope
            .of(context)
            .unfocus();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    controller.text = widget.deck.name;

    controller.addListener(() {
      final deck = widget.deck.copyWith(
        name: controller.text.trim(),
      );

      // @todo
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}
