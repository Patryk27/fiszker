import 'package:flutter/material.dart';

import 'bloc.dart';
import 'widgets.dart';

export 'states/awaiting_start.dart';
export 'states/finished.dart';
export 'states/shifting_cards.dart';
export 'states/showing_answer.dart';
export 'states/showing_question.dart';

@immutable
abstract class PlayingBlocState {
  Widget buildBodyWidget();

  Widget buildActionsWidget();

  Widget buildWidget(BuildContext context) {
    // ignore: close_sinks
    final bloc = PlayingBloc.of(context);

    Widget buildScreen() {
      return Column(
        children: [
          // Top
          Expanded(
            // just a space-filler for following boxes to properly align
            child: const SizedBox(),
          ),

          // Middle
          Expanded(
            flex: 2,
            child: Center(
              child: buildBodyWidget(),
            ),
          ),

          // Bottom
          Expanded(
            flex: 2,
            child: Center(
              child: buildActionsWidget(),
            ),
          ),
        ],
      );
    }

    Widget buildCloseButton() {
      return ExerciseCloseButton(
        visible: bloc.showOverlay,
      );
    }

    Widget buildProgressBar() {
      return ExerciseProgressBar(
        height: 8.0,
        visible: bloc.showOverlay,
        exercise: bloc.exercise,
      );
    }

    return Stack(
      children: [
        buildScreen(),
        buildCloseButton(),
        buildProgressBar(),
      ],
    );
  }
}
