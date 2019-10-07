import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../misc.dart';
import '../states.dart';

class Finish extends BlocEvent {
  final DeckViewModel deck;
  final Answers answers;

  Finish({
    @required this.deck,
    @required this.answers,
  })
      : assert(deck != null),
        assert(answers != null);

  @override
  Stream<BlocState> mapToState(ExerciseRevealBloc bloc) async* {
    // Update the "exercised at" date
    await bloc.deckFacade.touchExercisedAt(deck.deck);

    // Prepare the summary view
    yield SummaryState(
      deck: deck,
      answers: answers,
    );
  }
}
