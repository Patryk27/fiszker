import 'package:flutter/material.dart';

class ExerciseSelectionItem extends StatelessWidget {
  final String name;
  final String description;
  final void Function() onTapped;

  ExerciseSelectionItem({
    @required this.name,
    @required this.description,
    @required this.onTapped,
  })
      : assert(name != null),
        assert(description != null),
        assert(onTapped != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: ListTile(
        title: Text(name),

        subtitle: Text(
          description,
          textAlign: TextAlign.justify,
          textScaleFactor: 0.9,
        ),
      ),
    );
  }
}
