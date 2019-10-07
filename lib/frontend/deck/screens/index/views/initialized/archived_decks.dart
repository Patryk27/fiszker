import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class ArchivedDecksSection extends StatelessWidget {
  final DeckList decks;

  ArchivedDecksSection({
    @required this.decks,
  }) : assert(decks != null);

  @override
  Widget build(BuildContext context) {
    if (decks.decks.isEmpty) {
      return EmptyList(
        icon: Icons.archive,
        title: 'Nie masz zarchiwizowanych zestawów',
        message: 'Tutaj pojawią się wszystkie zestawy fiszek, które zarchiwizujesz.',
      );
    }

    return decks;
  }
}
