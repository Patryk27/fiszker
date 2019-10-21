import 'package:fiszker/frontend.dart' as frontend;
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import 'selection/item.dart';

class ExerciseSelection extends StatelessWidget {
  final void Function(String) onExerciseSelected;

  ExerciseSelection({
    @required this.onExerciseSelected,
  }) : assert(onExerciseSelected != null);

  @override
  Widget build(BuildContext context) {
    return frontend.BottomSheet(
      title: Optional.of('Wybierz ćwiczenie'),

      body: ListView(
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
    );
  }
}
