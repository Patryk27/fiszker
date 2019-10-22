import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';

/// Saves all changes (renames, added cards and so on) to the database.
/// It's dispatched when user clicks the "Submit" button.
class Submit extends BlocEvent {
  final DeckFormBehavior formBehavior;
  final DeckModel deck;
  final List<BoxModel> boxes;
  final List<CardModel> cards;

  Submit({
    @required this.formBehavior,
    @required this.deck,
    @required this.boxes,
    @required this.cards,
  })
      : assert(formBehavior != null),
        assert(deck != null),
        assert(boxes != null),
        assert(cards != null);

  @override
  Stream<BlocState> mapToState(DeckFormBloc bloc) async* {
    final deckFacade = bloc.deckFacade;

    yield SubmittingState();

    switch (formBehavior) {
      case DeckFormBehavior.createDeck:
        await deckFacade.create(CreateDeckRequest.fromModels(
          deck: deck,
          boxes: boxes,
          cards: cards,
        ));

        break;

      case DeckFormBehavior.editDeck:
        await deckFacade.update(UpdateDeckRequest.fromModels(
          oldDeck: await deckFacade.findById(deck.id),
          newDeck: deck,

          oldBoxes: await deckFacade.findBoxes(deck),
          newBoxes: boxes,

          oldCards: await deckFacade.findCards(deck),
          newCards: cards,
        ));

        break;
    }

    yield SubmittedState();
  }
}
