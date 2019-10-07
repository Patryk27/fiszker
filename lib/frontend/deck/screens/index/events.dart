import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import 'states.dart';

export 'events/delete_deck.dart';
export 'events/initialize.dart';
export 'events/refresh.dart';

@immutable
abstract class BlocEvent {
  Stream<BlocState> mapToState(DeckIndexBloc bloc);
}
