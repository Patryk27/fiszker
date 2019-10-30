import 'package:flutter/material.dart';

import 'bloc.dart';

export 'events/answer.dart';
export 'events/continue.dart';
export 'events/finish.dart';
export 'events/shift_cards.dart';
export 'events/show_answer.dart';
export 'events/start.dart';

@immutable
abstract class PlayingBlocEvent {
  Stream<PlayingBlocState> mapToState(PlayingBloc bloc);
}
