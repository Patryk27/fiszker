import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import '../../bloc.dart';

class MoveBox extends DeckFormBlocEvent {
  final DeckEntity deck;
  final BoxModel box;
  final int newIndex;

  MoveBox(this.deck, this.box, this.newIndex)
      : assert(deck != null),
        assert(box != null),
        assert(newIndex != null),
        assert(newIndex >= 0),
        assert(newIndex <= deck.boxes.length);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    int oldIndex = box.index;

    // Update boxes
    final boxes = deck.boxes.map((box) {
      if (box.id == this.box.id) {
        return box.copyWith(index: newIndex);
      }

      if (newIndex < oldIndex) {
        if (box.index >= newIndex && box.index < oldIndex) {
          return box.copyWith(index: box.index + 1);
        }
      } else {
        if (box.index > oldIndex && box.index <= newIndex) {
          return box.copyWith(index: box.index - 1);
        }
      }

      return box;
    }).toList();

    // Save changes
    bloc.add(Submit(deck.copyWith(
      boxes: boxes,
    )));
  }
}
