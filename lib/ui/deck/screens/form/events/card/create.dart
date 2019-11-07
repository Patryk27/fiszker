import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import '../../bloc.dart';

class CreateCard extends DeckFormBlocEvent {
  final DeckEntity deck;
  final CardModel card;

  CreateCard(this.deck, this.card)
      : assert(deck != null),
        assert(card != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    // Add card to the deck
    deck.cards.add(card);

    // Save changes
    bloc.add(Submit(deck, successNotification: CardCreated()));
  }
}
