import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:optional/optional.dart';

import '../../bloc.dart';

class DeleteBox extends DeckFormBlocEvent {
  final DeckEntity deck;
  final BoxModel box;

  DeleteBox(this.deck, this.box)
      : assert(deck != null),
        assert(box != null);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    var boxes = deck.boxes;
    var cards = deck.cards;

    // Since we're deleting a box, we have to decide what happens to all the cards that are currently located inside
    // it - they should be moved either to the next box or to the previous one.
    Optional<BoxModel> boxSuccessor = deck.findBoxSuccessor(box);
    Optional<BoxModel> boxPredecessor = deck.findBoxPredecessor(box);

    BoxModel targetBox = boxSuccessor.isPresent
        ? boxSuccessor.value
        : boxPredecessor.value;

    // Relocate cards to the target box
    cards = cards.map((card) {
      return card.copyWith(
        boxId: card.belongsToBox(box)
            ? targetBox.id
            : card.boxId,
      );
    }).toList();

    // Remove the box
    boxes.removeWhere((box) {
      return box.id == this.box.id;
    });

    // Re-index boxes, so that we don't end up with a hole in our numeration
    boxes = boxes.map((box) {
      return box.copyWith(
        index: (box.index >= this.box.index)
            ? (box.index - 1)
            : box.index,
      );
    }).toList();

    // And now, eventually, we can safely save the changes
    bloc.add(Submit(
      deck.copyWith(boxes: boxes, cards: cards),
      successNotification: BoxDeleted(),
    ));
  }
}
