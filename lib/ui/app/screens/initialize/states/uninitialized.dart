import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class UninitializedState extends AppInitializeBlocState {
  @override
  Widget buildWidget() =>
      const LoadingScreen(
        title: 'Fiszker',
        message: 'Trwa wczytywanie aplikacji - jeszcze sekundka...',
      );
}
