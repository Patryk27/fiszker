import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

/// Saves all changes (renames, added cards and so on) to the database.
/// It's dispatched when user clicks the "Submit" button.
class Submit extends DeckFormBlocEvent {
  final DeckFormBehavior formBehavior;
  final DeckEntity deck;

  Submit({
    @required this.formBehavior,
    @required this.deck,
  })
      : assert(formBehavior != null),
        assert(deck != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    yield Submitting();

    switch (formBehavior) {
      case DeckFormBehavior.createDeck:
        await bloc.deckFacade.create(deck);
        break;

      case DeckFormBehavior.editDeck:
        await bloc.deckFacade.update(deck);
        break;
    }

    yield Submitted();
  }
}
