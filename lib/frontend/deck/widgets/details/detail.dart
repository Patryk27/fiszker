import 'package:flutter/material.dart';

class DeckDetail extends StatelessWidget {
  final String title;
  final String value;

  DeckDetail({
    @required this.title,
    @required this.value,
  })
      : assert(title != null),
        assert(value != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Text(title),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
