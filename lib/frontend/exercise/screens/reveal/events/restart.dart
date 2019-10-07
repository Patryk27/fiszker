import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';

class Restart extends BlocEvent {
  final DeckViewModel deck;

  Restart({
    @required this.deck,
  }) : assert(deck != null);

  @override
  Stream<BlocState> mapToState(ExerciseRevealBloc bloc) async* {
    yield ActiveState(
      deck: deck,
    );
  }
}
