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
  String get fullName => '$firstName $lastName';

  Map<String, dynamic> get toMap => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
      };
}
