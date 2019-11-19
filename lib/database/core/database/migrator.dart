import 'package:fiszker/database.dart';
import 'package:sqflite/sqflite.dart';

/// This class is responsible for migrating database's schema and contents; it's tightly coupled to the
/// [DatabaseProvider] and shouldn't be used on its own.
class DatabaseMigrator {
  /// Creates database from scratch.
  ///
  /// Executed automatically from [DatabaseProvider] when the application's database is not yet present (i.e. the
  /// application has been just freshly installed).
  static Future<void> create(Database db, int version) async {
    print('(db) Seems like the application has been just installed - we have to intialize the database first.');
    print('(db) Migrating database to version `$version`:');

    for (var i = 0; i < version; i += 1) {
      await _runMigration(db, i);
    }

    print('(db) Ok, database created.');
  }

  /// Upgrades database from one version to the other - that is: executes all [migrations] between [oldVersion] and
  /// [newVersion].
  static Future<void> upgrade(Database db, int oldVersion, int newVersion) async {
    assert(oldVersion < newVersion);

    print('(db) Seems like the application has been upgraded - we have to upgrade the database too.');
    print('(db) Migrating the database from version `$oldVersion` to `$newVersion`:');

    for (var i = oldVersion; i < newVersion; i += 1) {
      await _runMigration(db, i);
    }

    print('(db) Ok, database upgraded.');
  }

  static Future<void> _runMigration(Database db, int version) async {
    print('(db) -> running migration: `$version`');

    await migrations[version](db);
  }
}

