import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

Future<bool> confirm({
  @required BuildContext context,
  @required String title,
  @required String message,
  String yesLabel = 'TAK',
  String noLabel = 'NIE',
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertModal(
        title: title,
        message: message,

        actions: [
          FlatButton(
            child: Text(noLabel),

            onPressed: () {
              Navigator
                  .of(context)
                  .pop(false);
            },
          ),

          FlatButton(
            child: Text(yesLabel),

            onPressed: () {
              Navigator
                  .of(context)
                  .pop(true);
            },
          ),
        ],
      );
    },
  ) ?? false;
}
