import 'package:dartz/dartz.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

abstract class AuthorInterface {
  Future<Either<BookshelfException, List<Author>>> getAll();
  Future<Either<BookshelfException, Author>> get(
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
