import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';

/// Saves all changes (renames, added cards and so on) to the database.
/// It's dispatched when user clicks the "Save" button.
class Submit extends BlocEvent {
  final DeckFormBehavior formBehavior;
  final DeckModel deck;
  final List<CardModel> cards;

  Submit({
    @required this.formBehavior,
    @required this.deck,
    @required this.cards,
  })
      : assert(formBehavior != null),
        assert(deck != null),
        assert(cards != null);

  @override
  Stream<BlocState> mapToState(DeckFormBloc bloc) async* {
    final deckFacade = bloc.deckFacade;

    yield SubmittingState();

    switch (formBehavior) {
      case DeckFormBehavior.createDeck:
        await deckFacade.create(CreateDeckRequest.build(
          deck: deck,
          cards: cards,
        ));

        break;

      case DeckFormBehavior.editDeck:
        await deckFacade.update(UpdateDeckRequest.build(
          oldDeck: await deckFacade.findById(deck.id),
          oldCards: await deckFacade.findCards(deck),

          newDeck: deck,
          newCards: cards,
        ));

        break;
    }

    yield SubmittedState();
  }
}
