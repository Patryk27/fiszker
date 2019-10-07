import 'package:flutter/material.dart';

class AwaitingStart extends StatelessWidget {
  final void Function() onStartPressed;

  AwaitingStart({
    @required this.onStartPressed,
  }) : assert(onStartPressed != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: const Padding(
          padding: const EdgeInsets.all(20),
          child: const Text('ROZPOCZNIJ ĆWICZENIE'),
        ),

        color: Theme
            .of(context)
            .primaryColor,

        onPressed: onStartPressed,
      ),
    );
  }
}
