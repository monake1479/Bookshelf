import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/books/models/book.dart';
import 'package:ztp_projekt/books/utils/date_time_converter.dart';

part 'book_form_state.freezed.dart';

@freezed
class BookFormState with _$BookFormState {
  const factory BookFormState({
    required bool isLoading,
    required int? id,
    required Author? author,
    required String? title,
    required String? publisher,
    @DateTimeConverter() required DateTime? publicationDate,
    required String? isbnNumber,
    required double? price,
  }) = _BookFormState;
  factory BookFormState.initial() => const BookFormState(
        isLoading: false,
        id: null,
        author: null,
        title: null,
        publisher: null,
        publicationDate: null,
        isbnNumber: null,
        price: null,
      );
}

extension BookFormStateEx on BookFormState {
  bool get isTitleValid => title != null && title!.isNotEmpty;
  bool get isPublisherValid => publisher != null && publisher!.isNotEmpty;
  bool get isPublicationDateValid => publicationDate != null;
  bool get isIsbnNumberValid => isbnNumber != null && isbnNumber!.isNotEmpty;
  bool get isPriceValid => price != null;
  bool get isFormValid =>
      isTitleValid &&
      isPublisherValid &&
      isPublicationDateValid &&
      isIsbnNumberValid &&
      isPriceValid;
  Book get toBook => Book(
        id: id!,
        authorId: author!.id,
        authorName: author!.fullName,
        title: title!,
        publisher: publisher!,
        publicationDate: publicationDate!,
        isbnNumber: isbnNumber!,
        price: price!,
      );

  Map<String, dynamic> get toInsertMap => {
        'id': null,
        'authorId': author!.id,
        'title': title,
        'publisher': publisher,
        'publicationDate': publicationDate!.toIso8601String(),
        'isbnNumber': isbnNumber,
        'price': price,
      };
}
