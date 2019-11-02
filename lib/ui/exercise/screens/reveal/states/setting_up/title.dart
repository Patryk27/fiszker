import 'package:flutter/material.dart';

class SettingUpTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Odkrywanie',

      style: Theme
          .of(context)
          .textTheme
          .display1,

      textAlign: TextAlign.center,
    );
  }
}
