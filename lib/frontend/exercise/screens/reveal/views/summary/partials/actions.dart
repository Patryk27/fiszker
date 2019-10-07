import 'package:flutter/material.dart';

class SummaryActions extends StatelessWidget {
  final void Function() onRestartPressed;
  final void Function() onFinishPressed;

  SummaryActions({
    @required this.onRestartPressed,
    @required this.onFinishPressed,
  })
      : assert(onRestartPressed != null),
        assert(onFinishPressed != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // "Restart" button
        RaisedButton(
          child: const Text('POWTÓRZ ĆWICZENIE'),
          color: Colors.amber,
          onPressed: onRestartPressed,
        ),

        // Separator
        const SizedBox(width: 15),

        // "Finish" button
        RaisedButton(
          child: const Text('ZAKOŃCZ'),
          color: Colors.lightBlue,
          onPressed: onFinishPressed,
        ),
      ],
    );
  }
}
