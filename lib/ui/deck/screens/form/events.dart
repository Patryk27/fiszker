import 'package:flutter/material.dart';

import 'bloc.dart';
import 'states.dart';

export 'events/box/create.dart';
export 'events/box/delete.dart';
export 'events/box/move.dart';
export 'events/box/update.dart';
export 'events/card/create.dart';
export 'events/card/delete.dart';
export 'events/card/update.dart';
export 'events/deck/change_name.dart';
export 'events/deck/change_status.dart';
export 'events/initialize.dart';
export 'events/submit.dart';

@immutable
abstract class DeckFormBlocEvent {
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc);
}
