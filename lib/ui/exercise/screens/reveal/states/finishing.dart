import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc.dart';
import 'finishing/bloc.dart';
import 'finishing/screen.dart';

class Finishing extends RevealExerciseBlocState {
  final Exercise exercise;

  Finishing({
    @required this.exercise,
  }) : assert(exercise != null);

  @override
  Widget buildWidget() {
    return BlocProvider<FinishingBloc>(
      builder: (context) {
        return FinishingBloc(exercise: exercise);
      },

      child: FinishingScreen(),
    );
  }
}
