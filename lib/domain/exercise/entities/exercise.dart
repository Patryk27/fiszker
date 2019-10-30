import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class Exercise {
  /// The deck user is currently learning.
  /// It doesn't change during a single exercise.
  final DeckEntity deck;

  /// The box user is currently learning.
  /// It doesn't change during a single exercise.
  final BoxModel box;

  /// All the cards from box selected by the user.
  /// Optionally filtered, if user chose appropriate [ExerciseMode].
  final List<CardModel> cards;

  /// The card user is currently learning.
  CardModel currentCard;

  /// All the cards user is yet to answer.
  final List<CardModel> pendingCards;

  /// All the answers user gave (or is about to give).
  final List<ExerciseAnswer> answers;

  Exercise({
    @required this.deck,
    @required this.box,
    @required this.cards,
    @required this.currentCard,
    @required this.pendingCards,
    @required this.answers,
  })
      : assert(deck != null),
        assert(box != null),
        assert(cards != null),
        assert(cards.isNotEmpty),
        assert(currentCard != null),
        assert(pendingCards != null),
        assert(answers != null),
        assert(answers.isNotEmpty);

  /// Marks given [card] as "answered correctly" or "answered incorrectly".
  void addAnswer(CardModel card, bool isCorrect) {
    for (final answer in answers) {
      if (answer.card.id == card.id) {
        answer.type = isCorrect ? ExerciseAnswerType.correct : ExerciseAnswerType.invalid;
      }
    }
  }

  /// Returns a ratio of correct answers to all the answers.
  /// E.g. a value of 0.75 means that 3/4 of all the answers were correct.
  double countRatioOfCorrectAnswers() {
    return countCorrectAnswers() / countAnswers();
  }

  /// Returns a number of all the correct answers.
  int countCorrectAnswers() {
    return _countAnswers(ExerciseAnswerType.correct);
  }

  /// Returns a ratio of invalid answers to all the answers.
  /// E.g. a value of 0.25 means that 1/4 of all the answers were incorrect.
  double countRatioOfInvalidAnswers() {
    return countInvalidAnswers() / countAnswers();
  }

  /// Returns a number of all the invalid answers.
  int countInvalidAnswers() {
    return _countAnswers(ExerciseAnswerType.invalid);
  }

  /// Returns a number of all the answers (including the pending ones).
  int countAnswers() {
    return answers.length;
  }

  /// Returns a list of all the [ExerciseAnswer]s.
  List<ExerciseAnswer> getAnswers() {
    return answers;
  }

  /// Returns box to which all the correctly answered cards should be moved.
  ///
  /// May return nothing, which means that user somehow magically managed to start the exercise on the last box.
  Optional<BoxModel> getCorrectAnswersBox() {
    return deck.findBoxSuccessor(box);
  }

  /// Returns box to which all the incorrectly answered cards should be moved.
  ///
  /// May return nothing, which means that user started exercise on the first box and there's no other box where the
  /// cards might be moved.
  Optional<BoxModel> getInvalidAnswersBox() {
    return deck.findBoxPredecessor(box);
  }

  int _countAnswers(ExerciseAnswerType answerType) {
    return answers
        .where((answer) => answer.type == answerType)
        .length;
  }
}
