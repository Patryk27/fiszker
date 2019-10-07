import 'bloc.dart';
import 'states.dart';

export 'events/initialize.dart';

abstract class BlocEvent {
  Stream<BlocState> mapToState(AppInitializeBloc bloc);
}
