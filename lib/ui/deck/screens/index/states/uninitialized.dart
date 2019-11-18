import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../bloc.dart';

class Uninitialized extends DeckIndexBlocState {
  @override
  Optional<Widget> buildWidget(_) =>
      Optional.of(const LoadingScreen(
        title: 'Fiszker',
        message: 'Trwa wczytywanie...',
      ));
}
