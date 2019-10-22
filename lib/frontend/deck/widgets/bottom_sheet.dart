import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class DeckBottomSheet extends StatefulWidget {
  final DeckViewModel deck;
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
  _DeckBottomSheetState createState() {
    return _DeckBottomSheetState();
  }
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

        onExercisePressed: () {
          setState(() {
            crossFadeState = CrossFadeState.showSecond;
          });
        },
      ),

      secondChild: ExerciseSelection(
        onExerciseSelected: widget.onExerciseSelected,
      ),
    );
  }
}
