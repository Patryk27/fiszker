import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';
import 'summary/animations/entering.dart';
import 'summary/animations/leaving.dart';
import 'summary/partials/actions.dart';
import 'summary/partials/chart.dart';
import 'summary/partials/description.dart';

class SummaryView extends StatefulWidget {
  final SummaryState state;

  SummaryView({
    @required this.state,
  }) : assert(state != null);

  @override
  _SummaryViewState createState() {
    return _SummaryViewState();
  }
}

enum _SummaryViewStatus {
  entering,
  entered,
  leaving,
}

class _SummaryViewState extends State<SummaryView> with TickerProviderStateMixin {
  _SummaryViewStatus status = _SummaryViewStatus.entering;

  EnteringAnimation enteringAnimation;
  LeavingAnimation leavingAnimation;

  @override
  Widget build(BuildContext context) {
    Widget buildContent() {
      final answers = widget.state.answers;

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          Center(
            child: SummaryDescription(
              answers: answers,
            ),
          ),

          Center(
            child: SummaryChart(
              answers: answers,
            ),
          ),

          Center(
            child: SummaryActions(
              onRestartPressed: restart,
              onFinishPressed: finish,
            ),
          ),
        ],
      );
    }

    Widget buildBody() {
      final content = buildContent();

      switch (status) {
        case _SummaryViewStatus.entering:
          return EnteringAnimator(
            animation: enteringAnimation,
            child: content,
          );

        case _SummaryViewStatus.entered:
          return content;

        case _SummaryViewStatus.leaving:
          return LeavingAnimator(
            animation: leavingAnimation,
            child: content,
          );
      }

      throw 'unreachable';
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      extendBody: true,
      body: buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();

    // Initialize the "entering screen" animation
    enteringAnimation = EnteringAnimation(vsync: this);

    enteringAnimation.onCompleted(() {
      setState(() {
        status = _SummaryViewStatus.entered;
      });
    });

    // Initialize the "leaving screen" animation
    leavingAnimation = LeavingAnimation(vsync: this);

    // Start the "entering screen" animation
    enteringAnimation.start();
  }

  @override
  void dispose() {
    enteringAnimation.dispose();
    leavingAnimation.dispose();

    super.dispose();
  }

  /// Starts the exercise over.
  /// Called when user taps the "Restart exercise" button.
  Future<void> restart() async {
    await leave();

    ExerciseRevealBloc.of(context).add(
      Restart(
        deck: widget.state.deck,
      ),
    );
  }

  /// Finishes the exercise and goes back to the previous screen.
  /// Called when user taps the "Finish" button.
  Future<void> finish() async {
    await leave();

    Navigator.pop(context);
  }

  /// Starts the "leaving screen" animation.
  Future<void> leave() async {
    setState(() {
      status = _SummaryViewStatus.leaving;
    });

    await leavingAnimation.start();

    // With this delay the UI seems more natural
    await Future.delayed(
      const Duration(milliseconds: 250),
    );
  }
}
