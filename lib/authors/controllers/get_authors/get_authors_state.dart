import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

part 'get_authors_state.freezed.dart';

@freezed
class GetAuthorsState with _$GetAuthorsState {
  const factory GetAuthorsState({
    required bool isLoading,
    required List<Author> authors,
    required BookshelfException? exception,
  }) = _GetAuthorsState;
  factory GetAuthorsState.initial() => const GetAuthorsState(
        isLoading: false,
        authors: [],
        exception: null,
      );
}

extension GetAuthorsStateEx on GetAuthorsState {
  bool get isException => exception != null;
}
