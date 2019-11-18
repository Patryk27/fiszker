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
    final cardIdx = deck.cards.indexWhere((card) {
      return card.id == this.card.id;
    });

    if (cardIdx >= 0) {
      deck.cards[cardIdx] = card;
      bloc.add(Submit(deck, successNotification: CardUpdated()));
    }
  }
}
