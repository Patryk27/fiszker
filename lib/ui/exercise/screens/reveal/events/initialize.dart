import 'package:fiszker/database.dart';

import '../bloc.dart';

class Initialize extends RevealExerciseBlocEvent {
  final Id deckId;

  Initialize(this.deckId)
      : assert(deckId != null);

  @override
  Stream<RevealExerciseBlocState> mapToState(RevealExerciseBloc bloc) async* {
    yield SettingUp(
      deck: await bloc.deckFacade.findById(deckId),
    );
  }
}
