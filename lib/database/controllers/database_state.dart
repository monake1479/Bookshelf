import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

part 'database_state.freezed.dart';

@freezed
class DatabaseState with _$DatabaseState {
  const factory DatabaseState({
    required bool isLoading,
    required List<String> databaseList,
    required bool isDatabaseOpened,
    required Option<Either<BookshelfException, Unit>> failureOrSuccessOption,
  }) = _DatabaseState;
  factory DatabaseState.initial() => DatabaseState(
        isLoading: false,
        isDatabaseOpened: false,
        databaseList: [],
        failureOrSuccessOption: none(),
      );
}

extension DatabaseStateEx on DatabaseState {
  bool get isException => failureOrSuccessOption.fold(
        () => false,
        (a) => a.fold((l) => true, (r) => false),
      );
  BookshelfException? get getException => failureOrSuccessOption.fold(
        () => null,
        (a) => a.fold((l) => l, (r) => null),
      );
  List<String> get databasesNames {
    final List<String> names = [];
    for (var file in databaseList) {
      file = file.replaceAll(RegExp('.db'), '');
      final index = file.lastIndexOf('\\');
      names.add(
        file
            .substring(index + 1, file.length)
            .replaceRange(0, 1, file[index + 1].toUpperCase()),
      );
    }
    return names;
  }
}
