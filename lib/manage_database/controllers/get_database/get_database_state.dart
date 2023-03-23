import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/manage_database/models/author.dart';
import 'package:ztp_projekt/manage_database/models/book.dart';

part 'get_database_state.freezed.dart';

@freezed
class GetDatabaseState with _$GetDatabaseState {
  const factory GetDatabaseState({
    required bool isLoading,
    required Option<Either<Exception, Unit>> failureOrSuccessOption,
    required List<Book> books,
    required List<Author> authors,
  }) = _GetDatabaseState;
  factory GetDatabaseState.initial() => GetDatabaseState(
        isLoading: false,
        failureOrSuccessOption: none(),
        books: [],
        authors: [],
      );
}
