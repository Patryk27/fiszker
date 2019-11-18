import '../bloc.dart';

class CreateDeck extends DeckIndexBlocEvent {
  final String deckName;

  CreateDeck(this.deckName)
      : assert(deckName != null);

  @override
  Stream<DeckIndexBlocState> mapToState(DeckIndexBloc bloc) async* {
    // Note: we don't have to show a progress bar at this point, since the bottom sheet (_CreateDeckForm) is still
    // visible and it gives user the hint that something's happening in the background

    yield DeckCreated(
      await bloc.deckFacade.create(deckName),
    );
  }
}
