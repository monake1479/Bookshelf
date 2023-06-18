import 'package:ztp_projekt/explorer/models/sort_field.dart';

enum BooksSortField {
  title,
  publicationDate,
  price,
  none,
}

extension BooksSortFieldX on BooksSortField {
  static BooksSortField fromSortField(SortField field) {
    switch (field) {
      case SortField.bookTitle:
        return BooksSortField.title;
      case SortField.bookPublicationDate:
        return BooksSortField.publicationDate;
      case SortField.bookPrice:
        return BooksSortField.price;
      case SortField.authorFirstName:
      case SortField.authorLastName:
        return BooksSortField.none;
    }
  }
}
