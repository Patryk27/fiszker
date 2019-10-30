import 'bloc.dart';
import 'states.dart';

export 'events/initialize.dart';

abstract class AppInitializeBlocEvent {
  Stream<AppInitializeBlocState> mapToState(AppInitializeBloc bloc);
}
