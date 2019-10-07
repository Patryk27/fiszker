import '../bloc.dart';
import '../events.dart';
import '../states.dart';

class Refresh extends BlocEvent {
  @override
  Stream<BlocState> mapToState(DeckIndexBloc bloc) async* {
    yield UninitializedState();
    yield await InitializedState.create(bloc);
  }
}
