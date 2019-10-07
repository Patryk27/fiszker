import 'package:sqflite/sqflite.dart';

/// Migrates database from version 0 to 1.
/// Should be executed in a transaction.
Future<void> migrate0(Database db) async {
  final queries = [
    """
    CREATE TABLE cards (
      id STRING NOT NULL PRIMARY KEY,
      deckId INT NOT NULL,
      front STRING NOT NULL,
      back STRING NOT NULL,
      createdAt DATETIME NOT NULL
    );
    """,

    """
    CREATE INDEX cards_deckId_idx ON cards (deckId);
    """,

    """
    CREATE TABLE decks (
      id STRING NOT NULL PRIMARY KEY,
      name STRING NOT NULL,
      status STRING NOT NULL,
      createdAt DATETIME NOT NULL,
      exercisedAt DATETIME
    );
    """,

    """
    CREATE INDEX decks_status_idx ON decks (status);
    """,
  ];

  for (final query in queries) {
    await db.execute(query);
  }
}
