import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import '../states.dart';
import '../views.dart';

/// This class models a state where the system has loaded everything from the database and now its patiently waiting
/// for user to either modify the form or press the `Save` button.
class InitializedState extends BlocState {
  final DeckFormBehavior formBehavior;
  final DeckModel deck;
  final List<CardModel> cards;

  InitializedState({
    @required this.formBehavior,
    @required this.deck,
    @required this.cards
  })
      : assert(formBehavior != null),
        assert(deck != null),
        assert(cards != null);

  @override
  Widget render() {
    return InitializedView(state: this);
  }
}
