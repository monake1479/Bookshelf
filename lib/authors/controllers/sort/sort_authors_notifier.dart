import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/sort/sort_authors_state.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/authors/models/author_sort_field.dart';
import 'package:ztp_projekt/explorer/models/sort_type_enum.dart';

class SortAuthorsNotifier extends StateNotifier<SortAuthorsState> {
  SortAuthorsNotifier() : super(SortAuthorsState.initial());

  void resetSortingCriteria() {
    state = state.copyWith(
      sortType: SortType.none,
      sortField: AuthorSortField.none,
    );
    _sort();
  }

  List<Author> _rawAuthorList = [];

  set authorList(List<Author> authorList) {
    _rawAuthorList = authorList;
    _sort();
  }

  void setSort(SortType sortType, AuthorSortField sortField) {
    state = state.copyWith(
      sortType: sortType,
      sortField: sortField,
    );
    _sort();
  }

  void _sort() {
    if (state.sortType == SortType.none) {
      state = state.copyWith(
        authors: _rawAuthorList,
      );
    } else {
      List<Author> tempList = List<Author>.from(_rawAuthorList);
      switch (state.sortField) {
        case AuthorSortField.name:
          tempList.sort((a, b) => a.firstName.compareTo(b.firstName));
          break;
        case AuthorSortField.lastName:
          tempList.sort((a, b) => a.lastName.compareTo(b.lastName));
          break;
        case AuthorSortField.none:
          break;
      }
      if (state.sortType == SortType.descending) {
        tempList = tempList.reversed.toList();
      }
      state = state.copyWith(
        authors: tempList,
      );
    }
  }
}
