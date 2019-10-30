import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

/// This class models a state where the system is during committing data into the database.
/// At this point the form cannot be modified anymore.
class Submitting extends DeckFormBlocState {
  @override
  Widget buildWidget() =>
      const LoadingScreen(
        title: 'Tworzenie zestawu fiszek', // @todo or editing
        message: 'Trwa zapisywanie...',
      );
}
