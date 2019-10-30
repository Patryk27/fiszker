import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class Finalize extends RevealExerciseBlocEvent {
  final Exercise exercise;

  Finalize({
    @required this.exercise,
  }) : assert(exercise != null);

  @override
  Stream<RevealExerciseBlocState> mapToState(RevealExerciseBloc bloc) async* {
    yield Finishing(
      exercise: exercise,
    );

    await bloc.exerciseFacade.commit(exercise);
  }
}
