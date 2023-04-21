import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_notifier.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/books/controllers/form/book_form_state.dart';
import 'package:ztp_projekt/books/controllers/manage_books/manage_books_notifier.dart';
import 'package:ztp_projekt/books/models/book.dart';

class BookFormNotifier extends StateNotifier<BookFormState> {
  BookFormNotifier(
    this._manageBooksNotifier,
    this._manageAuthorsNotifier,
  ) : super(BookFormState.initial());
  final ManageBooksNotifier _manageBooksNotifier;
  final ManageAuthorsNotifier _manageAuthorsNotifier;
  void reset() {
    state = BookFormState.initial();
  }

  Future<void> setInitialBook(Book book) async {
    state = state.copyWith(
      isLoading: true,
      id: book.id,
      title: book.title,
      publisher: book.publisher,
      publicationDate: book.publicationDate,
      isbnNumber: book.isbnNumber,
      price: book.price,
    );
    await _setAuthor(book.authorId);
  }

  Future<void> _setAuthor(int id) async {
    final author = await _manageAuthorsNotifier.get(id);
    if (author != null) {
      state = state.copyWith(
        isLoading: false,
        author: author,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        author: null,
      );
    }
  }

  Future<void> updateBook() async {
    state = state.copyWith(isLoading: true);
    await _manageBooksNotifier.update(state.toBook.toMap, state.id!);
    state = BookFormState.initial();
  }

  void updateAuthor(Author author) {
    state = state.copyWith(author: author);
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updatePublisher(String publisher) {
    state = state.copyWith(publisher: publisher);
  }

  void updatePublicationDate(DateTime publicationDate) {
    state = state.copyWith(publicationDate: publicationDate);
  }

  void updateIsbnNumber(String isbnNumber) {
    state = state.copyWith(isbnNumber: isbnNumber);
  }

  void updatePrice(double? price) {
    state = state.copyWith(price: price);
  }
}
