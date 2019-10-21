import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'events.dart';
import 'states.dart';

class DeckFormScreen extends StatefulWidget {
  final DeckFormBehavior formBehavior;
  final DeckModel deck;

  DeckFormScreen.createDeck()
      : formBehavior = DeckFormBehavior.createDeck,
        deck = DeckModel.create();

  DeckFormScreen.editDeck({
    @required this.deck,
  })
      : formBehavior = DeckFormBehavior.editDeck,
        assert(deck != null);

  @override
  _DeckFormScreenState createState() {
    return _DeckFormScreenState();
  }
}

class _DeckFormScreenState extends State<DeckFormScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeckFormBloc, BlocState>(
      listener: (context, state) {
        if (state is SubmittedState) {
          Navigator.pop(context);
        }
      },

      child: BlocBuilder<DeckFormBloc, BlocState>(
        builder: (context, state) {
          return state.render();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    DeckFormBloc.of(context).add(
      Initialize(
        formBehavior: widget.formBehavior,
        deck: widget.deck,
      ),
    );
  }
}
