import '../bloc.dart';

class Answer extends PlayingBlocEvent {
  final bool isCorrect;

  Answer(this.isCorrect)
      : assert(isCorrect != null);

  @override
  Stream<PlayingBlocState> mapToState(PlayingBloc bloc) async* {
    // Register answer
    bloc.exercise.addAnswer(bloc.exercise.currentCard, isCorrect);

    // Move to the next card
    bloc.add(ShiftCards());
  }
}
