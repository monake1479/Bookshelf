enum CurrentTab { authors, books }

extension CurrentTabFactory on CurrentTab {
  static CurrentTab fromString(String value) {
    switch (value) {
      case 'authors':
        return CurrentTab.authors;
      case 'books':
        return CurrentTab.books;
      default:
        throw ArgumentError.value(value, 'value', 'Invalid value');
    }
  }
}
