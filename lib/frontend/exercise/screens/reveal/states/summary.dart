import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import '../misc.dart';
import '../states.dart';
import '../views.dart';

class SummaryState extends BlocState {
  final DeckViewModel deck;
  final Answers answers;

  SummaryState({
    @required this.deck,
    @required this.answers,
  })
      : assert(deck != null),
        assert(answers != null);

  @override
  Widget render() {
    return SummaryView(state: this);
  }
}
