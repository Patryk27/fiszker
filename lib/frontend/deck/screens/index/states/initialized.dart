import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../states.dart';
import '../views.dart';

class InitializedState extends BlocState {
  final List<DeckViewModel> activeDecks;
  final List<DeckViewModel> archivedDecks;
  final List<DeckViewModel> completedDecks;

  InitializedState({
    @required this.activeDecks,
    @required this.archivedDecks,
    @required this.completedDecks,
  })
      : assert(activeDecks != null),
        assert(archivedDecks != null),
        assert(completedDecks != null);

  static create(DeckIndexBloc bloc) async {
    final deckFacade = bloc.deckFacade;

    return InitializedState(
      activeDecks: await deckFacade.upgradeMany(
        await deckFacade.findByStatus(DeckStatus.active),
      ),

      archivedDecks: await deckFacade.upgradeMany(
        await deckFacade.findByStatus(DeckStatus.archived),
      ),

      completedDecks: await deckFacade.upgradeMany(
        await deckFacade.findByStatus(DeckStatus.completed),
      ),
    );
  }

  @override
  Widget render() {
    return InitializedView(
      state: this,
    );
  }
}
