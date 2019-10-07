import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';

class Start extends BlocEvent {
  final DeckModel deck;

  Start({
    @required this.deck,
  }) : assert(deck != null);

  @override
  Stream<BlocState> mapToState(ExerciseRevealBloc bloc) async* {
    yield ActiveState(
      deck: await bloc.deckFacade.upgrade(deck),
    );
  }
}
