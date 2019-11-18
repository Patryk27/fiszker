import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class DeckCreated extends DeckIndexBlocState {
  final Id deckId;

  DeckCreated(this.deckId)
      : assert(deckId != null);

  @override
  void onEntered(GlobalKey<ScaffoldState> scaffoldKey) async {
    // Open the deck editor
    await Navigator.pushReplacementNamed(scaffoldKey.currentContext, 'decks--edit', arguments: deckId);

    // After the editor closes, refresh the decks
    DeckIndexBloc
        .of(scaffoldKey.currentContext)
        .add(Refresh());
  }
}
