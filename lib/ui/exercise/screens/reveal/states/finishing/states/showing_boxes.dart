import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import 'showing_boxes/actions.dart';
import 'showing_boxes/summary.dart';

class ShowingBoxes extends FinishingBlocState {
  @override
  Widget buildWidget() => _Widget();
}

class _Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BODY_PADDING),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          BoxesSummary(),
          BoxesActions(),
        ],
      ),
    );
  }
}
