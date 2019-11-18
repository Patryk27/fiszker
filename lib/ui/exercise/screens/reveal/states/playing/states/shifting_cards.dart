import 'package:fiszker/database.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../bloc.dart';

const SHIFTING_CARDS_ANIMATION_DURATION = const Duration(milliseconds: 900);

class ShiftingCards extends PlayingBlocState {
  /// Card that will be animated as the one leaving the screen.
  final Optional<CardModel> previousCard;

  /// Card that will be animated as the one entering the screen.
  final Optional<CardModel> nextCard;

  ShiftingCards(this.previousCard, this.nextCard)
      : assert(previousCard != null),
        assert(nextCard != null),
        assert(previousCard.isPresent || nextCard.isPresent);

  @override
  Widget buildActionsWidget() => const SizedBox();

  @override
  Widget buildBodyWidget() => _Body(previousCard, nextCard);
}

class _Body extends StatefulWidget {
  final Optional<CardModel> previousCard;
  final Optional<CardModel> nextCard;

  _Body(this.previousCard, this.nextCard);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    Widget buildCard({
      @required Optional<CardModel> card,
      @required double offsetX,
      @required bool showFront,
    }) {
      if (card.isPresent) {
        return Transform.translate(
          offset: Offset(offsetX, 0),
          child: CardSide(
            size: Size(300, 300),
            text: showFront ? card.value.front : card.value.back,
          ),
        );
      } else {
        return const SizedBox();
      }
    }

    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          children: [
            buildCard(
              card: widget.previousCard,
              offsetX: screenWidth * animation.value,
              showFront: false,
            ),

            buildCard(
              card: widget.nextCard,
              offsetX: screenWidth * animation.value - screenWidth,
              showFront: true,
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: SHIFTING_CARDS_ANIMATION_DURATION,
      vsync: this,
    );

    animation =
        CurveTween(curve: Curves.easeInOutCirc)
            .animate(animationController);

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
