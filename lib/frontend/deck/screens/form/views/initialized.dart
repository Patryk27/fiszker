import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';

class InitializedView extends StatelessWidget {
  final InitializedState state;

  InitializedView({
    @required this.state,
  }) : assert(state != null);

  @override
  Widget build(BuildContext context) {
    void submit(DeckModel deck, List<BoxModel> boxes, List<CardModel> cards) {
      DeckFormBloc.of(context).add(
        Submit(
          formBehavior: state.formBehavior,
          deck: deck,
          boxes: boxes,
          cards: cards,
        ),
      );
    }

    if (state.formBehavior == DeckFormBehavior.createDeck) {
      return DeckForm.createDeck(
        onSubmit: submit,
      );
    } else {
      return DeckForm.editDeck(
        deck: state.deck,
        onSubmit: submit,
      );
    }
  }
}
