import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:timeago/timeago.dart' as timeago;

class Detail extends StatelessWidget {
  final String title;
  final Optional<String> value;

  Detail({
    @required this.title,
    @required this.value,
  })
      : assert(title != null),
        assert(value != null);

  Detail.ago({
    @required this.title,
    @required Optional<DateTime> value,
  }) : value = value.map(timeago.format);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Text(title),

        Text(
          value.orElse('-'),

          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
