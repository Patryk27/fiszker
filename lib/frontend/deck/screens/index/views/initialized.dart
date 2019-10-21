import 'dart:async';

import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:fiszker/frontend/deck/screens/index/views/initialized/deck_bottom_sheet.dart';
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
    await showModalBottomSheet(
      context: context,

      builder: (context) {
        return DeckBottomSheet(
          deck: deck,

          onEditPressed: () async {
            editDeck(deck, replaceCurrentRoute: true);
          },

          onDeletePressed: () async {
            await deleteDeck(deck);

            Navigator.pop(context);
          },

          onExerciseSelected: (exercise) async {
            startExercise(deck, exercise);
          },
        );
      },
    );
  }

  /// Opens the [DeckForm], allowing user to create a new deck.
  Future<void> createDeck() async {
    await Navigator.pushNamed(context, 'decks--create');

    refresh();
  }

  /// Opens the [DeckForm], allowing user to edit specified deck.
  Future<void> editDeck(DeckViewModel deck, {bool replaceCurrentRoute = false}) async {
    if (replaceCurrentRoute) {
      await Navigator.pushReplacementNamed(context, 'decks--update', arguments: deck.deck);
    } else {
      await Navigator.pushNamed(context, 'decks--update', arguments: deck.deck);
    }

    refresh();
  }

  /// Asks the user whether they want to delete given deck and, if confirmed, actually deletes it.
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

  /// Starts specified exercise.
  Future<void> startExercise(DeckViewModel deck, String exercise) async {
    await Navigator.pushReplacementNamed(
      context,
      'exercises--$exercise',
      arguments: deck.deck,
    );

    refresh();
  }

  /// Refreshes list of our decks.
  /// Should be called each time a deck is created, modified or deleted.
  void refresh() {
    DeckIndexBloc.of(context).add(
      Refresh(),
    );
  }
}
