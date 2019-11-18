import 'package:optional/optional.dart';

import '../bloc.dart';

class Finish extends PlayingBlocEvent {
  @override
  Stream<PlayingBlocState> mapToState(PlayingBloc bloc) async* {
    // Since we're finishing the exercise, we won't be needing the overlay no more
    bloc.showOverlay = false;

    // Animate the "shifting cards" thingy
    yield ShiftingCards(
      Optional.of(bloc.exercise.currentCard),
      const Optional.empty(),
    );

    // Wait until the "shifting cards" animation completes
    await Future.delayed(SHIFTING_CARDS_ANIMATION_DURATION);

    // Move to the "finished" state - it'll get us to the "finishing" screen
    yield Finished();
  }
}
