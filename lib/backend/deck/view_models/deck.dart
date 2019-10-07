import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

@immutable
class DeckViewModel {
  final DeckModel deck;
  final List<CardModel> cards;

  const DeckViewModel({
    @required this.deck,
    @required this.cards,
  });
}
