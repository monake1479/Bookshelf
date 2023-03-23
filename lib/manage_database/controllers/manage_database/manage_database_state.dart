import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'manage_database_state.freezed.dart';

@freezed
class ManageDatabaseState with _$ManageDatabaseState {
  const factory ManageDatabaseState({
    required bool isLoading,
    required Option<Either<Exception, Unit>> failureOrSuccessOption,
  }) = _ManageDatabaseState;
  factory ManageDatabaseState.initial() =>
      ManageDatabaseState(isLoading: false, failureOrSuccessOption: none());
}
