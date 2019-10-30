import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class Uninitialized extends RevealExerciseBlocState {
  @override
  Widget buildWidget() =>
      const LoadingScreen(
        title: 'Odkrywanie',
        message: 'Trwa wczytywanie ćwiczenia...',
        includeScaffold: false,
      );
}
