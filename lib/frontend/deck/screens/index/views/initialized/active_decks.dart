import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class ActiveDecksSection extends StatelessWidget {
  final DeckList decks;
  final void Function() onCreateDeckPressed;

  ActiveDecksSection({
    @required this.decks,
    @required this.onCreateDeckPressed,
  })
      : assert(decks != null),
        assert(onCreateDeckPressed != null);

  @override
  Widget build(BuildContext context) {
    if (decks.decks.isEmpty) {
      return EmptyList(
        icon: Icons.layers,
        title: 'Nie masz aktywnych zestawów',
        message: 'Aby stworzyć zestaw, naciśnij plus widoczny u dołu ekranu lub wybierz:',
        callToAction: 'STWÓRZ ZESTAW',
        onCallToAction: onCreateDeckPressed,
      );
    }

    return decks;
  }
}
