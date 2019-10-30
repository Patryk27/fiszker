import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc.dart';
import 'playing/bloc.dart';
import 'playing/screen.dart';

class Playing extends RevealExerciseBlocState {
  final DeckEntity deck;
  final BoxModel box;
  final ExerciseMode mode;

  Playing({
    @required this.deck,
    @required this.box,
    @required this.mode,
  })
      : assert(deck != null),
        assert(box != null),
        assert(mode != null);

  @override
  Widget buildWidget() {
    return BlocProvider<PlayingBloc>(
      builder: (context) {
        final exerciseFacade = RevealExerciseBloc
            .of(context)
            .exerciseFacade;

        return PlayingBloc(
          exercise: exerciseFacade.start(deck, box, mode),
        );
      },

      child: PlayingScreen(),
    );
  }
}
