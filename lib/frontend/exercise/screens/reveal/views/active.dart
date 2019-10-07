import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../events.dart';
import '../misc.dart';
import '../states.dart';
import 'active/awaiting_start.dart';
import 'active/changing_cards.dart';
import 'active/partials/progress_bar.dart';
import 'active/showing_answer.dart';
import 'active/showing_question.dart';

class ActiveView extends StatefulWidget {
  final ActiveState state;

  ActiveView({
    @required this.state,
  }) : assert(state != null);

  @override
  _ActiveViewState createState() {
    return _ActiveViewState();
  }
}

enum _ActiveViewStatus {
  awaitingStart,
  changingCards,
  showingQuestion,
  showingAnswer,
  finished,
}

class _ActiveViewState extends State<ActiveView> with TickerProviderStateMixin {
  _ActiveViewStatus status = _ActiveViewStatus.awaitingStart;
  bool progressBarVisible = false;

  List<CardModel> pendingCards;
  Answers answers;

  Optional<CardModel> previousCard = Optional.empty();
  Optional<CardModel> currentCard = Optional.empty();

  AnimationController showingAnswerAnimationController;
  Animation<double> showingAnswerAnimation;

  AnimationController changingCardsAnimationController;
  Animation<double> changingCardsAnimation;

  @override
  Widget build(BuildContext context) {
    /// Renders screen's body.
    Widget buildBody() {
      switch (status) {
        case _ActiveViewStatus.awaitingStart:
          return AwaitingStart(
            onStartPressed: start,
          );

        case _ActiveViewStatus.changingCards:
          return ChangingCards(
            previousCard: previousCard,
            currentCard: currentCard,
            animationProgress: changingCardsAnimation.value,
          );

        case _ActiveViewStatus.showingQuestion:
          return ShowingQuestion(
            card: currentCard.value,
            onRevealAnswerPressed: revealAnswer,
          );

        case _ActiveViewStatus.showingAnswer:
          return ShowingAnswer(
            card: currentCard.value,
            animationProgress: showingAnswerAnimation.value,
            onAcceptAnswerPressed: acceptAnswerAndMoveOn,
            onRejectAnswerPressed: rejectAnswerAndMoveOn,
          );

        case _ActiveViewStatus.finished:
          return const SizedBox();
      }

      throw 'unreachable';
    }

    /// Renders screen's progress bar (visible at the top of the screen).
    Widget buildProgressBar() {
      return ExerciseProgressBar(
        height: 8.0,
        visible: progressBarVisible,
        answers: answers,
      );
    }

    return WillPopScope(
      onWillPop: confirmDismiss,

      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        extendBody: true,

        // We're using stack (instead of putting progress bar inside the body partials), because this way the progress
        // bar persists between transitions (which is required for it to properly animate)
        body: Stack(
          children: [
            GestureDetector(
              onDoubleTap: maybeDismiss,
            ),

            buildBody(),
            buildProgressBar(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    /// Initializes fields related to the "showing answer" animation.
    /// For more information, take a look at the related fields' declarations at the top of this class.
    void initShowingAnswerAnimation() {
      // Initialize controller
      showingAnswerAnimationController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );

      // Initialize animation
      showingAnswerAnimation =
          CurveTween(curve: Curves.easeInOutCirc)
              .animate(showingAnswerAnimationController);

      showingAnswerAnimation.addListener(() {
        setState(() {
          // Required for widget to repaint
        });
      });
    }

    /// Initializes fields related to the "changing cards" animation.
    /// For more information, take a look at the related fields' declarations at the top of this class.
    void initChangingCardsAnimation() {
      // Initialize controller
      changingCardsAnimationController = AnimationController(
        duration: const Duration(milliseconds: 900),
        vsync: this,
      );

      // Initialize animation
      changingCardsAnimation =
          CurveTween(curve: Curves.easeInOutCirc)
              .animate(changingCardsAnimationController);

      changingCardsAnimation.addListener(() {
        setState(() {
          // Required for widget to repaint
        });
      });

      changingCardsAnimation.addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          if (currentCard.isPresent) {
            setState(() {
              status = _ActiveViewStatus.showingQuestion;
            });
          } else {
            ExerciseRevealBloc.of(context).add(
              Finish(
                deck: widget.state.deck,
                answers: answers,
              ),
            );

            setState(() {
              status = _ActiveViewStatus.finished;
            });
          }
        }
      });
    }

    /// Initializes fields related to the "pending cards" and "answers" data.
    void initPendingCards() {
      pendingCards = List.from(widget.state.deck.cards);
      pendingCards.shuffle();

      answers = Answers(
        numberOfCards: pendingCards.length,
      );
    }

    super.initState();

    initShowingAnswerAnimation();
    initChangingCardsAnimation();
    initPendingCards();
  }

  @override
  void dispose() {
    showingAnswerAnimationController.dispose();
    changingCardsAnimationController.dispose();

    super.dispose();
  }

  /// Starts the exercise.
  /// Called when user taps the "Start exercise" button at [AwaitingStart].
  void start() {
    assert(status == _ActiveViewStatus.awaitingStart);

    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        progressBarVisible = true;
      });
    });

    moveOn();
  }

  /// Shows flashcard's answer-side.
  /// Called when user taps the "Reveal answer" button at [ShowingQuestion].
  void revealAnswer() {
    assert(status == _ActiveViewStatus.showingQuestion);

    status = _ActiveViewStatus.showingAnswer;
    showingAnswerAnimationController.forward(from: 0);
  }

  /// Marks this card as "answered correctly" and moves on to the next flashcard.
  /// Called when user taps the "Accept answer" button at [ShowingAnswer].
  void acceptAnswerAndMoveOn() {
    assert(status == _ActiveViewStatus.showingAnswer);

    answers.addCorrect();

    moveOn();
  }

  /// Marks this card as "answered incorrectly" and moves on to the next flashcard.
  /// Called when user taps the "Reject button" button at [ShowingAnswer].
  void rejectAnswerAndMoveOn() {
    assert(status == _ActiveViewStatus.showingAnswer);

    answers.addInvalid();

    moveOn();
  }

  /// Moves on to the next flashcard.
  void moveOn() {
    assert([
      _ActiveViewStatus.awaitingStart,
      _ActiveViewStatus.showingAnswer,
    ].contains(status));

    previousCard = currentCard;

    // If there are no more cards left, we're putting `Optional.empty()` into `_currentCard` - that way we'll be able to
    // properly animate it
    if (pendingCards.isEmpty) {
      currentCard = Optional.empty();
      progressBarVisible = false;
    } else {
      currentCard = Optional.of(pendingCards.removeAt(0));
    }

    status = _ActiveViewStatus.changingCards;
    changingCardsAnimationController.forward(from: 0);
  }

  /// Asks the user whether they want to abandon the exercise and, if confirmed, pops back to the previous screen.
  Future<void> maybeDismiss() async {
    if (await confirmDismiss()) {
      Navigator.pop(context);
    }
  }

  /// Asks the user whether they want to abandon the exercise and returns confirmation's result.
  Future<bool> confirmDismiss() async {
    // There's no point in asking user, if we've not even started yet
    if (status == _ActiveViewStatus.awaitingStart) {
      return true;
    }

    return await confirm(
      context: context,
      title: 'Przerwać ćwiczenie?',
      message: 'Czy chcesz przerwać ćwiczenie?',
    );
  }
}
