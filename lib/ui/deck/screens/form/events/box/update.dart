import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import '../../bloc.dart';

class UpdateBox extends DeckFormBlocEvent {
  final DeckEntity deck;
  final BoxModel box;

  UpdateBox(this.deck, this.box)
      : assert(deck != null),
        assert(box != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    // Locate box in the deck
    final boxIdx = deck.boxes.indexWhere((box) {
      return box.id == this.box.id;
    });

    if (boxIdx < 0) {
      return;
    }

    // Update box
    deck.boxes[boxIdx] = box;

    // Save changes
    bloc.add(Submit(deck, successNotification: BoxUpdated()));
  }
}
