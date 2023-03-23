import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ztp_projekt/bookshelf_app.dart';
import 'package:ztp_projekt/core/utils/database_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bookshelfDatabase = await databaseFactoryFfi.openDatabase(databasePath);

  await bookshelfDatabase.execute(
    createAuthorsTableQuery,
  );
  await bookshelfDatabase.execute(
    createBooksTableQuery,
  );
  await bookshelfDatabase.execute(
    initAuthorsTable,
  );
  await bookshelfDatabase.execute(
    initBooksTable,
  );
  await bookshelfDatabase.close();

  runApp(
    const ProviderScope(child: BookshelfApp()),
  );
}
