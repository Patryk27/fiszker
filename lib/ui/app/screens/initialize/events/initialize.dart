import 'package:fiszker/debug.dart';

import '../bloc.dart';

class Initialize extends AppInitializeBlocEvent {
  @override
  Stream<AppInitializeBlocState> mapToState(AppInitializeBloc bloc) async* {
    // Initialize the database, if applicable
    if (!DEBUG_ENABLE_IN_MEMORY_REPOSITORIES) {
      await bloc.databaseProvider.initialize();
    }

    // If everything's ready, let's finish this shirt
    yield InitializedState();
  }
}
