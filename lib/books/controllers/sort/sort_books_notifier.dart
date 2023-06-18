import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/books/controllers/sort/sort_books_state.dart';
import 'package:ztp_projekt/books/models/book.dart';
import 'package:ztp_projekt/books/models/books_sort_field.dart';
import 'package:ztp_projekt/explorer/models/sort_type_enum.dart';

class SortBooksNotifier extends StateNotifier<SortBooksState> {
  SortBooksNotifier() : super(SortBooksState.initial());

  void resetSortingCriteria() {
    state = state.copyWith(
      sortType: SortType.none,
      sortField: BooksSortField.none,
    );
    _sort();
  }

  List<Book> _rawBooksList = [];

  set bookList(List<Book> bookList) {
    _rawBooksList = bookList;
    _sort();
  }

  void setSort(SortType sortType, BooksSortField sortField) {
    state = state.copyWith(
      sortType: sortType,
      sortField: sortField,
    );
    _sort();
  }

  void _sort() {
    if (state.sortType == SortType.none) {
      state = state.copyWith(
        books: _rawBooksList,
      );
    } else {
      List<Book> tempList = List<Book>.from(_rawBooksList);
      switch (state.sortField) {
        case BooksSortField.title:
          tempList.sort((a, b) => a.title.compareTo(b.title));
          break;
        case BooksSortField.publicationDate:
          tempList
              .sort((a, b) => a.publicationDate.compareTo(b.publicationDate));
          break;
        case BooksSortField.price:
          tempList.sort((a, b) => a.price.compareTo(b.price));
          break;
        case BooksSortField.none:
          break;
      }
      if (state.sortType == SortType.descending) {
        tempList = tempList.reversed.toList();
      }
      state = state.copyWith(
        books: tempList,
      );
    }
  }
}
