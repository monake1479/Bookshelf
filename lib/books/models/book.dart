import 'package:freezed_annotation/freezed_annotation.dart';
part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required int id,
    required int authorId,
    required String title,
    required String publisher,
    required DateTime publicationDate,
    required int isbnNumber,
    required double price,
  }) = _Book;
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

extension BookEx on Book {
  Map<String, dynamic> get toMap => {
        'id': id,
        'authorId': authorId,
        'title': title,
        'publisher': publisher,
        'publicationDate': publicationDate.toIso8601String(),
        'isbnNumber': isbnNumber,
        'price': price,
      };
}
