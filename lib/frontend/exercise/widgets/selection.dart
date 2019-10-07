import 'package:flutter/material.dart';

import 'selection/item.dart';

class ExerciseSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wybierz ćwiczenie'),
      contentPadding: const EdgeInsets.only(left: 10, top: 24, right: 10, bottom: 15),

      content: Container(
        width: double.maxFinite,

        child: ListView(
          shrinkWrap: true,

          children: [
            ExerciseSelectionItem(
              name: 'Odkrywanie',
              description: 'Z zestawu zostaje wylosowana jedna karta, pokazywana jest Ci jej jedna strona, a Twoim zadaniem jest przypomnieć sobie zawartość drugiej.',
              onTapped: () {
                Navigator.pop(context, 'reveal');
              },
            ),
          ],
        ),
      ),
    );
  }
}
