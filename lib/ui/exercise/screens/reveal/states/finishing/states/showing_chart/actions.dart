import 'package:flutter/material.dart';

import '../../bloc.dart';

class ChartActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton.icon(
          color: Colors.lightBlue,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('DALEJ'),

          onPressed: () {
            FinishingBloc.of(context).add(
              ShowBoxes(),
            );
          },
        ),
      ],
    );
  }
}
