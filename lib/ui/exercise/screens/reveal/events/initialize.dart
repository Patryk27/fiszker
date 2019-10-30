import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class Initialize extends RevealExerciseBlocEvent {
  final Id deckId;

  Initialize({
    @required this.deckId,
  }) : assert(deckId != null);

  @override
  Stream<RevealExerciseBlocState> mapToState(RevealExerciseBloc bloc) async* {
    yield SettingUp(
      deck: await bloc.deckFacade.findById(deckId),
    );
  }
}
