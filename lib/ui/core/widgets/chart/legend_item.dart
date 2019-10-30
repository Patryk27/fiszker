import 'package:flutter/material.dart';

// Thanks to https://github.com/imaNNeoFighT/fl_chart/blob/master/example/lib/pie_chart/samples/indicator.dart
class ChartLegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final double textSize;
  final Color textColor;

  const ChartLegendItem({
    this.color,
    this.text,
    this.textSize,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: textSize,
          height: textSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),

        const SizedBox(width: 5),

        Text(
          text,
          style: TextStyle(
            fontSize: textSize,
            color: textColor,
          ),
        )
      ],
    );
  }
}
