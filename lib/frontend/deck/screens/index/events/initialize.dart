import '../bloc.dart';
import '../events.dart';
import '../states.dart';

class Initialize extends BlocEvent {
  @override
  Stream<BlocState> mapToState(DeckIndexBloc bloc) async* {
    yield await InitializedState.create(bloc);
  }
}
