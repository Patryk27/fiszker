import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'events/initialize.dart';
import 'states.dart';

class DeckIndexScreen extends StatefulWidget {
  @override
  State<DeckIndexScreen> createState() => _DeckIndexScreenState();
}

class _DeckIndexScreenState extends State<DeckIndexScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckIndexBloc, DeckIndexBlocState>(
      builder: (context, state) {
        return state.buildWidget();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    DeckIndexBloc.of(context).add(
      Initialize(),
    );
  }
}
