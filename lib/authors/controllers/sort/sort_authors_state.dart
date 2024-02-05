import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/authors/models/author_sort_field.dart';
import 'package:ztp_projekt/explorer/models/sort_type_enum.dart';

part 'sort_authors_state.freezed.dart';

@freezed
class SortAuthorsState with _$SortAuthorsState {
  const factory SortAuthorsState({
    required bool isLoading,
    required List<Author> authors,
    required SortType sortType,
    required AuthorSortField sortField,
  }) = _SortAuthorsState;

  factory SortAuthorsState.initial() => const SortAuthorsState(
        isLoading: false,
        authors: [],
        sortType: SortType.none,
        sortField: AuthorSortField.none,
      );
}
