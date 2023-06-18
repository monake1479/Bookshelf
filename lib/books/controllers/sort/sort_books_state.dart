import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/books/models/book.dart';
import 'package:ztp_projekt/books/models/books_sort_field.dart';
import 'package:ztp_projekt/explorer/models/sort_type_enum.dart';

part 'sort_books_state.freezed.dart';

@freezed
class SortBooksState with _$SortBooksState {
  const factory SortBooksState({
    required bool isLoading,
    required List<Book> books,
    required SortType sortType,
    required BooksSortField sortField,
  }) = _SortBooksState;

  factory SortBooksState.initial() => const SortBooksState(
        isLoading: false,
        books: [],
        sortType: SortType.none,
        sortField: BooksSortField.none,
      );
}
