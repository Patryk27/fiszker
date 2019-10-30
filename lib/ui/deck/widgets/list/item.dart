import 'package:fiszker/domain.dart';
import 'package:fiszker/i18n.dart';
import 'package:flutter/material.dart';

class DeckListItem extends StatelessWidget {
  final DeckEntity deck;
  final void Function() onTapped;
  final void Function() onLongPressed;

  DeckListItem({
    @required this.deck,
    @required this.onTapped,
    @required this.onLongPressed,
  })
      : assert(deck != null),
        assert(onTapped != null),
        assert(onLongPressed != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTapped,
        onLongPress: onLongPressed,

        child: ListTile(
          title: Text(deck.deck.name),
          subtitle: Text(inflector.pluralize(InflectorVerb.flashcard, InflectorCase.nominative, deck.cards.length)),
          trailing: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
