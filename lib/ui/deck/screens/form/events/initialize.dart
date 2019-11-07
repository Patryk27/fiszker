import 'package:fiszker/database.dart';
import 'package:fiszker/ui.dart';

import '../bloc.dart';

/// Initializes the system.
///
/// Should be dispatched as soon as possible, since otherwise the system will remain [Uninitialized], rendering
/// user unable to do anything.
class Initialize extends DeckFormBlocEvent {
  final Id deckId;

  Initialize(this.deckId)
      : assert(deckId != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    yield Initialized(
      deck: await bloc.deckFacade.findById(deckId),
    );
  }
}
