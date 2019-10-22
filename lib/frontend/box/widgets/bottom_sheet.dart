import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart' as frontend;
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class BoxBottomSheet extends StatelessWidget {
  final BoxModel box;

  /// List of all the cards that are related to this box; used to print the "number of cards:" detail.
  final List<CardModel> boxCards;

  /// Handler for the "show cards" button.
  /// May be empty if this box contain no cards (and thus this action would make no sense).
  final Optional<void Function()> onShowCardsPressed;

  /// Handler for the "delete" button.
  /// May be empty if this box is the last one (and thus this action would make no sense).
  final Optional<void Function()> onDeletePressed;

  BoxBottomSheet({
    @required this.box,
    @required this.boxCards,
    @required this.onShowCardsPressed,
    @required this.onDeletePressed,
  })
      : assert(box != null),
        assert(boxCards != null),
        assert(onShowCardsPressed != null),
        assert(onDeletePressed != null);

  @override
  Widget build(BuildContext context) {
    return frontend.BottomSheet(
      title: Optional.of(
        box.getTitle(),
      ),

      body: Details(
        children: [
          // Number of cards
          Detail(
            title: 'Liczba fiszek:',
            value: Optional.of(boxCards.length.toString()),
          ),

          // Created at
          Detail.ago(
            title: 'Utworzone:',
            value: Optional.of(box.createdAt),
          ),

          // Exercised at
          Detail.ago(
            title: 'Ostatnio ćwiczone:',
            value: box.exercisedAt,
          ),
        ],
      ),

      actions: [
        FlatButton(
          child: const Text('POKAŻ FISZKI'),

          onPressed: onShowCardsPressed
              .orElse(null),
        ),

        FlatButton(
          child: const Text('USUŃ'),

          onPressed: onDeletePressed
              .map((fn) => () => maybeDelete(context))
              .orElse(null),
        ),
      ],
    );
  }

  /// Asks user whether they want to delete this box and, if confirmed, deletes it.
  Future<void> maybeDelete(BuildContext context) async {
    final confirmed = await confirm(
      context: context,
      title: 'Usunąć pudełko?',
      message: 'Czy chcesz usunąć to pudełko?\n\nZnajdujące się w nim karty zostaną przeniesione do pierwszego pudełka.',
      btnYes: 'USUŃ',
      btnNo: 'NIE USUWAJ',
    );

    if (confirmed) {
      onDeletePressed.value();
    }
  }
}
