import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';

/// This function is responsible for filtering and sorting [CardModel]s before they are rendered in the
/// [DeckFormCardsSection] widget.
///
/// Supported query types:
///
///   - box filter (like 'pudełko:2')
///     Returns only those cards, which belong to box with specified index.
///
///   - text filter (like 'computer')
///     Returns only those cards, which front or back side contain given string.
///
/// @todo could this be moved into DeckEntity?
List<CardModel> filterCards({
  @required List<CardModel> cards,
  @required List<BoxModel> boxes,
  String query
}) {
  assert(cards != null);
  assert(boxes != null);
  assert(query != null);

  // We're going to modify the list in-place, so we need a fresh copy
  cards = List.of(cards);

  // Apply filters
  if (query.isNotEmpty) {
    _tryApplyBoxFilter(cards, boxes, query) || _tryApplyTextFilter(cards, query);
  }

  // Do sorting
  _sort(cards);

  // Yay!
  return cards;
}

/// Tries to apply the "box filter" and returns whether it succeeded.
/// See: [filterCards]
bool _tryApplyBoxFilter(List<CardModel> cards, List<BoxModel> boxes, String query) {
  final boxFilter = RegExp(r'^pudełko:(\d+)$');
  final boxFilterMatch = boxFilter.firstMatch(query);

  // If our query is not a "box filter", give up
  if (boxFilterMatch == null) {
    return false;
  }

  // Extract index of the box user is trying to find cards for
  final boxIndex = int.parse(
    boxFilterMatch.group(1),
  );

  // We need box's id, not its index - so let's find it!
  Id boxId;

  for (final box in boxes) {
    if (box.index == boxIndex) {
      boxId = box.id;
      break;
    }
  }

  // Having the box's id prepared, we may now proceed to filtering:
  cards.retainWhere((card) {
    return card.boxId == boxId;
  });

  return true;
}

/// Tries to apply the "text filter" and returns whether it succeeded.
/// (gold tip: this function always return `true` for convenience)
///
/// See: [filterCards]
bool _tryApplyTextFilter(List<CardModel> cards, String query) {
  cards.retainWhere((card) {
    return card.front.contains(query) || card.back.contains(query);
  });

  return true;
}

/// Sorts the cards.
void _sort(List<CardModel> cards) {
  cards.sort((a, b) {
    final frontCmp = a.front.compareTo(b.front);
    final backCmp = a.back.compareTo(b.back);

    if (frontCmp != 0) {
      return frontCmp;
    }

    if (backCmp != 0) {
      return backCmp;
    }

    return a.id.compareTo(b.id);
  });
}
