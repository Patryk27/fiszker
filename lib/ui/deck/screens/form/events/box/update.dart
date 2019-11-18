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
    final boxIdx = deck.boxes.indexWhere((box) {
      return box.id == this.box.id;
    });

    if (boxIdx >= 0) {
      deck.boxes[boxIdx] = box;
      bloc.add(Submit(deck, successNotification: BoxUpdated()));
    }
  }
}
