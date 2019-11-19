import 'package:fiszker/domain.dart';
import 'package:fiszker/i18n.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../bloc.dart';

class BoxesSummary extends StatelessWidget {
  static const regularStyle = const TextStyle(fontSize: 16.0);
  static const highlightedStyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final exercise = FinishingBloc
        .of(context)
        .exercise;

    final texts = <List<TextSpan>>[];

    describeCorrectAnswers(exercise).ifPresent((text) {
      texts.add(text);
    });

    describeInvalidAnswers(exercise).ifPresent((text) {
      texts.add(text);
    });

    return Column(
      children: texts.map((texts) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: RichText(
            text: TextSpan(children: texts, style: regularStyle),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  Optional<List<TextSpan>> describeCorrectAnswers(Exercise exercise) {
    final answers = exercise.countCorrectAnswers();
    final targetBox = exercise.getCorrectAnswersBox();

    if (answers == 0) {
      return const Optional.empty();
    }

    final texts = [
      TextSpan(text: 'Udało Ci się odpowiedzieć na '),
      TextSpan(
        text: inflector.pluralize(InflectorVerb.flashcard, InflectorCase.accusative, answers),
        style: highlightedStyle,
      ),
      TextSpan(text: ' - '),
    ];

    if (targetBox.isPresent) {
      texts.addAll([
        TextSpan(text: (answers == 1) ? 'trafi ona do następnego pudełka' : 'trafią one do następnego pudełka'),
        TextSpan(text: ': '),
        TextSpan(text: targetBox.value.name, style: highlightedStyle),
      ]);
    } else {
      texts.addAll([
        TextSpan(text: (answers == 1) ? 'pozostanie ona w aktualnym pudełku' : 'pozostaną one w aktualnym pudełku'),
      ]);
    }

    texts.addAll([
      TextSpan(text: '.'),
    ]);

    return Optional.of(texts);
  }

  Optional<List<TextSpan>> describeInvalidAnswers(Exercise exercise) {
    final answers = exercise.countInvalidAnswers();
    final targetBox = exercise.getInvalidAnswersBox();

    if (answers == 0) {
      return const Optional.empty();
    }

    final texts = [
      TextSpan(text: 'Nie udało Ci się odpowiedzieć na '),
      TextSpan(
        text: inflector.pluralize(InflectorVerb.flashcard, InflectorCase.accusative, answers),
        style: highlightedStyle,
      ),
      TextSpan(text: ' - '),
    ];

    if (targetBox.isPresent) {
      texts.addAll([
        TextSpan(text: (answers == 1) ? 'trafi ona do poprzedniego pudełka' : 'trafią one do poprzedniego pudełka'),
        TextSpan(text: ': '),
        TextSpan(text: targetBox.value.name, style: highlightedStyle),
      ]);
    } else {
      texts.addAll([
        TextSpan(text: (answers == 1) ? 'pozostanie ona w aktualnym pudełku' : 'pozostaną one w aktualnym pudełku'),
      ]);
    }

    texts.addAll([
      TextSpan(text: '.'),
    ]);

    return Optional.of(texts);
  }
}
