import 'package:fiszker/ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../bloc.dart';

class ChartChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> buildChartSections() {
      final sections = <PieChartSectionData>[];

      final exercise = FinishingBloc
          .of(context)
          .exercise;

      final correctNumber = exercise.countCorrectAnswers();
      final invalidNumber = exercise.countInvalidAnswers();

      if (correctNumber > 0) {
        sections.add(
          PieChartSectionData(
            value: correctNumber.toDouble(),
            color: Colors.green,
            title: "$correctNumber",
          ),
        );
      }

      if (invalidNumber > 0) {
        sections.add(
          PieChartSectionData(
            value: invalidNumber.toDouble(),
            color: Colors.red,
            title: "$invalidNumber",
          ),
        );
      }

      return sections;
    }

    return Column(
      children: [
        // Chart
        PieChart(
          PieChartData(
            borderData: FlBorderData(show: false),
            sections: buildChartSections(),
          ),
        ),

        const SizedBox(height: 10),

        // Legend
        Center(
          child: Column(
            children: [
              ChartLegendItem(
                color: Colors.green,
                text: 'Poprawne odpowiedzi',
                textSize: 18,
                textColor: Colors.white,
              ),

              const SizedBox(height: 8),

              ChartLegendItem(
                color: Colors.red,
                text: 'Błędne odpowiedzi',
                textSize: 18,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
