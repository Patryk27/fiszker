import 'package:optional/optional.dart';

import '../bloc.dart';

class Continue extends PlayingBlocEvent {
  @override
  Stream<PlayingBlocState> mapToState(PlayingBloc bloc) async* {
    // Determine which card is going to be the next one
    final nextCard = bloc.exercise.pendingCards.removeAt(0);

    // Animate the "shifting cards" thingy
    yield ShiftingCards(
      Optional.of(bloc.exercise.currentCard),
      Optional.of(nextCard),
    );

    // Wait until the "shifting cards" animation completes
    await Future.delayed(SHIFTING_CARDS_ANIMATION_DURATION);

    // Actually change the currently visible card and show the question
    bloc.exercise.currentCard = nextCard;

    yield ShowingQuestion();
  }
}
