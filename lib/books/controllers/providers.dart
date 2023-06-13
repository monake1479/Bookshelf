import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/books/controllers/form/book_form_notifier.dart';
import 'package:ztp_projekt/books/controllers/form/book_form_state.dart';
import 'package:ztp_projekt/books/controllers/get_books/get_books_notifier.dart';
import 'package:ztp_projekt/books/controllers/get_books/get_books_state.dart';
import 'package:ztp_projekt/books/controllers/manage_books/manage_books_notifier.dart';
import 'package:ztp_projekt/books/controllers/manage_books/manage_books_state.dart';
import 'package:ztp_projekt/books/repositories/book_repository.dart';
import 'package:ztp_projekt/database/controllers/providers.dart';

final _bookRepository = Provider(
  (ref) => BookRepository(
    ref.watch(sqliteDatabaseRepositoryProvider),
  ),
);

final getBooksNotifierProvider =
    StateNotifierProvider<GetBooksNotifier, GetBooksState>(
  (ref) => GetBooksNotifier(
    ref.watch(_bookRepository),
  ),
);

final manageBooksNotifierProvider =
    StateNotifierProvider<ManageBooksNotifier, ManageBooksState>(
  (ref) => ManageBooksNotifier(
    ref.watch(getBooksNotifierProvider.notifier),
    ref.watch(_bookRepository),
  ),
);

final bookFormNotifierProvider =
    StateNotifierProvider<BookFormNotifier, BookFormState>(
  (ref) => BookFormNotifier(
    ref.watch(manageBooksNotifierProvider.notifier),
    ref.watch(manageAuthorsNotifierProvider.notifier),
  ),
);
