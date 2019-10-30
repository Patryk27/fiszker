import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:optional/optional.dart';

class ExerciseFacade {
  final BoxStorage boxStorage;
  final CardStorage cardStorage;
  final DeckStorage deckStorage;

  ExerciseFacade(this.boxStorage, this.cardStorage, this.deckStorage)
      : assert(boxStorage != null),
        assert(cardStorage != null),
        assert(deckStorage != null);

  Exercise start(DeckEntity deck, BoxModel box, ExerciseMode mode) {
    // Prepare cards we'll be using in this exercise
    var cards = List.of(
      deck.findCardsInsideBox(box),
    );

    cards.sort((cardA, cardB) {
      // If a card was not exercised at all yet, we're giving it the highest priority (thus the `DateTime(0)`)
      final a = cardA.exercisedAt.orElse(DateTime(0));
      final b = cardB.exercisedAt.orElse(DateTime(0));

      return a.compareTo(b);
    });

    switch (mode) {
      case ExerciseMode.allCards:
        break;

      case ExerciseMode.oldestTenCards:
        cards = cards.sublist(0, (cards.length > 10) ? 9 : cards.length);
        break;

      case ExerciseMode.oldestTwentyCards:
        cards = cards.sublist(0, (cards.length > 20) ? 19 : cards.length);
        break;

      case ExerciseMode.oldestFiftyCards:
        cards = cards.sublist(0, (cards.length > 50) ? 49 : cards.length);
        break;
    }

    cards.shuffle();

    // Prepare list of pending cards
    final pendingCards = List.of(cards);

    // Prepare list of to-be answers
    final answers = cards
        .map((card) => ExerciseAnswer(card, ExerciseAnswerType.pending))
        .toList();

    // Build the exercise
    return Exercise(
      deck: deck,
      box: box,
      cards: cards,
      currentCard: pendingCards.removeAt(0),
      pendingCards: pendingCards,
      answers: answers,
    );
  }

  Future<void> commit(Exercise exercise) async {
    final now = DateTime.now();

    // Update the "exercised at"s
    await boxStorage.update(exercise.box.id, exercisedAt: Optional.of(Optional.of(now)));
    await deckStorage.update(exercise.deck.deck.id, exercisedAt: Optional.of(Optional.of(now)));

    for (final answer in exercise.getAnswers()) {
      await cardStorage.update(answer.card.id, exercisedAt: Optional.of(Optional.of(now)));
    }

    // Move cards to their new boxes
    final correctAnswersBox = exercise.getCorrectAnswersBox().map((box) => box.id);
    final invalidAnswersBox = exercise.getInvalidAnswersBox().map((box) => box.id);

    for (final answer in exercise.getAnswers()) {
      switch (answer.type) {
        case ExerciseAnswerType.correct:
          await cardStorage.update(answer.card.id, boxId: correctAnswersBox);
          break;

        case ExerciseAnswerType.invalid:
          await cardStorage.update(answer.card.id, boxId: invalidAnswersBox);
          break;

        default:
        // this oughtn't really happen - at this point all the answers should be either correct or invalid
      }
    }
  }
}
