import 'package:dartz/dartz.dart';
import 'package:ztp_projekt/books/models/book.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

abstract class BookInterface {
  Future<Either<BookshelfException, List<Book>>> getAll();
  Future<Either<BookshelfException, Book>> get(
    int id,
  );
  Future<Either<BookshelfException, int>> insert(
    Map<String, Object?> values,
  );
  Future<Either<BookshelfException, Unit>> update(
    Map<String, Object?> values,
    int id,
  );
  Future<Either<BookshelfException, Unit>> delete(
    int id,
  );
}
