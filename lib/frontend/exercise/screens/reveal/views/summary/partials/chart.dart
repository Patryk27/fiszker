import 'package:fiszker/frontend.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../misc.dart';

class SummaryChart extends StatelessWidget {
  final Answers answers;

  SummaryChart({
    @required this.answers,
  }) : assert(answers != null);

  @override
  Widget build(BuildContext context) {
    final correctAnswers = answers.countCorrect();
    final invalidAnswers = answers.countInvalid();

    final correctRatio = answers.calcCorrectRatio();
    final invalidRatio = answers.calcInvalidRatio();

    List<PieChartSectionData> buildChartSections() {
      final sections = <PieChartSectionData>[];

      if (correctRatio > 0) {
        sections.add(PieChartSectionData(
          value: correctAnswers.toDouble(),
          color: Colors.green,
          title: (100 * correctRatio).toInt().toString() + '%',
        ));
      }

      if (invalidRatio > 0) {
        sections.add(PieChartSectionData(
          value: invalidAnswers.toDouble(),
          color: Colors.red,
          title: (100 * invalidRatio).toInt().toString() + '%',
        ));
      }

      return sections;
    }

    return Column(
      children: [
        // Chart
        FlChart(
          chart: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sections: buildChartSections(),
            ),
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
