import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/books/models/book.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

part 'get_books_state.freezed.dart';

@freezed
class GetBooksState with _$GetBooksState {
  const factory GetBooksState({
    required bool isLoading,
    required List<Book> books,
    required BookshelfException? exception,
  }) = _GetBooksState;
  factory GetBooksState.initial() => const GetBooksState(
        isLoading: false,
        books: [],
        exception: null,
      );
}

extension GetBooksStateEx on GetBooksState {
  bool get isException => exception != null;
}
