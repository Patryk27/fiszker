import 'package:flutter/material.dart';

import '../../bloc.dart';

class BoxesActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = FinishingBloc.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton.icon(
          color: Colors.lightBlue,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('ZAKOŃCZ ĆWICZENIE'),

          onPressed: () {
            bloc.add(
              Finish(),
            );
          },
        ),
      ],
    );
  }
}
