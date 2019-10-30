import '../bloc.dart';

class ShowBoxes extends FinishingBlocEvent {
  @override
  Stream<FinishingBlocState> mapToState(FinishingBloc bloc) async* {
    yield ShowingBoxes();
  }
}
