import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class EmptyCardList extends StatelessWidget {
  final void Function() onCreateCardPressed;

  EmptyCardList({
    @required this.onCreateCardPressed,
  }) : assert(onCreateCardPressed != null);

  @override
  Widget build(BuildContext context) {
    return EmptyList(
      icon: Icons.layers,
      title: 'Ten zestaw nie zawiera póki co żadnych fiszek',
      message: 'Aby dodać fiszkę, naciśnij przycisk widoczny u dołu ekranu lub wybierz:',
      callToAction: 'DODAJ FISZKĘ',
      onCallToAction: onCreateCardPressed,
    );
  }
}
