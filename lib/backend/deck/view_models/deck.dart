import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

@immutable
class DeckViewModel {
  final DeckModel deck;
  final List<BoxModel> boxes;
  final List<CardModel> cards;

  const DeckViewModel({
    @required this.deck,
    @required this.boxes,
    @required this.cards,
  });
}
