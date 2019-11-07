import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import '../../bloc.dart';

class CreateBox extends DeckFormBlocEvent {
  final DeckEntity deck;
  final BoxModel box;

  CreateBox(this.deck, this.box)
      : assert(deck != null),
        assert(box != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    // Add box to the deck
    deck.boxes.add(box);

    // Save changes
    bloc.add(Submit(deck, successNotification: BoxCreated()));
  }
}
