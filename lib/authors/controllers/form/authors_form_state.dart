import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/books/utils/date_time_converter.dart';

part 'authors_form_state.freezed.dart';

@freezed
class AuthorsFormState with _$AuthorsFormState {
  const factory AuthorsFormState({
    required bool isLoading,
    required int? id,
    required String? firstName,
    required String? lastName,
  }) = _AuthorsFormState;
  factory AuthorsFormState.initial() => const AuthorsFormState(
        isLoading: false,
        id: null,
        firstName: null,
        lastName: null,
      );
}

extension AuthorsFormStateEx on AuthorsFormState {
  bool get isFirstNameValid => firstName != null && firstName!.isNotEmpty;
  bool get isLastNameValid => lastName != null && lastName!.isNotEmpty;
  Author get toAuthor => Author(
        id: id!,
        firstName: firstName!,
        lastName: lastName!,
      );
}
