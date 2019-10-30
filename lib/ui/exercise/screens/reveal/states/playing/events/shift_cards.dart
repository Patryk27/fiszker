import '../bloc.dart';

class ShiftCards extends PlayingBlocEvent {
  ShiftCards();

  @override
  Stream<PlayingBlocState> mapToState(PlayingBloc bloc) async* {
    // Two things can happen now:
    //
    //   a) there are no more cards left (that is: the user has gone through all the cards from this box) and we
    //      should proceed to the finalization screen
    //
    //   b) there are some cards left and we should proceed to the next card

    if (bloc.exercise.pendingCards.isEmpty) {
      bloc.add(Finish());
    } else {
      bloc.add(Continue());
    }
  }
}
