import 'package:optional/optional.dart';

import '../bloc.dart';

class Start extends PlayingBlocEvent {
  @override
  Stream<PlayingBlocState> mapToState(PlayingBloc bloc) async* {
    // Let's animate-in the first card
    yield ShiftingCards(
      previousCard: Optional.empty(),
      nextCard: Optional.of(bloc.exercise.currentCard),
    );

    // Wait until the "shifting cards" animation completes
    await Future.delayed(SHIFTING_CARDS_ANIMATION_DURATION);

    // Since we're starting the exercise, it'd be nice to show the overlay
    bloc.showOverlay = true;

    // Show the card's question
    yield ShowingQuestion();
  }
}
