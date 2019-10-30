import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:optional/optional.dart';

import 'form/boxes.dart';
import 'form/cards.dart';
import 'form/deck.dart';

typedef DeckFormSubmitHandler(DeckEntity deck);

/// Defines how the [DeckForm] should act as - that is: whether it's supposed to work in the "Create a deck" or the
/// "Edit a deck" mode.
enum DeckFormBehavior {
  createDeck,
  editDeck,
}

/// This widget models an entire scaffold responsible for creating and editing single decks.
///
/// # Safety
///
/// This widget makes no changes to the database on its own - you have to provide meaningful handlers for the [onSubmit]
/// and [onDelete] events.
class DeckForm extends StatefulWidget {
  final DeckFormBehavior formBehavior;

  /// The deck we're modifying.
  final DeckEntity deck;

  /// Handler for the "form submitted" event.
  /// It's responsible for actually committing data to the database.
  final DeckFormSubmitHandler onSubmit;

  DeckForm({
    @required this.formBehavior,
    @required this.deck,
    @required this.onSubmit,
  })
      : assert(formBehavior != null),
        assert(deck != null),
        assert(onSubmit != null);

  @override
  State<DeckForm> createState() => _DeckFormState(deck.deck, List.of(deck.boxes), List.of(deck.cards));
}

class _DeckFormState extends State<DeckForm> with SingleTickerProviderStateMixin {
  _DeckFormState(this.deck, this.boxes, this.cards);

  final formKey = GlobalKey<FormState>();

  /// This is a controller for the [CardListSearcher] widget.
  /// It's been extracted as far as here, so that we can modify the query programmatically.
  final cardsQueryController = TextEditingController();

  TabController tabController;

  DeckModel deck;
  List<BoxModel> boxes;
  List<CardModel> cards;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmClose,

      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: maybeClose,
          ),

          title: (widget.formBehavior == DeckFormBehavior.createDeck)
              ? const Text('Tworzenie zestawu fiszek')
              : const Text('Edycja zestawu fiszek'),

          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: submit,
            ),
          ],

          bottom: TabBar(
            controller: tabController,
            tabs: [
              const Tab(text: 'Zestaw'),
              const Tab(text: 'Fiszki'),
              const Tab(text: 'Pudełka'),
            ],
          ),
        ),

        body: Form(
          key: formKey,

          child: TabBarView(
            controller: tabController,

            children: [
              DeckFormDeckSection(
                deck: deck,
                onDeckEdited: handleDeckEdited,
              ),

              DeckFormCardsSection(
                cards: cards,
                boxes: boxes,
                queryController: cardsQueryController,
                onCreateCard: createCard,
                onEditCard: editCard,
              ),

              DeckFormBoxesSection(
                boxes: boxes,
                cards: cards,
                onCreateBox: createBox,
                onShowBox: editBox,
                onMoveBox: handleBoxMoved,
              ),
            ],
          ),
        ),

        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,

          children: [
            SpeedDialChild(
              child: Icon(Icons.inbox),
              backgroundColor: Colors.blue,
              label: 'Dodaj pudełko',
              labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
              onTap: createBox,
            ),

            SpeedDialChild(
              child: Icon(Icons.layers),
              backgroundColor: Colors.green,
              label: 'Dodaj fiszkę',
              labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
              onTap: createCard,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: 3);

    cardsQueryController.addListener(() {
      setState(() {
        // Required for widget to repaint
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    cardsQueryController.dispose();

    super.dispose();
  }

  /// Validates the form and, if everything is correct, submits it.
  void submit() {
    // Validate the form; if it's invalid, don't bother submitting
    if (!formKey.currentState.validate()) {
      // Currently only the deck's name can be entered incorrectly here - thanks to this we can safely force-jump to the
      // first tab
      tabController.animateTo(0);

      return;
    }

    widget.onSubmit(
      DeckEntity(
        deck: deck,
        boxes: boxes,
        cards: cards,
      ),
    );
  }

  /// Opens the [CardForm], allowing user to create a new flashcard.
  Future<void> createCard() async {
    // Navigate to the "Cards" tab
    tabController.animateTo(1);

    // Determine which box is the first one (this is the one we're going to assign the card to by the default)
    final firstBox = boxes.firstWhere((box) => box.index == 1);

    // Open the card form
    await showCreateCardForm(
      context: context,
      boxes: boxes,
      onSubmit: handleCardCreated,

      card: CardModel.create(
        deckId: deck.id,
        boxId: firstBox.id,
      ),
    );
  }

  /// Opens the [CardForm], allowing user to edit given flashcard.
  Future<void> editCard(CardModel card) async {
    await showEditCardForm(
      context: context,
      card: card,
      boxes: boxes,
      onSubmit: handleCardEdited,

      onDelete: () {
        handleCardDeleted(card);
      },
    );
  }

  /// Opens the [BoxForm], allowing user to create a new box.
  Future<void> createBox() async {
    // Navigate to the "Boxes" tab
    tabController.animateTo(2);

    // Open the box form
    await showCreateBoxForm(
      context: context,
      onSubmit: handleBoxCreated,

      box: BoxModel.create(
        deckId: deck.id,
        index: boxes.length + 1,
      ),
    );
  }

  /// Opens the [BoxForm], allowing user to remove existing box.
  Future<void> editBox(BoxModel box) async {
    // Find all cards that belong to this box
    final boxCards = cards
        .where((card) => card.belongsToBox(box))
        .toList();

    final onShowCards = boxCards.isEmpty ? null : () {
      // Update the query
      setState(() {
        cardsQueryController.text = "pudełko:${box.index}";
      });

      // Navigate to the "Cards" tab
      tabController.animateTo(1);
    };

    final onDelete = (boxes.length < 3) ? null : () {
      handleBoxDeleted(box);
    };

    await showEditBoxForm(
      context: context,
      box: box,
      onSubmit: handleBoxEdited,
      onDelete: Optional.ofNullable(onDelete),
      onShowCards: Optional.ofNullable(onShowCards),
    );
  }

  /// Handles the "deck edited" event, updating widget's state.
  /// Event originator: [DeckFormDeckSection]
  void handleDeckEdited(DeckModel deck) {
    setState(() {
      this.deck = deck;
    });
  }

  /// Handles the "card created" event, updating widget's state.
  /// Event originator: [DeckFormCardsSection]
  void handleCardCreated(CardModel card) {
    setState(() {
      cards.add(card);
    });
  }

  /// Handles the "card edited" event, updating widget's state.
  /// Event originator: [DeckFormCardsSection]
  void handleCardEdited(CardModel card) {
    setState(() {
      cards
        ..removeWhere((card2) => card2.id == card.id)
        ..add(card);
    });
  }

  /// Handles the "card deleted" event, updating widget's state.
  /// Event originator: [DeckFormCardsSection]
  void handleCardDeleted(CardModel card) {
    setState(() {
      cards.removeWhere((card2) => card2.id == card.id);
    });
  }

  /// Handles the "box created" event, updating widget's state.
  /// Event originator: [DeckFormBoxesSection]
  void handleBoxCreated(BoxModel box) {
    setState(() {
      boxes.add(box);
    });
  }

  /// Handles the "box edited" event, updating widget's state.
  ///
  /// Event originator: [DeckFormBoxesSection]
  ///
  /// Event restrictions: the [BoxModel.index] property must remain unchanged - if you want to move a box, use the
  /// [handleBoxMoved] method.
  void handleBoxEdited(BoxModel box) {
    setState(() {
      boxes
        ..removeWhere((box2) => box2.id == box.id)
        ..add(box);
    });
  }

  /// Handles the "box moved" event, updating widget's state.
  /// Event originator: [DeckFormBoxesSection]
  void handleBoxMoved(BoxModel box, int newIndex) {
    setState(() {
      int oldIndex = box.index;

      boxes = boxes.map((box2) {
        if (box2.id == box.id) {
          return box2.copyWith(index: newIndex);
        }

        if (newIndex < oldIndex) {
          if (box2.index >= newIndex && box2.index < oldIndex) {
            return box2.copyWith(index: box2.index + 1);
          }
        } else {
          if (box2.index > oldIndex && box2.index <= newIndex) {
            return box2.copyWith(index: box2.index - 1);
          }
        }

        return box2;
      }).toList();
    });
  }

  /// Handles the "box deleted" event, updating widget's state.
  /// Event originator: [DeckFormBoxesSection]
  void handleBoxDeleted(BoxModel box) {
    setState(() {
      // Since we're deleting a box, we have to decide what happens to all the cards that are currently located inside
      // it - they should be moved either to the next box or to the previous one.
      BoxModel targetBox = boxes.firstWhere((box2) => box2.index == box.index + 1, orElse: () => null);

      // If there's no next box (i.e. the user just removed the first box), let's move all the cards to the next one
      if (targetBox == null) {
        targetBox = boxes.firstWhere((box2) => box2.index == box.index - 1);
      }

      // Relocate cards to the target box
      cards = cards.map((card) {
        return card.copyWith(
          boxId: card.belongsToBox(box) ? targetBox.id : card.boxId,
        );
      }).toList();

      // Now we have to re-index all the boxes that come after this one, so that we don't end up with a hole in our
      // numeration
      boxes = boxes.map((box2) {
        return box2.copyWith(
          index: (box2.index >= box.index) ? (box2.index - 1) : box2.index,
        );
      }).toList();

      // And now, eventually, we can safely delete the box
      boxes..removeWhere((box2) => box2.id == box.id);
    });
  }

  /// Returns whether this form is dirty (i.e. whether it contains any unsaved changes).
  bool isDirty() {
    return (deck != widget.deck.deck)
           || !listEquals(boxes, widget.deck.boxes)
           || !listEquals(cards, widget.deck.cards);
  }

  /// Asks user whether they want to close this form (if it's dirty) and returns the confirmation's result.
  Future<bool> confirmClose() async {
    // If the form's not dirty, let's not even bother asking user
    if (!isDirty()) {
      return true;
    }

    return await confirm(
      context: context,

      title: 'Porzucić zestaw?',
      noLabel: 'WRÓĆ',
      yesLabel: 'PORZUĆ ZMIANY',

      message: (widget.formBehavior == DeckFormBehavior.createDeck)
          ? 'Czy chcesz porzucić tworzenie tego zestawu?\nStracisz niezapisane zmiany.'
          : 'Czy chcesz porzucić edycję tego zestawu?\nStracisz niezapisane zmiany.',
    );
  }

  /// Asks user whether they want to close this form and, if confirmed, actually closes it.
  Future<void> maybeClose() async {
    if (await confirmClose()) {
      close();
    }
  }

  /// Closes this form, returning control to the parent.
  void close() {
    Navigator.pop(context);
  }
}
