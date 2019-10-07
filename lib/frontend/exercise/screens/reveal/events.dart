import 'package:flutter/material.dart';

import 'bloc.dart';
import 'states.dart';

export 'events/finish.dart';
export 'events/restart.dart';
export 'events/start.dart';

@immutable
abstract class BlocEvent {
  Stream<BlocState> mapToState(ExerciseRevealBloc bloc);
}
