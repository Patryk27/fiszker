import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'events.dart';
import 'states.dart';

class AppInitializeScreen extends StatefulWidget {
  @override
  _AppInitializeScreenState createState() {
    return _AppInitializeScreenState();
  }
}

class _AppInitializeScreenState extends State<AppInitializeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppInitializeBloc, BlocState>(
      builder: (context, state) {
        return state.render();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    AppInitializeBloc.of(context).add(
      Initialize(),
    );
  }
}
