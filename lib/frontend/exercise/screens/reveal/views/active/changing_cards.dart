import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class ChangingCards extends StatelessWidget {
  final Optional<CardModel> previousCard;
  final Optional<CardModel> currentCard;
  final double animationProgress;

  ChangingCards({
    @required this.previousCard,
    @required this.currentCard,
    @required this.animationProgress,
  })
      : assert(previousCard != null),
        assert(currentCard != null),
        assert(animationProgress != null);

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

    return Column(
      children: [
        const Expanded(
          child: const SizedBox(),
        ),

        Expanded(
          flex: 2,
          child: Center(
            child: Stack(
              children: [
                buildCard(
                  card: previousCard,
                  offsetX: screenWidth * animationProgress,
                  showFront: false,
                ),

                buildCard(
                  card: currentCard,
                  offsetX: screenWidth * animationProgress - screenWidth,
                  showFront: true,
                ),
              ],
            ),
          ),
        ),

        const Expanded(
          flex: 2,
          child: const SizedBox(),
        ),
      ],
    );
  }
}
