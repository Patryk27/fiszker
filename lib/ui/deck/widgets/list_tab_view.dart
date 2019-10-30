import 'package:fiszker/domain.dart';
import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

class DeckListTabView extends StatelessWidget {
  final List<DeckEntity> decks;
  final WidgetBuilder listBuilder;
  final WidgetBuilder emptyListBuilder;

  DeckListTabView({
    @required this.decks,
    @required this.listBuilder,
    @required this.emptyListBuilder,
  })
      : assert(decks != null),
        assert(listBuilder != null),
        assert(emptyListBuilder != null);

  @override
  Widget build(BuildContext context) {
    Widget buildBody() {
      if (decks.isEmpty) {
        return emptyListBuilder(context);
      } else {
        return listBuilder(context);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(TAB_VIEW_PADDING),
      child: buildBody(),
    );
  }
}
