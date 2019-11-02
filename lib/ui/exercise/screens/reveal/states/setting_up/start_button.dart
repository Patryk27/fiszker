import 'package:flutter/material.dart';

class SettingUpStartButton extends StatelessWidget {
  final VoidCallback onPressed;

  SettingUpStartButton({
    @required this.onPressed,
  }) : assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: const Padding(
        padding: const EdgeInsets.all(20),
        child: const Text('ROZPOCZNIJ'),
      ),

      color: Theme
          .of(context)
          .primaryColor,

      onPressed: onPressed,
    );
  }
}
