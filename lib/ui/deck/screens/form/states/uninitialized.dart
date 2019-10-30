import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

/// This class models a state where the system is awaiting the [Initialize] event.
/// At this point the form cannot be rendered yet, because we are waiting for database.
class Uninitialized extends DeckFormBlocState {
  @override
  Widget buildWidget() =>
      const LoadingScreen(
        title: 'Fiszker',
        message: 'Trwa wczytywanie...',
      );
}
