import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

Future<bool> confirm({
  @required BuildContext context,
  @required String title,
  @required String message,
  String btnYes = 'TAK',
  String btnNo = 'NIE',
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertModal(
        title: title,
        message: message,

        actions: [
          FlatButton(
            child: Text(btnNo),

            onPressed: () {
              Navigator
                  .of(context)
                  .pop(false);
            },
          ),

          FlatButton(
            child: Text(btnYes),

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
