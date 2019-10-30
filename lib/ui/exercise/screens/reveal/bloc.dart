import 'package:bloc/bloc.dart';
import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class RevealExerciseBloc extends Bloc<RevealExerciseBlocEvent, RevealExerciseBlocState> {
  final DeckFacade deckFacade;
  final ExerciseFacade exerciseFacade;

  RevealExerciseBloc({
    @required this.deckFacade,
    @required this.exerciseFacade,
  })
      : assert(deckFacade != null),
        assert(exerciseFacade != null);

  /// Returns [RevealExerciseBloc] related to given [context].
  /// See: [BlocProvider.of].
  static RevealExerciseBloc of(BuildContext context) => BlocProvider.of<RevealExerciseBloc>(context);

  @override
  RevealExerciseBlocState get initialState => Uninitialized();

  @override
  Stream<RevealExerciseBlocState> mapEventToState(RevealExerciseBlocEvent event) => event.mapToState(this);
}
