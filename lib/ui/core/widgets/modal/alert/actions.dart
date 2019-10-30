import 'package:flutter/material.dart';

class AlertActions extends StatelessWidget {
  AlertActions({
    @required this.actions,
  }) : assert(actions != null);

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme.bar(
      child: ButtonBar(
        children: actions,
      ),
    );
  }
}
