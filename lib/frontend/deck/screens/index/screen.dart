import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'events/initialize.dart';
import 'states.dart';

class DeckIndexScreen extends StatefulWidget {
  @override
  _DeckIndexScreenState createState() {
    return _DeckIndexScreenState();
  }
}

class _DeckIndexScreenState extends State<DeckIndexScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckIndexBloc, BlocState>(
      builder: (context, state) {
        return state.render();
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
