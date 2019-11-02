import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

import 'alert/actions.dart';
import 'alert/body.dart';
import 'alert/title.dart';

class AlertModal extends StatelessWidget {
  AlertModal({
    @required this.title,
    @required this.message,
    @required this.actions,
  })
      : assert(title != null),
        assert(message != null),
        assert(actions != null),
        assert(actions.length > 0);

  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,

      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(DIALOG_BORDER_RADIUS),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            AlertTitle(
              title: title,
            ),

            Container(
              color: theme.dialogBackgroundColor,
              width: double.maxFinite,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  AlertBody(
                    message: message,
                  ),

                  AlertActions(
                    actions: actions,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
