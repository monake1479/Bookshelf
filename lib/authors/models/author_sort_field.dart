import 'package:ztp_projekt/explorer/models/sort_field.dart';

enum AuthorSortField {
  name,
  lastName,
  none,
}

extension AuthorSortFieldX on AuthorSortField {
  static AuthorSortField fromSortField(SortField field) {
    switch (field) {
      case SortField.authorFirstName:
        return AuthorSortField.name;
      case SortField.authorLastName:
        return AuthorSortField.lastName;
      case SortField.bookTitle:
      case SortField.bookPublicationDate:
      case SortField.bookPrice:
        return AuthorSortField.none;
    }
  }
}
