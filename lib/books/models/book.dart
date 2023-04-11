import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/books/utils/date_time_converter.dart';
part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required int id,
    required String authorName,
    required String title,
    required String publisher,
    @DateTimeConverter() required DateTime publicationDate,
    required String isbnNumber,
    required double price,
  }) = _Book;
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
