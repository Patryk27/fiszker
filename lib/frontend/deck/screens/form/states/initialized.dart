import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import '../states.dart';
import '../views.dart';

/// This class models a state where the system has loaded everything from the database and now its patiently waiting
/// for user to either modify the form or press the "Submit" button.
class InitializedState extends BlocState {
  final DeckFormBehavior formBehavior;
  final DeckViewModel deck;

  InitializedState({
    @required this.formBehavior,
    @required this.deck,
  })
      : assert(formBehavior != null),
        assert(deck != null);

  @override
  Widget render() {
    return InitializedView(state: this);
  }
}
