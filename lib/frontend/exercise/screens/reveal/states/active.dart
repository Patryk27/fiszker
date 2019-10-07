import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import '../states.dart';
import '../views.dart';

class ActiveState extends BlocState {
  final DeckViewModel deck;

  ActiveState({
    @required this.deck,
  }) : assert(deck != null);

  @override
  Widget render() {
    return ActiveView(state: this);
  }
}
