import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookshelf_exception.freezed.dart';

@freezed
class BookshelfException with _$BookshelfException {
  const factory BookshelfException.databaseExist() = _DatabaseExist;
  const factory BookshelfException.databaseAlreadyOpened() =
      _DatabaseAlreadyOpened;
  const factory BookshelfException.databaseIsClosed() = _DatabaseIsClosed;
  const factory BookshelfException.insertError() = _InsertError;
  const factory BookshelfException.updateError() = _UpdateError;
  const factory BookshelfException.custom({
    @Default('Something went wrong, please try again later.') String message,
  }) = _Custom;
}

extension BookshelfExceptionEx on BookshelfException {
  String get description {
    return maybeWhen<String>(
      databaseExist: () => 'Database under this path already exist!',
      databaseAlreadyOpened: () =>
          'Database is already opened! Please, close existing before you open another one.',
      databaseIsClosed: () => 'Database is closed! Please, open it first.',
      insertError: () =>
          'We cannot insert requested values to database, please check provided table name and values amount.',
      updateError: () => 'We cannot update requested record.',
      custom: (message) => message,
      orElse: () => '',
    );
  }
}
