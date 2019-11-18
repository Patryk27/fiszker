import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';

import '../../bloc.dart';

/// This widget models the "Deck name" form field.
/// It's a part of the [DeckForm], not meant for standalone use.
class DeckNameField extends StatefulWidget {
  final DeckEntity deck;

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

    controller.text = widget.deck.deck.name;

    controller.addListener(() {
      final name = controller.text.trim();

      if (name.isNotEmpty) {
        // @todo currently user gets no notification after renaming (because it's quite ad-hoc solution), it could be
        //       improved (e.g. we could open an additional modal for renaming)

        DeckFormBloc
            .of(context)
            .add(ChangeDeckName(widget.deck, name));
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
