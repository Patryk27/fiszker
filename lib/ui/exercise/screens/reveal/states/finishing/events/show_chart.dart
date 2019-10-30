import '../bloc.dart';

class ShowChart extends FinishingBlocEvent {
  @override
  Stream<FinishingBlocState> mapToState(FinishingBloc bloc) async* {
    yield ShowingChart();
  }
}
