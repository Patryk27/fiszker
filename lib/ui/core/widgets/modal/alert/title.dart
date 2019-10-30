import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

class AlertTitle extends StatelessWidget {
  AlertTitle({
    @required this.title,
  }) : assert(title != null);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final brightness = MediaQuery
        .of(context)
        .platformBrightness;

    return Container(
      width: double.maxFinite,
      color: (brightness == Brightness.dark) ? Colors.redAccent.withRed(180) : Colors.redAccent,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          DIALOG_PADDING,
          DIALOG_PADDING / 2.0 + 4.0,
          DIALOG_PADDING,
          DIALOG_PADDING / 2.0 + 4.0,
        ),

        child: DefaultTextStyle(
          style: theme.dialogTheme.titleTextStyle ?? theme.textTheme.title,

          child: Semantics(
            namesRoute: true,
            container: true,

            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
