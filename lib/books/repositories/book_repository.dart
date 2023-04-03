import 'package:dartz/dartz.dart';
import 'package:ztp_projekt/books/interfaces/book_interface.dart';
import 'package:ztp_projekt/books/models/book.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';
import 'package:ztp_projekt/common/models/table_name.dart';
import 'package:ztp_projekt/common/utils/either_extension.dart';
import 'package:ztp_projekt/database/interfaces/database_interface.dart';

class BookRepository implements BookInterface {
  const BookRepository(this._interface);
  final DatabaseInterface _interface;

  @override
  Future<Either<BookshelfException, List<Book>>> getAll() async {
    late Either<BookshelfException, List<Book>> result;
    final response = await _interface.getAll(TableName.books.name);
    if (response.isRight()) {
      final List<Book> books = [];
      final escapedResponse = response.getRightOrThrow();
      if (escapedResponse.isNotEmpty) {
        for (final book in escapedResponse) {
          books.add(Book.fromJson(book));
        }
      }
      result = right(books);
    } else {
      result = left(response.getLeftOrThrow());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, Book>> get(
    int id,
  ) async {
    late Either<BookshelfException, Book> result;
    final response = await _interface.get(TableName.books.name, id);
    if (response.isRight()) {
      final List<Book> books = [];
      final escapedResponse = response.getRightOrThrow();
      if (escapedResponse.isNotEmpty) {
        for (final book in escapedResponse) {
          books.add(Book.fromJson(book));
        }
      }
      result = right(books.first);
    } else {
      result = left(response.getLeftOrThrow());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, int>> insert(
    Map<String, Object?> values,
  ) async {
    late Either<BookshelfException, int> result;
    final response = await _interface.insert(TableName.books.name, values);
    if (response.isRight()) {
      result = right(response.getRightOrThrow());
    } else {
      result = left(response.getLeftOrThrow());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, Unit>> update(
    Map<String, Object?> values,
    int id,
  ) async {
    late Either<BookshelfException, Unit> result;
    final response = await _interface.update(TableName.books.name, values, id);
    if (response.isRight()) {
      result = right(unit);
    } else {
      result = left(response.getLeftOrThrow());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, Unit>> delete(
    int id,
  ) async {
    late Either<BookshelfException, Unit> result;
    final response = await _interface.delete(TableName.books.name, id);
    if (response.isRight()) {
      result = right(unit);
    } else {
      result = left(response.getLeftOrThrow());
    }
    return result;
  }
}
