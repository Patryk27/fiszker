import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class Uninitialized extends DeckIndexBlocState {
  @override
  Widget buildWidget() =>
      const LoadingScreen(
        title: 'Fiszker',
        message: 'Trwa wczytywanie...',
      );
}
