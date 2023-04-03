import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/database/interfaces/database_interface.dart';
import 'package:ztp_projekt/database/repositories/sqlite_database_repository.dart';
import 'package:ztp_projekt/database/controllers/database_notifier.dart';

import 'package:ztp_projekt/database/controllers/database_state.dart';

final sqliteDatabaseRepositoryProvider = Provider<DatabaseInterface>(
  (ref) => SqliteDatabaseRepository(),
);

final databaseNotifierProvider =
    StateNotifierProvider<DatabaseNotifier, DatabaseState>(
  (ref) => DatabaseNotifier(
    ref.watch(sqliteDatabaseRepositoryProvider),
  ),
);
