import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

abstract class SqliteRepository {
  SqliteRepository({
    @required this.databaseProvider,
  }) : assert(databaseProvider != null);

  final DatabaseProvider databaseProvider;

  Database get db {
    return databaseProvider.get();
  }
}
