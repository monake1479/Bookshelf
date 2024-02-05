import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/books/controllers/form/book_form_notifier.dart';
import 'package:ztp_projekt/books/controllers/form/book_form_state.dart';
import 'package:ztp_projekt/books/controllers/get_books/get_books_notifier.dart';
import 'package:ztp_projekt/books/controllers/get_books/get_books_state.dart';
import 'package:ztp_projekt/books/controllers/manage_books/manage_books_notifier.dart';
import 'package:ztp_projekt/books/controllers/manage_books/manage_books_state.dart';
import 'package:ztp_projekt/books/controllers/sort/sort_books_notifier.dart';
import 'package:ztp_projekt/books/controllers/sort/sort_books_state.dart';
import 'package:ztp_projekt/books/repositories/book_repository.dart';
import 'package:ztp_projekt/database/controllers/providers.dart';

final _bookRepository = Provider(
  (ref) => BookRepository(
    ref.watch(sqliteDatabaseRepositoryProvider),
  ),
  name: 'BookRepositoryProvider',
);

final getBooksNotifierProvider =
    StateNotifierProvider<GetBooksNotifier, GetBooksState>(
  (ref) => GetBooksNotifier(
    ref.watch(_bookRepository),
  ),
  name: 'GetBooksNotifierProvider',
);

final manageBooksNotifierProvider =
    StateNotifierProvider<ManageBooksNotifier, ManageBooksState>(
  (ref) => ManageBooksNotifier(
    ref.read(getBooksNotifierProvider.notifier),
    ref.read(_bookRepository),
  ),
  name: 'ManageBooksNotifierProvider',
);

final bookFormNotifierProvider =
    StateNotifierProvider<BookFormNotifier, BookFormState>(
  (ref) => BookFormNotifier(
    ref.read(manageBooksNotifierProvider.notifier),
    ref.read(manageAuthorsNotifierProvider.notifier),
  ),
  name: 'BookFormNotifierProvider',
);

final sortBooksNotifierProvider =
    StateNotifierProvider<SortBooksNotifier, SortBooksState>(
  (ref) {
    final notifier = SortBooksNotifier();
    ref.listen(
      getBooksNotifierProvider,
      (previous, next) {
        notifier.bookList = next.books;
      },
      fireImmediately: true,
    );
    return notifier;
  },
  name: 'SortBooksNotifierProvider',
);
