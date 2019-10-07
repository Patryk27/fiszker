import 'package:flutter/material.dart';

import 'bloc.dart';
import 'states.dart';

export 'events/initialize.dart';
export 'events/submit.dart';

@immutable
abstract class BlocEvent {
  Stream<BlocState> mapToState(DeckFormBloc bloc);
}
