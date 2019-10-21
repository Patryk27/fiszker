import 'package:fiszker/frontend.dart';
import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

import 'selection/item.dart';

class ExerciseSelection extends StatelessWidget {
  final void Function(String) onExerciseSelected;

  ExerciseSelection({
    @required this.onExerciseSelected,
  }) : assert(onExerciseSelected != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DIALOG_PADDING),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          const BottomSheetTitle(
            title: 'Wybierz ćwiczenie',
          ),

          ListView(
            primary: false,
            shrinkWrap: true,

            children: [
              ExerciseSelectionItem(
                name: 'Odkrywanie',
                description: 'Z zestawu zostaje wylosowana jedna karta, pokazywana jest Ci jej jedna strona, a Twoim zadaniem jest przypomnieć sobie zawartość drugiej.',

                onTapped: () {
                  onExerciseSelected('reveal');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
