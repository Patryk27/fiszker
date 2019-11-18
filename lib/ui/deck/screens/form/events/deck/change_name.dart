import 'package:fiszker/domain.dart';

import '../../bloc.dart';

class ChangeDeckName extends DeckFormBlocEvent {
  final DeckEntity deck;
  final String name;

  ChangeDeckName(this.deck, this.name)
      : assert(deck != null),
        assert(name != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    final deck = this.deck.copyWith(
      deck: this.deck.deck.copyWith(name: name),
    );

    bloc.add(Submit(deck));
  }
}
