import 'package:fiszker/domain.dart';
import 'package:fiszker/i18n.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../bloc.dart';

class BoxesSummary extends StatelessWidget {
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
            text: TextSpan(
              children: texts,
            ),

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
      return Optional.empty();
    }

    return Optional.of([
      // "You have answered "
      const TextSpan(text: 'Udało Ci się odpowiedzieć na '),

      // "1 flashcard" / "%d flashcards"
      TextSpan(
        text: inflector.pluralize(InflectorVerb.flashcard, InflectorCase.accusative, answers),
        style: highlightedStyle,
      ),

      // " - "
      const TextSpan(text: ' - '),

      // "it will be moved to the next box: " / "they will be moved to the next box: "
      TextSpan(
        text: (answers == 1) ? 'trafi ona do następnego pudełka' : 'trafią one do następnego pudełka',
      ),

      // ": "
      const TextSpan(text: ': '),

      // "%s" (the target box's name)
      TextSpan(text: targetBox.value.name, style: highlightedStyle),

      // "."
      const TextSpan(text: '.'),
    ]);
  }

  Optional<List<TextSpan>> describeInvalidAnswers(Exercise exercise) {
    final answers = exercise.countInvalidAnswers();
    final targetBox = exercise.getInvalidAnswersBox();

    if (answers == 0) {
      return Optional.empty();
    }

    final texts = [
      // "You have not answered"
      const TextSpan(text: 'Nie udało Ci się odpowiedzieć na'),

      // " "
      const TextSpan(text: ' '),

      // "1 flashcard" / "%d flashcards"
      TextSpan(
        text: inflector.pluralize(InflectorVerb.flashcard, InflectorCase.accusative, answers),
        style: highlightedStyle,
      ),

      // " - "
      const TextSpan(text: ' - '),
    ];

    switch (targetBox.isPresent) {
    // Case 1: Cards will be moved to the target box
      case true:
        if (answers == 1) {
          // "it will be moved to the previous box"
          texts.add(const TextSpan(text: 'trafi ona do poprzedniego pudełka'));
        } else {
          // "they will be moved to the previous box"
          texts.add(const TextSpan(text: 'trafią one do poprzedniego pudełka'));
        }

        texts.addAll([
          // ": "
          const TextSpan(text: ': '),

          // "%s" (the target box's name)
          TextSpan(text: targetBox.value.name, style: highlightedStyle),
        ]);

        break;

    // Case 2: Cards won't be moved anywhere
      default:
        if (answers == 1) {
          // "it remain in current box"
          texts.add(const TextSpan(text: 'pozostanie ona w aktualnym pudełku'));
        } else {
          // "they will remain in current box"
          texts.add(const TextSpan(text: 'pozostaną one w aktualnym pudełku'));
        }
    }

    // "."
    texts.add(const TextSpan(text: '.'));

    return Optional.of(texts);
  }
}
