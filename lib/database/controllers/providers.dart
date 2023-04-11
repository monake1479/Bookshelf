import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/database/controllers/database_notifier.dart';
import 'package:ztp_projekt/database/controllers/database_state.dart';
import 'package:ztp_projekt/database/interfaces/database_interface.dart';
import 'package:ztp_projekt/database/repositories/sqlite_database_repository.dart';

final sqliteDatabaseRepositoryProvider = Provider<DatabaseInterface>(
  (ref) => SqliteDatabaseRepository(),
);

final databaseNotifierProvider =
    StateNotifierProvider<DatabaseNotifier, DatabaseState>(
  (ref) => DatabaseNotifier(
    ref.watch(sqliteDatabaseRepositoryProvider),
    ref.watch(manageAuthorsNotifierProvider.notifier),
    ref.watch(manageBooksNotifierProvider.notifier),
  ),
);
