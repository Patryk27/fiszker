import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class CardFormTitle extends StatelessWidget {
  final CardFormBehavior formBehavior;
  final CardModel card;

  CardFormTitle({
    @required this.formBehavior,
    @required this.card,
  })
      : assert(formBehavior != null),
        assert(card != null);

  @override
  Widget build(BuildContext context) {
    final titleText = (formBehavior == CardFormBehavior.createCard) ? 'Tworzenie fiszki' : 'Edycja fiszki';

    final titleStyle = Theme
        .of(context)
        .textTheme
        .title;

    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 15),
      child: Semantics(
        child: Text(titleText, style: titleStyle),
      ),
    );
  }
}
