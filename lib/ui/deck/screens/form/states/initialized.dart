import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

/// This class models a state where the system has loaded everything from the database and now its patiently waiting
/// for user to either modify the form or press the "Submit" button.
class Initialized extends DeckFormBlocState {
  final DeckFormBehavior formBehavior;
  final DeckEntity deck;

  Initialized({
    @required this.formBehavior,
    @required this.deck,
  })
      : assert(formBehavior != null),
        assert(deck != null);

  @override
  Widget buildWidget() => _Widget(this);
}

class _Widget extends StatefulWidget {
  final Initialized state;

  _Widget(this.state);

  @override
  State<StatefulWidget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  @override
  Widget build(BuildContext context) {
    return DeckForm(
      formBehavior: widget.state.formBehavior,
      deck: widget.state.deck,
      onSubmit: submit,
    );
  }

  void submit(DeckEntity deck) {
    DeckFormBloc.of(context).add(
      Submit(
        formBehavior: widget.state.formBehavior,
        deck: deck,
      ),
    );
  }
}
