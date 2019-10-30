import '../bloc.dart';

class Finish extends FinishingBlocEvent {
  @override
  Stream<FinishingBlocState> mapToState(FinishingBloc bloc) async* {
    yield Finishing();
  }
}
