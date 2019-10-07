import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

class DeckListItem extends StatelessWidget {
  final DeckViewModel deck;
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
          subtitle: Text('${deck.cards.length} fiszek'),
          trailing: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
