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
    deck.cards.add(card);
    bloc.add(Submit(deck, successNotification: CardCreated()));
  }
}
