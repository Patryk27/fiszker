import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class ColorInterleavedProgressBar extends StatefulWidget {
  final Color backgroundColor;
  final List<Optional<MaterialColor>> intervals;

  ColorInterleavedProgressBar({
    @required this.backgroundColor,
    @required this.intervals,
  })
      : assert(backgroundColor != null),
        assert(intervals != null);

  @override
  _ColorInterleavedProgressBarState createState() {
    return _ColorInterleavedProgressBarState();
  }
}

class _ColorInterleavedProgressBarState extends State<ColorInterleavedProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.intervals.map((interval) {
        return Expanded(
          child: AnimatedContainer(
            color: interval.orElse(widget.backgroundColor),
            duration: const Duration(milliseconds: 500),
          ),
        );
      }).toList(),
    );
  }
}
