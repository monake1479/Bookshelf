import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/books/controllers/get_books/get_books_notifier.dart';
import 'package:ztp_projekt/books/controllers/get_books/get_books_state.dart';
import 'package:ztp_projekt/books/controllers/manage_books/manage_books_state.dart';
import 'package:ztp_projekt/books/interfaces/book_interface.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';
import 'package:ztp_projekt/common/utils/either_extension.dart';

class ManageBooksNotifier extends StateNotifier<ManageBooksState> {
  ManageBooksNotifier(
    this._getBooksNotifier,
    this._interface,
  ) : super(ManageBooksState.initial());

  final GetBooksNotifier _getBooksNotifier;
  final BookInterface _interface;

  void reset() {
    state = ManageBooksState.initial();
    _getBooksNotifier.reset();
  }

  Future<void> getAll() async {
    state = state.copyWith(isLoading: true);
    await _getBooksNotifier.getAll();
    if (_getBooksNotifier.state.isException) {
      state = state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(
          left(_getBooksNotifier.state.exception!),
        ),
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(right(unit)),
      );
    }
  }

  Future<void> insert(Map<String, Object?> values) async {
    state = state.copyWith(isLoading: true);
    final response = await _interface.insert(values);
    if (response.isRight()) {
      await _getBooksNotifier.get(response.getRightOrThrow());
      if (_getBooksNotifier.state.exception != null) {
        state = state.copyWith(
          isLoading: false,
          failureOrSuccessOption: some(
            left(_getBooksNotifier.state.exception!),
          ),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          failureOrSuccessOption: some(right(unit)),
        );
      }
    } else {
      state = state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(response.getLeftOrThrow())),
      );
    }
  }

  Future<void> update(
    Map<String, Object?> values,
    int id,
  ) async {
    state = state.copyWith(isLoading: true);
    final response = await _interface.update(values, id);
    if (response.isRight()) {
      await _getBooksNotifier.get(id);
      if (_getBooksNotifier.state.exception != null) {
        state = state.copyWith(
          isLoading: false,
          failureOrSuccessOption: some(
            left(_getBooksNotifier.state.exception!),
          ),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          failureOrSuccessOption: some(right(unit)),
        );
      }
    } else {
      state = state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(response.getLeftOrThrow())),
      );
    }
  }

  Future<Either<BookshelfException, Unit>> checkRelation(int authorId) async {
    state = state.copyWith(isLoading: true);
    final response = await _interface.findRelation(authorId);
    if (response.isRight()) {
      state = state.copyWith(
        isLoading: false,
      );
      return right(unit);
    } else {
      state = state.copyWith(
        isLoading: false,
      );
      return left(response.getLeftOrThrow());
    }
  }

  Future<void> delete(int id) async {
    state = state.copyWith(isLoading: true);
    final response = await _interface.delete(id);
    if (response.isRight()) {
      await _getBooksNotifier.getAll();
      if (_getBooksNotifier.state.exception != null) {
        state = state.copyWith(
          isLoading: false,
          failureOrSuccessOption: some(
            left(_getBooksNotifier.state.exception!),
          ),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          failureOrSuccessOption: some(right(unit)),
        );
      }
    } else {
      state = state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(response.getLeftOrThrow())),
      );
    }
  }
}
