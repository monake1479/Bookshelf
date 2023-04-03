import 'package:dartz/dartz.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

abstract class DatabaseInterface {
  Future<Either<BookshelfException, Unit>> createDb(String databaseName);
  Future<Either<BookshelfException, Unit>> openDb(String databaseName);
  Future<void> closeDb();
  Future<Either<BookshelfException, List<Map<String, Object?>>>> getAll(
    String tableName,
  );
  Future<Either<BookshelfException, List<Map<String, Object?>>>> get(
    String tableName,
    int id,
  );
  Future<Either<BookshelfException, int>> insert(
    String tableName,
    Map<String, Object?> values,
  );
  Future<Either<BookshelfException, Unit>> update(
    String tableName,
    Map<String, Object?> values,
    int id,
  );
  Future<Either<BookshelfException, Unit>> delete(
    String tableName,
    int id,
  );
}
