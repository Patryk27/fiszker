import 'dart:math';

import 'package:fiszker/database.dart';
import 'package:fiszker/debug.dart';
import 'package:optional/optional.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// This class is responsible for providing access to the SQLite [Database].
///
/// The [initialize] method is called during the initialization (see: [AppInitializeScreen]) and then all the SQLite
/// repositories get to feast on the [get] method.
class DatabaseProvider {
  Optional<Database> _db = const Optional.empty();

  /// Initializes the database for reading and writing.
  /// This method is called automatically during application initialization and must not be called twice.
  Future<void> initialize() async {
    // When the in-memory repositories are enabled, this method shouldn't even be called - thus this exception
    if (DEBUG_ENABLE_IN_MEMORY_REPOSITORIES) {
      throw 'cannot open database while in-memory repositories are active';
    }

    // Since this method should only be called once during the entire lifetime of the application, calling it twice may
    // be a serious bug
    if (_db.isPresent) {
      throw 'database has been already opened';
    }

    final path = join(await getDatabasesPath(), 'fiszker.db');

    print('(db) Opening database: [$path]');

    _db = Optional.of(await openDatabase(
      path,
      version: migrations.keys.reduce(max) + 1,

      onCreate: (db, version) async {
        await DatabaseMigrator.create(db, version);
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        await DatabaseMigrator.upgrade(db, oldVersion, newVersion);
      },

      onOpen: (_) {
        print('(db) Ok, database opened and ready.');
      },
    ));
  }

  /// Returns instance of the [Database].
  /// The [initialize] method must have been called before.
  Database get() {
    return _db.orElseThrow(() {
      return 'database has not been opened yet';
    });
  }
}
