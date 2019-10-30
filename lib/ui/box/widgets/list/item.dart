import 'package:fiszker/database.dart';
import 'package:fiszker/i18n.dart';
import 'package:flutter/material.dart';

class BoxListItem extends StatelessWidget {
  final BoxModel box;
  final int boxCardCount;
  final void Function() onTapped;

  BoxListItem({
    @required this.box,
    @required this.boxCardCount,
    @required this.onTapped,
  })
      : assert(box != null),
        assert(boxCardCount != null),
        assert(onTapped != null),
        super(key: Key(box.id.toString()));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTapped,

        child: ListTile(
          title: Text(box.name),
          subtitle: Text(inflector.pluralize(InflectorVerb.flashcard, InflectorCase.nominative, boxCardCount)),
          trailing: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
