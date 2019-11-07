import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

typedef void DeckActionsEditHandler();
typedef void DeckActionsDeleteHandler();
typedef void DeckActionsExerciseHandler(String exercise);

void showDeckActions({
  @required BuildContext context,
  @required DeckEntity deck,
  @required DeckActionsEditHandler onEdit,
  @required DeckActionsDeleteHandler onDelete,
  @required DeckActionsExerciseHandler onExercise,
}) {
  showModalBottomSheet(
    context: context,

    builder: (context) {
      return _DeckActions(
        deck: deck,
        onEdit: onEdit,
        onDelete: onDelete,
        onExercise: onExercise,
      );
    },
  );
}

class _DeckActions extends StatefulWidget {
  final DeckEntity deck;
  final DeckActionsEditHandler onEdit;
  final DeckActionsDeleteHandler onDelete;
  final DeckActionsExerciseHandler onExercise;

  _DeckActions({
    @required this.deck,
    @required this.onEdit,
    @required this.onDelete,
    @required this.onExercise,
  })
      : assert(deck != null),
        assert(onEdit != null),
        assert(onDelete != null),
        assert(onExercise != null);

  @override
  State<_DeckActions> createState() => _DeckActionsState();
}

class _DeckActionsState extends State<_DeckActions> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: crossFadeState,
      duration: const Duration(milliseconds: 250),

      firstChild: DeckDetails(
        deck: widget.deck,
        onEditPressed: widget.onEdit,
        onDeletePressed: widget.onDelete,
        onExercisePressed: buildOnExercisePressed(),
      ),

      secondChild: ExerciseSelection(
        onExerciseSelected: widget.onExercise,
      ),
    );
  }

  /// Prepares value for the [DeckDetails.onExercisePressed] field.
  Optional<void Function()> buildOnExercisePressed() {
    // If our deck is empty, there's no point in letting user press the "Exercise" button
    if (widget.deck.cards.isEmpty) {
      return const Optional.empty();
    }

    return Optional.of(() {
      setState(() {
        crossFadeState = CrossFadeState.showSecond;
      });
    });
  }
}
