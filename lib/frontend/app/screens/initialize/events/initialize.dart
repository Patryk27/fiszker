import 'package:fiszker/debug.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';

class Initialize extends BlocEvent {
  @override
  Stream<BlocState> mapToState(AppInitializeBloc bloc) async* {
    // Initialize the database, if applicable
    if (!DEBUG_ENABLE_IN_MEMORY_REPOSITORIES) {
      await bloc.databaseProvider.open();
    }

    // If everything's ready, let's finish this shirt
    yield InitializedState();
  }
}
