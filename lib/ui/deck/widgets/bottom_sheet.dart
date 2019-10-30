import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class DeckBottomSheet extends StatefulWidget {
  final DeckEntity deck;
  final void Function() onEditPressed;
  final void Function() onDeletePressed;
  final void Function(String exercise) onExerciseSelected;

  DeckBottomSheet({
    @required this.deck,
    @required this.onEditPressed,
    @required this.onDeletePressed,
    @required this.onExerciseSelected,
  })
      :
        assert(deck != null),
        assert(onEditPressed != null),
        assert(onDeletePressed != null),
        assert(onExerciseSelected != null);

  @override
  State<DeckBottomSheet> createState() => _DeckBottomSheetState();
}

class _DeckBottomSheetState extends State<DeckBottomSheet> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: crossFadeState,
      duration: const Duration(milliseconds: 250),

      firstChild: DeckDetails(
        deck: widget.deck,
        onEditPressed: widget.onEditPressed,
        onDeletePressed: widget.onDeletePressed,
        onExercisePressed: buildOnExercisePressed(),
      ),

      secondChild: ExerciseSelection(
        onExerciseSelected: widget.onExerciseSelected,
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
