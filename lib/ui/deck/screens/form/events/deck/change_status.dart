import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import '../../bloc.dart';

class ChangeDeckStatus extends DeckFormBlocEvent {
  final DeckEntity deck;
  final DeckStatus status;

  ChangeDeckStatus(this.deck, this.status)
      : assert(deck != null),
        assert(status != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    final deck = this.deck.copyWith(
      deck: this.deck.deck.copyWith(
        status: status,
      ),
    );

    bloc.add(Submit(deck, successNotification: DeckStatusChanged()));
  }
}
