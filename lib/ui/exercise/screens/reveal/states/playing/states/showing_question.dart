import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class ShowingQuestion extends PlayingBlocState {
  @override
  Widget buildActionsWidget() => _Actions();

  @override
  Widget buildBodyWidget() => _Body();
}

class _Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.lightBlue,
      onPressed: () {
        PlayingBloc
            .of(context)
            .add(ShowAnswer());
      },

      child: const Padding(
        padding: const EdgeInsets.all(15),
        child: const Text('POKAŻ ODPOWIEDŹ'),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = PlayingBloc.of(context);

    return GestureDetector(
      onTap: () {
        PlayingBloc
            .of(context)
            .add(ShowAnswer());
      },

      child: CardSide(
        size: Size(300, 300),
        text: bloc.exercise.currentCard.front,
      ),
    );
  }
}
