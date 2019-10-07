import 'dart:async';

import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';
import 'initialized/active_decks.dart';
import 'initialized/archived_decks.dart';
import 'initialized/completed_decks.dart';

class InitializedView extends StatefulWidget {
  final InitializedState state;

  InitializedView({
    @required this.state,
  }) : assert(state != null);

  @override
  _InitializedViewState createState() {
    return _InitializedViewState();
  }
}

class _InitializedViewState extends State<InitializedView> {
  @override
  Widget build(BuildContext context) {
    DeckList buildDeckList(List<DeckViewModel> decks) {
      return DeckList(
        decks: decks,
        onDeckTapped: showDeckDetails,
        onDeckLongPressed: editDeck,
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Zestawy fiszek'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              DeckListTab(
                title: 'Aktywne',
                decks: widget.state.activeDecks,
              ),

              DeckListTab(
                title: 'Ukończone',
                decks: widget.state.completedDecks,
              ),

              DeckListTab(
                title: 'Zarchiwizowane',
                decks: widget.state.archivedDecks,
              ),
            ],
          ),
        ),

        body: TabBarView(children: [
          ActiveDecksSection(
            decks: buildDeckList(widget.state.activeDecks),
            onCreateDeckPressed: createDeck,
          ),

          CompletedDecksSection(
            decks: buildDeckList(widget.state.completedDecks),
          ),

          ArchivedDecksSection(
            decks: buildDeckList(widget.state.archivedDecks),
          ),
        ]),

        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          tooltip: 'Stwórz zestaw',
          onPressed: createDeck,
        ),
      ),
    );
  }

  /// Opens the [DeckDetails] modal.
  Future<void> showDeckDetails(DeckViewModel deck) async {
    await showDialog(
      context: context,
      builder: (context) {
        return DeckDetails(
          deck: deck,

          onDeletePressed: () {
            deleteDeck(deck);
          },

          onExercisePressed: () {
            showExercises(deck);
          },

          onEditPressed: () {
            editDeck(deck);
          },
        );
      },
    );
  }

  /// Opens the [ExerciseSelection] modal and navigates to selected exercise.
  Future<void> showExercises(DeckViewModel deck) async {
    final exercise = await showDialog(
      context: context,
      builder: (context) {
        return ExerciseSelection();
      },
    );

    if (exercise != null) {
      await Navigator.pushNamed(context, 'exercises--$exercise', arguments: deck.deck);

      refresh();
    }
  }

  /// Opens the [DeckForm], allowing user to create a new deck.
  Future<void> createDeck() async {
    await Navigator.pushNamed(context, 'decks--create');

    refresh();
  }

  /// Opens the [DeckForm], allowing user to edit specified deck.
  Future<void> editDeck(DeckViewModel deck) async {
    await Navigator.pushNamed(context, 'decks--update', arguments: deck.deck);

    refresh();
  }

  /// Opens the
  Future<void> deleteDeck(DeckViewModel deck) async {
    final confirmed = await confirm(
      context: context,
      title: 'Usunąć fiszkę?',
      message: 'Czy chcesz usunąć ten zestaw fiszek?',
      btnYes: 'USUŃ',
      btnNo: 'NIE USUWAJ',
    );

    if (confirmed) {
      DeckIndexBloc.of(context).add(
        DeleteDeck(
          deck: deck.deck,
        ),
      );

      refresh();
    }
  }

  /// Refreshes list of our decks.
  /// Should be called each time a deck is created, modified or deleted.
  void refresh() {
    DeckIndexBloc.of(context).add(
      Refresh(),
    );
  }
}
