import 'package:fiszker/migrations.dart';
import 'package:sqflite/sqflite.dart';

/// This class is responsible for migrating database's schema and contents; it's tightly coupled to the
/// [DatabaseProvider] and shouldn't be used on its own.
class DatabaseMigrator {
  /// Creates database from scratch.
  ///
  /// Executed automatically from [DatabaseProvider] when the application's database is not yet present (i.e. the
  /// application has been just freshly installed).
  static Future<void> create(Database db, int newVersion) async {
    print('Creating database...');

    for (var version = 0; version < newVersion; version += 1) {
      await _runMigration(db, version);
    }

    print('... database created.');
  }

  /// Upgrades database from one version to the other - that is: executes all [migrations] between [oldVersion] and
  /// [newVersion].
  static Future<void> upgrade(Database db, int oldVersion, int newVersion) async {
    assert(oldVersion < newVersion);

    print('Upgrading database from version [$oldVersion] to [$newVersion]:');

    for (var version = oldVersion; version < newVersion; version += 1) {
      await _runMigration(db, version);
    }

    print('... database upgraded.');
  }

  static Future<void> _runMigration(Database db, int version) async {
    print('-> running migration: $version');

    await migrations[version](db);
  }
}

