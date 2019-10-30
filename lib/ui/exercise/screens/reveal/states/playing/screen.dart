import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class PlayingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayingBloc, PlayingBlocState>(
      builder: (context, state) {
        return state.buildWidget(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    PlayingBloc.of(context).add(
      Start(),
    );
  }
}
