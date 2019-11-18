import 'package:fiszker/domain.dart';

import '../bloc.dart';

class Finalize extends RevealExerciseBlocEvent {
  final Exercise exercise;

  Finalize(this.exercise)
      : assert(exercise != null);

  @override
  Stream<RevealExerciseBlocState> mapToState(RevealExerciseBloc bloc) async* {
    yield Finishing(
      exercise: exercise,
    );

    await bloc.exerciseFacade.commit(exercise);
  }
}
