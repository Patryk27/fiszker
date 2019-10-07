import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';

class DeleteDeck extends BlocEvent {
  DeleteDeck({
    @required this.deck,
  }) : assert(deck != null);

  final DeckModel deck;

  @override
  Stream<BlocState> mapToState(DeckIndexBloc bloc) async* {
    // Show the progress bar
    yield UninitializedState();

    // Actually delete the deck
    await bloc.deckFacade.delete(deck);
  }
}
