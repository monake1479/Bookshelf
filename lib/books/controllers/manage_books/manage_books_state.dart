import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

part 'manage_books_state.freezed.dart';

@freezed
class ManageBooksState with _$ManageBooksState {
  const factory ManageBooksState({
    required bool isLoading,
    required Option<Either<BookshelfException, Unit>> failureOrSuccessOption,
  }) = _ManageBooksState;
  factory ManageBooksState.initial() => ManageBooksState(
        isLoading: false,
        failureOrSuccessOption: none(),
      );
}

extension ManageBooksStateEx on ManageBooksState {
  bool get isException => failureOrSuccessOption.fold(
        () => false,
        (a) => a.fold((l) => true, (r) => false),
      );

  BookshelfException? get getException => failureOrSuccessOption.fold(
        () => null,
        (a) => a.fold((l) => l, (r) => null),
      );
}
