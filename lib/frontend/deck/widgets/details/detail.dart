import 'package:flutter/material.dart';

class DetailsDetail extends StatelessWidget {
  DetailsDetail({
    @required this.title,
    @required this.value,
  })
      : assert(title != null),
        assert(value != null);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
