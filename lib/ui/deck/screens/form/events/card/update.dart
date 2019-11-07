import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import '../../bloc.dart';

class UpdateCard extends DeckFormBlocEvent {
  final DeckEntity deck;
  final CardModel card;

  UpdateCard(this.deck, this.card)
      : assert(deck != null),
        assert(card != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    // Locate card in the deck
    final cardIdx = deck.cards.indexWhere((card) {
      return card.id == this.card.id;
    });

    if (cardIdx < 0) {
      return;
    }

    // Update card
    deck.cards[cardIdx] = card;

    // Save changes
    bloc.add(Submit(deck, successNotification: CardUpdated()));
  }
}
