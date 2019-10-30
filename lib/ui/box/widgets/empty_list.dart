import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

class EmptyBoxList extends StatelessWidget {
  final void Function() onCreateBoxPressed;

  EmptyBoxList({
    @required this.onCreateBoxPressed,
  }) : assert(onCreateBoxPressed != null);

  @override
  Widget build(BuildContext context) {
    return EmptyList(
      icon: Icons.inbox,
      title: 'Ten zestaw nie zawiera póki co żadnych pudełek',
      message: 'Aby dodać pudełko, naciśnij przycisk widoczny u dołu ekranu lub wybierz:',
      callToAction: 'DODAJ PUDEŁKO',
      onCallToAction: onCreateBoxPressed,
    );
  }
}
