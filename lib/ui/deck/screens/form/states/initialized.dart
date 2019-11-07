import 'package:fiszker/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class Initialized extends DeckFormBlocState {
  final DeckEntity deck;

  Initialized({
    @required this.deck,
  }) : assert(deck != null);
}
