import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional.dart';

import 'bloc.dart';

class FinishingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FinishingScreenState();
}

enum _Status {
  entering,
  idling,
  leaving,
}

class _FinishingScreenState extends State<FinishingScreen> with TickerProviderStateMixin {
  _Status status = _Status.entering;

  Optional<FinishingBlocState> currentBlocState = Optional.empty();

  Animator enteringAnimator;
  Animator leavingAnimator;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FinishingBloc, FinishingBlocState>(
      listener: (context, state) async {
        // If we're already displaying a screen, we have to animate-it-out first
        if (currentBlocState.isPresent) {
          setState(() {
            status = _Status.leaving;
          });

          await leavingAnimator.start();
        }

        // Now we can safely animate-in the new screen
        setState(() {
          currentBlocState = Optional.of(state);
          status = _Status.entering;
        });

        await enteringAnimator.start();

        // ... and we're ready
        setState(() {
          status = _Status.idling;
        });
      },

      child: BlocBuilder<FinishingBloc, FinishingBlocState>(
        builder: (context, state) {
          if (!currentBlocState.isPresent) {
            currentBlocState = Optional.of(state);
          }

          switch (status) {
            case _Status.entering:
              return enteringAnimator.buildWidget(
                currentBlocState.value.buildWidget(),
              );

            case _Status.idling:
              return state.buildWidget();

            case _Status.leaving:
              return leavingAnimator.buildWidget(
                currentBlocState.value.buildWidget(),
              );
          }

          throw 'unreachable';
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    enteringAnimator = FadeInAnimator(vsync: this);
    leavingAnimator = ScaleOutAnimator(vsync: this);

    FinishingBloc.of(context).add(
      Start(),
    );
  }

  @override
  void dispose() {
    leavingAnimator.dispose();
    enteringAnimator.dispose();

    super.dispose();
  }
}
