import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

Future<bool> confirm({
  @required BuildContext context,
  @required String title,
  @required String message,
  String yesLabel = 'TAK',
  String noLabel = 'NIE',
}) async {
  return await confirmEx(
    context: context,
    title: title,
    message: message,

    actions: [
      Tuple2(false, noLabel),
      Tuple2(false, yesLabel),
    ],

    defaultResult: false,
  );
}
