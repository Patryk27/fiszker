import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class CardEmptyList extends StatelessWidget {
  final void Function() onCallToAction;

  CardEmptyList({
    @required this.onCallToAction,
  }) : assert(onCallToAction != null);

  @override
  Widget build(BuildContext context) {
    return EmptyList(
      icon: Icons.layers,
      title: 'Ten zestaw nie zawiera póki co żadnych fiszek',
      message: 'Aby dodać fiszkę, naciśnij plus widoczny u dołu ekranu lub wybierz:',
      callToAction: 'DODAJ FISZKĘ',
      onCallToAction: onCallToAction,
    );
  }
}
