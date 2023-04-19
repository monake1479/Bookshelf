import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/books/utils/date_time_converter.dart';
part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required int id,
    required int authorId,
    required String authorName,
    required String title,
    required String publisher,
    @DateTimeConverter() required DateTime publicationDate,
    required String isbnNumber,
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
