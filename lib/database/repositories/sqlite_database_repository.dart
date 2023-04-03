import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';
import 'package:ztp_projekt/common/utils/database_variables.dart';
import 'package:ztp_projekt/database/interfaces/database_interface.dart';

class SqliteDatabaseRepository implements DatabaseInterface {
  factory SqliteDatabaseRepository() =>
      _instance ?? SqliteDatabaseRepository._();
  SqliteDatabaseRepository._() {
    _setDatabasesPath();
  }
  static Database? _db;

  static SqliteDatabaseRepository? _instance;

  Future<void> _setDatabasesPath() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final Directory databaseDirectory =
        Directory('${documentsDirectory.path}/bookshelf/');
    if (!await databaseDirectory.exists()) {
      await databaseDirectory.create(recursive: true);
    }
    await databaseFactoryFfi
        .setDatabasesPath('${documentsDirectory.path}/bookshelf');
  }

  @override
  Future<Either<BookshelfException, Unit>> createDb(String databaseName) async {
    late Either<BookshelfException, Unit> result;

    final databasePath = join(await getDatabasesPath(), databaseName);
    if (!await databaseFactoryFfi.databaseExists(databasePath)) {
      _db = await databaseFactoryFfi.openDatabase(
        databasePath,
      );
      await _db?.execute(createAuthorsTableQuery);
      await _db?.execute(createBooksTableQuery);
      await closeDb();
      result = right(unit);
    } else {
      result = left(const BookshelfException.databaseExist());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, Unit>> openDb(String databaseName) async {
    late Either<BookshelfException, Unit> result;
    if (_db != null && !_db!.isOpen) {
      final databasePath = join(await getDatabasesPath(), databaseName);
      _db = await databaseFactoryFfi.openDatabase(
        databasePath,
      );
      if (_db == null) {
        result = left(
          const BookshelfException.custom(
            message:
                'Something went wrong while opening database, please check database name and path.',
          ),
        );
      } else {
        result = right(unit);
      }
    } else {
      result = left(const BookshelfException.databaseAlreadyOpened());
    }
    return result;
  }

  @override
  Future<void> closeDb() async {
    await _db?.close();
  }

  @override
  Future<Either<BookshelfException, List<Map<String, Object?>>>> getAll(
    String tableName,
  ) async {
    late Either<BookshelfException, List<Map<String, Object?>>> result;
    if (_db != null && _db!.isOpen) {
      final response = await _db!.query(tableName);
      result = right(response);
    } else {
      result = left(const BookshelfException.databaseIsClosed());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, List<Map<String, Object?>>>> get(
    String tableName,
    int id,
  ) async {
    late Either<BookshelfException, List<Map<String, Object?>>> result;
    if (_db != null && _db!.isOpen) {
      final response = await _db!.query(tableName, whereArgs: [id]);
      result = right(response);
    } else {
      result = left(const BookshelfException.databaseIsClosed());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, int>> insert(
    String tableName,
    Map<String, Object?> values,
  ) async {
    late Either<BookshelfException, int> result;
    if (_db != null && _db!.isOpen) {
      final response = await _db!.insert(
        tableName,
        values,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      if (response != 0) {
        result = right(response);
      } else {
        result = left(const BookshelfException.insertError());
      }
    } else {
      result = left(const BookshelfException.databaseIsClosed());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, Unit>> update(
    String tableName,
    Map<String, Object?> values,
    int id,
  ) async {
    late Either<BookshelfException, Unit> result;
    if (_db != null && _db!.isOpen) {
      final response = await _db!.update(
        tableName,
        values,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      if (response != 0) {
        result = right(unit);
      } else {
        result = left(const BookshelfException.updateError());
      }
    } else {
      result = left(const BookshelfException.databaseIsClosed());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, Unit>> delete(
    String tableName,
    int id,
  ) async {
    late Either<BookshelfException, Unit> result;
    if (_db != null && _db!.isOpen) {
      final response =
          await _db!.delete(tableName, where: 'id = ?', whereArgs: [id]);

      if (response != 0) {
        result = right(unit);
      } else {
        result = left(
          const BookshelfException.custom(
            message: 'The record does not exist under the given id.',
          ),
        );
      }
    } else {
      result = left(const BookshelfException.databaseIsClosed());
    }
    return result;
  }
}
