import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

part 'manage_authors_state.freezed.dart';

@freezed
class ManageAuthorsState with _$ManageAuthorsState {
  const factory ManageAuthorsState({
    required bool isLoading,
    required Option<Either<BookshelfException, Unit>> failureOrSuccessOption,
  }) = _ManageAuthorsState;

  factory ManageAuthorsState.initial() => ManageAuthorsState(
        isLoading: false,
        failureOrSuccessOption: none(),
      );
}

extension ManageAuthorsStateEx on ManageAuthorsState {
  bool get isException => failureOrSuccessOption.fold(
        () => false,
        (a) => a.fold((l) => true, (r) => false),
      );

  BookshelfException? get getException => failureOrSuccessOption.fold(
        () => null,
        (a) => a.fold((l) => l, (r) => null),
      );
}
