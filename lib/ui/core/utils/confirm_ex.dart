import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

Future<T> confirmEx<T>({
  @required BuildContext context,
  @required String title,
  @required String message,
  @required List<Tuple2<T, String>> actions,
  @required T defaultResult,
}) async {
  return await showDialog(
    context: context,

    builder: (context) {
      return AlertModal(
        title: title,
        message: message,

        actions: actions.map((action) {
          return FlatButton(
            child: Text(
              action.item2,
            ),

            onPressed: () {
              Navigator
                  .of(context)
                  .pop(action.item1);
            },
          );
        }).toList(),
      );
    },
  ) ?? defaultResult;
}
