import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../bloc.dart';

/// Initializes the system.
///
/// Should be dispatched as soon as possible, since otherwise the system will remain [Uninitialized], rendering
/// user unable to do anything.
class Initialize extends DeckFormBlocEvent {
  final Optional<Id> deckId;

  Initialize({
    @required this.deckId,
  }) : assert(deckId != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    if (deckId.isPresent) {
      yield Initialized(
        formBehavior: DeckFormBehavior.editDeck,
        deck: await bloc.deckFacade.findById(deckId.value),
      );
    } else {
      yield Initialized(
        formBehavior: DeckFormBehavior.createDeck,
        deck: DeckEntity.create(),
      );
    }
  }
}
