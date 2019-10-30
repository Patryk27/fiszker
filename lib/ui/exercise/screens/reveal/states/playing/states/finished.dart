import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../../../events/finalize.dart';
import '../bloc.dart';

class Finished extends PlayingBlocState {
  @override
  Widget buildActionsWidget() => const SizedBox();

  @override
  Widget buildBodyWidget() => _Body();
}

class _Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) => const SizedBox();

  @override
  void initState() {
    super.initState();

    RevealExerciseBloc.of(context).add(
      Finalize(
        exercise: PlayingBloc
            .of(context)
            .exercise,
      ),
    );
  }
}
