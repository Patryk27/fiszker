import '../bloc.dart';

class ShowAnswer extends PlayingBlocEvent {
  ShowAnswer();

  @override
  Stream<PlayingBlocState> mapToState(PlayingBloc bloc) async* {
    yield ShowingAnswer();
  }
}
