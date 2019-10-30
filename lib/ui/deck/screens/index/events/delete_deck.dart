import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class DeleteDeck extends DeckIndexBlocEvent {
  DeleteDeck({
    @required this.deck,
  }) : assert(deck != null);

  final DeckEntity deck;

  @override
  Stream<DeckIndexBlocState> mapToState(DeckIndexBloc bloc) async* {
    // Show the progress bar
    yield Uninitialized();

    // Actually delete the deck
    await bloc.deckFacade.delete(deck);
  }
}
