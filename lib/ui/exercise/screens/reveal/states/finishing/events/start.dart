import '../bloc.dart';

class Start extends FinishingBlocEvent {
  @override
  Stream<FinishingBlocState> mapToState(FinishingBloc bloc) async* {
    bloc.add(ShowChart());
  }
}
