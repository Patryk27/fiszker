import 'package:flutter/material.dart';

class AlertBody extends StatelessWidget {
  AlertBody({
    @required this.message,
  }) : assert(message != null);

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),

      child: DefaultTextStyle(
        style: theme.dialogTheme.contentTextStyle ?? theme.textTheme.subhead,
        child: Text(message),
      ),
    );
  }
}
