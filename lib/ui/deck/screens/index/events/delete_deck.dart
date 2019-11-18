import 'package:fiszker/domain.dart';

import '../bloc.dart';

class DeleteDeck extends DeckIndexBlocEvent {
  final DeckEntity deck;

  DeleteDeck(this.deck)
      : assert(deck != null);

  @override
  Stream<DeckIndexBlocState> mapToState(DeckIndexBloc bloc) async* {
    // Show the progress bar
    yield Uninitialized();

    // Actually delete the deck
    await bloc.deckFacade.delete(deck);
  }
}
