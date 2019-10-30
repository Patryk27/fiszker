import 'package:flutter/material.dart';

import 'bloc.dart';

export 'events/initialize.dart';
export 'events/start.dart';

@immutable
abstract class RevealExerciseBlocEvent {
  Stream<RevealExerciseBlocState> mapToState(RevealExerciseBloc bloc);
}
