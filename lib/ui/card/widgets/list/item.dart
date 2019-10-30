import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';

class CardListItem extends StatelessWidget {
  final CardModel card;
  final void Function() onTapped;

  CardListItem({
    @required this.card,
    @required this.onTapped,
  })
      : assert(card != null),
        assert(onTapped != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTapped,

        child: ListTile(
          title: Text(card.front),
          subtitle: Text(card.back),
          trailing: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
