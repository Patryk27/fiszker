import 'package:fiszker/database.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional.dart';

import 'bloc.dart';

class DeckFormScreen extends StatefulWidget {
  final Optional<Id> deckId;

  DeckFormScreen.createDeck()
      : deckId = Optional.empty();

  DeckFormScreen.editDeck({Id deckId})
      : deckId = Optional.of(deckId);

  @override
  State<DeckFormScreen> createState() => _DeckFormScreenState();
}

class _DeckFormScreenState extends State<DeckFormScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeckFormBloc, DeckFormBlocState>(
      listener: (context, state) {
        if (state is Submitted) {
          Navigator.pop(context);
        }
      },

      child: BlocBuilder<DeckFormBloc, DeckFormBlocState>(
        builder: (context, state) {
          return state.buildWidget();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    DeckFormBloc.of(context).add(
      Initialize(
        deckId: widget.deckId,
      ),
    );
  }
}
