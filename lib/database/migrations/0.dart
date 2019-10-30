import 'package:sqflite/sqflite.dart';

/// Migrates database from version 0 to version 1.
/// Should be executed in a transaction.
Future<void> migrate0(Database db) async {
  final queries = [
    """
    CREATE TABLE `decks` (
      `id` STRING NOT NULL PRIMARY KEY,
      `name` STRING NOT NULL,
      `status` STRING NOT NULL,
      `createdAt` DATETIME NOT NULL,
      `exercisedAt` DATETIME
    );
    """,

    """
    CREATE INDEX `decks_name_idx` ON `decks` (`name`);
    """,

    """
    CREATE INDEX `decks_status_idx` ON `decks` (`status`);
    """,

    """
    CREATE TABLE `boxes` (
      `id` STRING NOT NULL PRIMARY KEY,
      `deckId` STRING NOT NULL,
      `index` INT NOT NULL,
      `name` STRING NOT NULL, 
      `createdAt` DATETIME NOT NULL,
      `exercisedAt` DATETIME
    );
    """,

    """
    CREATE INDEX `boxes_deckId_idx` ON `boxes` (`deckId`);
    """,

    """
    CREATE TABLE `cards` (
      `id` STRING NOT NULL PRIMARY KEY,
      `deckId` STRING NOT NULL,
      `boxId` STRING NOT NULL,
      `front` STRING NOT NULL,
      `back` STRING NOT NULL,
      `createdAt` DATETIME NOT NULL,
      `exercisedAt` DATETIME
    );
    """,

    """
    CREATE INDEX `cards_deckId_idx` ON `cards` (`deckId`);
    """,

    """
    CREATE INDEX `cards_boxId_idx` ON `cards` (`boxId`);
    """,
  ];

  for (final query in queries) {
    await db.execute(query);
  }
}
