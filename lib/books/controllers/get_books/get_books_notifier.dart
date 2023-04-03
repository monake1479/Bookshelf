import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/books/controllers/get_books/get_books_state.dart';
import 'package:ztp_projekt/books/interfaces/book_interface.dart';
import 'package:ztp_projekt/books/models/book.dart';
import 'package:ztp_projekt/common/utils/either_extension.dart';

class GetBooksNotifier extends StateNotifier<GetBooksState> {
  GetBooksNotifier(
    this._interface,
  ) : super(GetBooksState.initial());
  final BookInterface _interface;
  void reset() {
    state = GetBooksState.initial();
  }

  Future<void> getAll() async {
    state = state.copyWith(isLoading: true);
    final response = await _interface.getAll();
    if (response.isRight()) {
      state = state.copyWith(
        isLoading: false,
        books: response.getRightOrThrow(),
        exception: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        exception: response.getLeftOrThrow(),
      );
    }
  }

  Future<void> get(int id) async {
    state = state.copyWith(isLoading: true);
    final response = await _interface.get(id);
    if (response.isRight()) {
      final List<Book> tempList = List<Book>.from(state.books);
      final index = tempList.indexWhere((element) => element.id == id);
      tempList.removeWhere((element) => element.id == id);
      tempList.insert(index, response.getRightOrThrow());

      state = state.copyWith(
        isLoading: false,
        books: tempList,
        exception: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        exception: response.getLeftOrThrow(),
      );
    }
  }
}
