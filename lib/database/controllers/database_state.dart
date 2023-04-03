import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

part 'database_state.freezed.dart';

@freezed
class DatabaseState with _$DatabaseState {
  const factory DatabaseState({
    required bool isLoading,
    required Option<Either<BookshelfException, Unit>> failureOrSuccessOption,
  }) = _DatabaseState;
  factory DatabaseState.initial() =>
      DatabaseState(isLoading: false, failureOrSuccessOption: none());
}
