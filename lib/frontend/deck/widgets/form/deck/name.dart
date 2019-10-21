import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

class DeckNameField extends StatefulWidget {
  final DeckModel deck;
  final void Function(DeckModel deck) onChanged;

  DeckNameField({
    @required this.deck,
    @required this.onChanged,
  })
      : assert(deck != null),
        assert(onChanged != null);

  @override
  _DeckNameFieldState createState() {
    return _DeckNameFieldState();
  }
}

class _DeckNameFieldState extends State<DeckNameField> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.deck.name.isEmpty,
      controller: textController,

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

    textController.text = widget.deck.name;

    textController.addListener(() {
      final deck = widget.deck.copyWith(
        name: textController.text.trim(),
      );

      widget.onChanged(deck);
    });
  }

  @override
  void dispose() {
    textController.dispose();

    super.dispose();
  }
}
