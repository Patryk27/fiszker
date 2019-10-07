import 'package:flutter/material.dart';

import '../../../misc.dart';

class SummaryDescription extends StatefulWidget {
  final Answers answers;

  SummaryDescription({
    @required this.answers,
  }) : assert(answers != null);

  @override
  _SummaryDescriptionState createState() {
    return _SummaryDescriptionState();
  }
}

class _SummaryDescriptionState extends State<SummaryDescription> {
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
    final correctCount = widget.answers.countCorrect();
    final correctRatio = widget.answers.calcCorrectRatio();

    final invalidCount = widget.answers.countInvalid();
    final invalidRatio = widget.answers.calcInvalidRatio();

    if (correctRatio == 0) {
      return ':-(\n\nSpróbuj ponownie jutro, na pewno pójdzie Ci lepiej!';
    }

    if (invalidRatio == 0) {
      return 'Brawo, świetny wynik! :-)';
    }

    if (correctCount == invalidCount) {
      return '50/50 - nie najgorzej; ćwicz dalej! :-)';
    }

    if (correctRatio > invalidRatio) {
      return 'Całkiem nieźle! :-)';
    } else {
      return 'Musisz jeszcze trochę poćwiczyć - nie poddawaj się! :-)';
    }
  }
}
