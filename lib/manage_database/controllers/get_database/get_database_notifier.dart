import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ztp_projekt/core/utils/database_variables.dart';
import 'package:ztp_projekt/main.dart';
import 'package:ztp_projekt/manage_database/controllers/get_database/get_database_state.dart';
import 'package:ztp_projekt/manage_database/models/author.dart';
import 'package:ztp_projekt/manage_database/models/book.dart';

class GetDatabaseNotifier extends StateNotifier<GetDatabaseState> {
  GetDatabaseNotifier() : super(GetDatabaseState.initial());

  void reset() {
    state = GetDatabaseState.initial();
  }

  Future<List<Book>> getBooks() async {
    state = state.copyWith(isLoading: true);
    final bookshelfDatabase =
        await databaseFactoryFfi.openDatabase(databaseName);

    final List<Map<String, dynamic>> maps =
        await bookshelfDatabase.query(booksTableName);
    log('[GetBooks] maps: $maps');
    await bookshelfDatabase.close();
    return [];
  }

  Future<List<Author>> getAuthors() async {
    state = state.copyWith(isLoading: true);
    final bookshelfDatabase =
        await databaseFactoryFfi.openDatabase(databaseName);

    final List<Map<String, dynamic>> maps =
        await bookshelfDatabase.query(authorsTableName);
    log('[GetAuthors] maps: $maps');
    await bookshelfDatabase.close();
    return [];
  }
}
