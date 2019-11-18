import 'package:fiszker/database.dart';
import 'package:fiszker/i18n.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    List<Widget> buildSubtitle() {
      final widgets = [
        Text(inflector.pluralize(InflectorVerb.flashcard, InflectorCase.nominative, boxCardCount)),
      ];

      box.exercisedAt.ifPresent((exercisedAt) {
        widgets.add(Text(', ostatnio: ${timeago.format(exercisedAt)}'));
      });

      return widgets;
    }

    return Card(
      child: InkWell(
        onTap: onTapped,

        child: ListTile(
          title: Text(box.name),

          subtitle: Row(
            children: buildSubtitle(),
          ),

          trailing: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
