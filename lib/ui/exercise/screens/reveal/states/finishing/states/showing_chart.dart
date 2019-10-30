import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import 'showing_chart/actions.dart';
import 'showing_chart/chart.dart';
import 'showing_chart/description.dart';

class ShowingChart extends FinishingBlocState {
  @override
  Widget buildWidget() => _Widget();
}

class _Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BODY_PADDING),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          ChartDescription(),
          ChartChart(),
          ChartActions(),
        ],
      ),
    );
  }
}

