import 'package:flutter/material.dart';

import '../../bloc.dart';

class ChartDescription extends StatefulWidget {
  State<ChartDescription> createState() => _ChartDescriptionState();
}

class _ChartDescriptionState extends State<ChartDescription> {
  String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,

      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    text = getText();
  }

  // @todo prepare more texts
  String getText() {
    final exercise = FinishingBloc
        .of(context)
        .exercise;

    final correctNumber = exercise.countCorrectAnswers();
    final correctRatio = exercise.countRatioOfCorrectAnswers();

    final invalidNumber = exercise.countInvalidAnswers();
    final invalidRatio = exercise.countRatioOfInvalidAnswers();

    if (correctRatio == 0) {
      return 'Oh my, musisz jeszcze trochę poćwiczyć!';
    }

    if (invalidRatio == 0) {
      return 'Brawo, świetny wynik!';
    }

    if (correctNumber == invalidNumber) {
      return '50/50 - ćwicz dalej!';
    }

    if (correctRatio > invalidRatio) {
      return 'Całkiem nieźle!';
    } else {
      return 'Musisz jeszcze trochę poćwiczyć - nie poddawaj się!';
    }
  }
}
