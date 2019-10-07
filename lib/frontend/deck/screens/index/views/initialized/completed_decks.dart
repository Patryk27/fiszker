import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class CompletedDecksSection extends StatelessWidget {
  final DeckList decks;

  CompletedDecksSection({
    @required this.decks,
  }) : assert(decks != null);

  @override
  Widget build(BuildContext context) {
    if (decks.decks.isEmpty) {
      return EmptyList(
        icon: Icons.check,
        title: 'Nie masz ukończonych zestawów',
        message: '... ale nie przejmuj się - na pewno w try miga coś uda Ci się ukończyć!',
      );
    }

    return decks;
  }
}
