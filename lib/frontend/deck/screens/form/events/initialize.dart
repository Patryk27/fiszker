import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';

/// Initializes the system.
///
/// Should be dispatched as soon as possible, since otherwise the system will remain [UninitializedState] and thus user will
/// not be able to do anything.
class Initialize extends BlocEvent {
  final DeckFormBehavior formBehavior;
  final DeckModel deck;

  Initialize({
    @required this.formBehavior,
    @required this.deck,
  })
      : assert(formBehavior != null),
        assert(deck != null);

  @override
  Stream<BlocState> mapToState(DeckFormBloc bloc) async* {
    yield InitializedState(
      formBehavior: formBehavior,
      deck: deck,
      cards: await bloc.deckFacade.findCards(deck),
    );
  }
}
