import 'package:dartz/dartz.dart';
import 'package:ztp_projekt/authors/interfaces/author_interface.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';
import 'package:ztp_projekt/common/models/table_name.dart';
import 'package:ztp_projekt/common/utils/either_extension.dart';
import 'package:ztp_projekt/database/interfaces/database_interface.dart';

class AuthorRepository implements AuthorInterface {
  const AuthorRepository(this._interface);
  final DatabaseInterface _interface;

  @override
  Future<Either<BookshelfException, List<Author>>> getAll() async {
    late Either<BookshelfException, List<Author>> result;
    final response = await _interface.getAll(tableName: TableName.authors.name);
    if (response.isRight()) {
      final List<Author> authors = [];
      final escapedResponse = response.getRightOrThrow();
      if (escapedResponse.isNotEmpty) {
        for (final author in escapedResponse) {
          authors.add(Author.fromJson(author));
        }
      }
      result = right(authors);
    } else {
      result = left(response.getLeftOrThrow());
    }
    return result;
  }

  @override
  Future<Either<BookshelfException, Author>> get(
    int id,
  ) async {
    late Either<BookshelfException, Author> result;
    final response = await _interface.get(TableName.authors.name, id);
    if (response.isRight()) {
      final List<Author> authors = [];
      final escapedResponse = response.getRightOrThrow();
      if (escapedResponse.isNotEmpty) {
        for (final author in escapedResponse) {
          authors.add(Author.fromJson(author));
        }
      }
      result = right(authors.first);
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
    final response = await _interface.insert(TableName.authors.name, values);
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
    final response =
        await _interface.update(TableName.authors.name, values, id);
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
    final response = await _interface.delete(TableName.authors.name, id);
    if (response.isRight()) {
      result = right(unit);
    } else {
      result = left(response.getLeftOrThrow());
    }
    return result;
  }
}
