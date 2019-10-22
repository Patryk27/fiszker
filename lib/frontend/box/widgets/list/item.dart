import 'package:fiszker/backend.dart';
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
        assert(onTapped != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTapped,

        child: ListTile(
          title: Text(box.getTitle()),
          subtitle: Text("$boxCardCount fiszek"),
          trailing: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
