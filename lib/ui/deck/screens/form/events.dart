import 'package:flutter/material.dart';

import 'bloc.dart';
import 'states.dart';

export 'events/initialize.dart';
export 'events/submit.dart';

@immutable
abstract class DeckFormBlocEvent {
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc);
}
