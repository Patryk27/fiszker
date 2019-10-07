import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

class DeckListTab extends StatelessWidget {
  final String title;
  final List<DeckViewModel> decks;

  DeckListTab({
    @required this.title,
    @required this.decks,
  })
      : assert(title != null),
        assert(decks != null);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        children: [
          Text('$title '),

          Opacity(
            opacity: 0.4,
            child: Text('(${decks.length})'),
          ),
        ],
      ),
    );
  }
}
