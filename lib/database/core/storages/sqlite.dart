import 'package:fiszker/database.dart';
import 'package:sqflite/sqflite.dart';

abstract class SqliteStorage {
  SqliteStorage(this.databaseProvider) : assert(databaseProvider != null);

  final DatabaseProvider databaseProvider;

  Database get db {
    return databaseProvider.get();
  }
}
