import 'package:freezed_annotation/freezed_annotation.dart';
part 'author.freezed.dart';
part 'author.g.dart';

@freezed
class Author with _$Author {
  const factory Author({
    required int id,
    required String firstName,
    required String lastName,
  }) = _Author;
  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}

extension AuthorEx on Author {
  Map<String, dynamic> get toMap => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
      };

  Author toAuthor(Map<String, Object?> authorMap) {
    return Author(
      id: authorMap['id'] as int,
      firstName: authorMap['firstName'] as String,
      lastName: authorMap['lastName'] as String,
    );
  }
}
