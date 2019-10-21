import 'dart:async';

import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import '../events.dart';
import '../states.dart';

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

        body: TabBarView(
          children: [
            // Active decks
            DeckListTabView(
              decks: widget.state.activeDecks,

              listBuilder: (context) {
                return DeckList(
                  decks: widget.state.activeDecks,
                  onDeckTapped: openDeck,
                  onDeckLongPressed: editDeck,
                );
              },

              emptyListBuilder: (context) {
                return EmptyList(
                  icon: Icons.layers,
                  title: 'Nie masz aktywnych zestawów',
                  message: 'Aby stworzyć zestaw, naciśnij plus widoczny u dołu ekranu lub wybierz:',
                  callToAction: 'STWÓRZ ZESTAW',
                  onCallToAction: createDeck,
                );
              },
            ),

            // Completed decks
            DeckListTabView(
              decks: widget.state.completedDecks,

              listBuilder: (context) {
                return DeckList(
                  decks: widget.state.completedDecks,
                  onDeckTapped: openDeck,
                  onDeckLongPressed: editDeck,
                );
              },

              emptyListBuilder: (context) {
                return EmptyList(
                  icon: Icons.check,
                  title: 'Nie masz ukończonych zestawów',
                  message: '... ale nie przejmuj się - na pewno w try miga coś uda Ci się ukończyć!',
                );
              },
            ),

            // Archived deck
            DeckListTabView(
              decks: widget.state.archivedDecks,

              listBuilder: (context) {
                return DeckList(
                  decks: widget.state.archivedDecks,
                  onDeckTapped: openDeck,
                  onDeckLongPressed: editDeck,
                );
              },

              emptyListBuilder: (context) {
                return EmptyList(
                  icon: Icons.archive,
                  title: 'Nie masz zarchiwizowanych zestawów',
                  message: 'Tutaj pojawią się wszystkie zestawy fiszek, które zarchiwizujesz.',
                );
              },
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          tooltip: 'Stwórz zestaw',
          onPressed: createDeck,
        ),
      ),
    );
  }

  /// Opens the [DeckDetails] modal.
  Future<void> openDeck(DeckViewModel deck) async {
    await showModalBottomSheet(
      context: context,

      builder: (context) {
        return DeckBottomSheet(
          deck: deck,

          onEditPressed: () async {
            editDeck(deck, replaceCurrentRoute: true);
          },

          onDeletePressed: () async {
            if (await deleteDeck(deck)) {
              Navigator.pop(context);
            }
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
  ///
  /// The [replaceCurrentRoute] flag should be enabled if a bottom sheet is currently opened - this way the transition
  /// is way smoother.
  Future<void> editDeck(DeckViewModel deck, {bool replaceCurrentRoute = false}) async {
    if (replaceCurrentRoute) {
      await Navigator.pushReplacementNamed(context, 'decks--edit', arguments: deck.deck);
    } else {
      await Navigator.pushNamed(context, 'decks--edit', arguments: deck.deck);
    }

    refresh();
  }

  /// Asks user whether they want to delete given deck and, if confirmed, actually deletes it.
  /// Returns a value indicating whether the deck was deleted or not.
  Future<bool> deleteDeck(DeckViewModel deck) async {
    final confirmed = await confirm(
      context: context,
      title: 'Usunąć zestaw?',
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

    return confirmed;
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
