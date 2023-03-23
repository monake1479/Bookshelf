import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ztp_projekt/core/utils/database_variables.dart';
import 'package:ztp_projekt/manage_database/controllers/manage_database/manage_database_state.dart';
import 'package:ztp_projekt/manage_database/models/author.dart';

class ManageDatabaseNotifier extends StateNotifier<ManageDatabaseState> {
  ManageDatabaseNotifier() : super(ManageDatabaseState.initial());
  void reset() {
    state = ManageDatabaseState.initial();
  }

  Future<void> insertAuthor() async {
    state = state.copyWith(isLoading: true);
    final bookshelfDatabase =
        await databaseFactoryFfi.openDatabase(databaseName);
    final Author authorToInsert =
        Author(id: 1, firstName: 'Janek', lastName: 'Kowalski');
    await bookshelfDatabase.insert(
      authorsTableName,
      authorToInsert.toMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    state = state.copyWith(isLoading: false);
  }
}
