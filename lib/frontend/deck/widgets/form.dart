import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

import 'form/cards.dart';
import 'form/deck.dart';

/// Defines how the [DeckForm] should act - either as a "Create a new deck" or "Edit this deck" form.
enum DeckFormBehavior {
  createDeck,
  editDeck,
}

/// This widget models a [Screen] responsible for creating and updating decks.
///
/// It does not touch the database on its own, you have to provide meaningful handlers for the [onSubmit] and
/// [onDelete] events.
class DeckForm extends StatefulWidget {
  final DeckFormBehavior formBehavior;
  final DeckModel deck;
  final List<CardModel> cards;
  final void Function(DeckModel deck, List<CardModel> cards) onSubmit;

  /// Returns "Create a new deck" form.
  DeckForm.createDeck({
    @required this.onSubmit,
  })
      : formBehavior = DeckFormBehavior.createDeck,
        deck = DeckModel.create(),
        cards = [],
        assert(onSubmit != null);

  /// Returns "Edit this deck" form.
  DeckForm.updateDeck({
    @required this.deck,
    @required this.cards,
    @required this.onSubmit,
  })
      : formBehavior = DeckFormBehavior.editDeck,
        assert(deck != null),
        assert(cards != null),
        assert(onSubmit != null);

  @override
  _DeckFormState createState() {
    return _DeckFormState(deck, List.from(cards));
  }
}

class _DeckFormState extends State<DeckForm> with SingleTickerProviderStateMixin {
  _DeckFormState(this.deck, this.cards);

  final formKey = GlobalKey<FormState>();

  DeckModel deck;
  List<CardModel> cards;
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmDismiss,

      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: maybeDismiss,
          ),

          title: (widget.formBehavior == DeckFormBehavior.createDeck)
              ? const Text('Tworzenie zestawu fiszek')
              : const Text('Edycja zestawu fiszek'),

          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                submit();
              },
            ),
          ],

          bottom: TabBar(
            controller: tabController,
            tabs: [
              const Tab(text: 'Zestaw'),
              const Tab(text: 'Fiszki'),
            ],
          ),
        ),

        body: Form(
          key: formKey,

          child: TabBarView(
            controller: tabController,

            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: DeckFormDeckSection(
                  deck: deck,
                  onDeckUpdated: handleDeckUpdated,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: DeckFormCardsSection(
                  cards: cards,
                  onCreateCardPressed: createCard,
                  onUpdateCardPressed: updateCard,
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Dodaj fiszkę',
          onPressed: createCard,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  /// Validates the form and, if everything is correct, submits it.
  void submit() {
    // @todo if validation fails, jump to appropriate tab

    if (formKey.currentState.validate()) {
      widget.onSubmit(deck, cards);
    }
  }

  /// Opens the "Creating a card" modal.
  void createCard() {
    // Open the "Cards" tab
    tabController.animateTo(1);

    // Show modal
    showDialog(
      context: context,
      builder: (context) {
        return CardForm.createCard(
          deckId: deck.id,
          onSubmit: handleCardCreated,
        );
      },
    );
  }

  /// Opens the "Updating a card" modal with specified flashcard.
  void updateCard(CardModel card) {
    showDialog(
      context: context,
      builder: (context) {
        return CardForm.updateCard(
          card: card,
          onSubmit: handleCardUpdated,
          onDelete: handleCardDeleted,
        );
      },
    );
  }

  /// Handles the "deck updated" event, updating widget's state.
  void handleDeckUpdated(DeckModel deck) {
    setState(() {
      this.deck = deck;
    });
  }

  /// Handles the "card created" event, updating widget's state.
  void handleCardCreated(CardModel card) {
    setState(() {
      cards.add(card);
    });
  }

  /// Handles the "card updated" event, updating widget's state.
  void handleCardUpdated(CardModel card) {
    setState(() {
      cards
        ..removeWhere((card2) => card2.id == card.id)
        ..add(card);
    });
  }

  /// Handles the "card deleted" event, updating widget's state.
  void handleCardDeleted(CardModel card) {
    setState(() {
      cards..removeWhere((card2) => card2.id == card.id);
    });
  }

  /// Returns whether this form is dirty (i.e. whether is contains any unsaved changes).
  bool isDirty() {
    if (!deck.isEqualTo(widget.deck)) {
      return true;
    }

    if (cards.length != widget.cards.length) {
      return true;
    }

    for (var i = 0; i < cards.length; i += 1) {
      if (!cards[i].isEqualTo(widget.cards[i])) {
        return true;
      }
    }

    return false;
  }

  /// Asks the user whether they want to abandon the form and, if confirmed, pops back to the previous screen.
  Future<void> maybeDismiss() async {
    if (await confirmDismiss()) {
      Navigator.pop(context);
    }
  }

  /// Asks the user whether they want to abandon the form and returns the confirmation's result.
  Future<bool> confirmDismiss() async {
    // If the form's not dirty, don't bother asking user
    if (!isDirty()) {
      return true;
    }

    return await confirm(
      context: context,
      title: 'Zamknąć formularz?',
      message: 'Czy chcesz zamknąć formularz?\nStracisz niezapisane zmiany.',
    );
  }
}
