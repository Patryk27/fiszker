import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import '../../bloc.dart';

class DeleteCard extends DeckFormBlocEvent {
  final DeckEntity deck;
  final CardModel card;

  DeleteCard(this.deck, this.card)
      : assert(deck != null),
        assert(card != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    // Remove card from the deck
    deck.cards.removeWhere((card) {
      return card.id == this.card.id;
    });

    // Save changes
    bloc.add(Submit(deck, successNotification: CardDeleted()));
  }
}
