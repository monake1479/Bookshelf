import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/get_authors/get_authors_notiffier.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_state.dart';
import 'package:ztp_projekt/authors/interfaces/author_interface.dart';
import 'package:ztp_projekt/common/utils/either_extension.dart';

class ManageAuthorsNotifier extends StateNotifier<ManageAuthorsState> {
  ManageAuthorsNotifier(
    this._getAuthorsNotifier,
    this._interface,
  ) : super(ManageAuthorsState.initial());

  final GetAuthorsNotifier _getAuthorsNotifier;
  final AuthorInterface _interface;

  Future<void> insert(Map<String, Object?> values) async {
    log('[ManageAuthorsNotifier] insert()');
    state = state.copyWith(isLoading: true);
    final response = await _interface.insert(values);
    if (response.isRight()) {
      await _getAuthorsNotifier.get(response.getRightOrThrow());
      if (_getAuthorsNotifier.state.exception != null) {
        state = state.copyWith(
          isLoading: false,
          failureOrSuccessOption: some(
            left(_getAuthorsNotifier.state.exception!),
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
      await _getAuthorsNotifier.get(id);
      if (_getAuthorsNotifier.state.exception != null) {
        state = state.copyWith(
          isLoading: false,
          failureOrSuccessOption: some(
            left(_getAuthorsNotifier.state.exception!),
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

  Future<void> delete(int id) async {
    state = state.copyWith(isLoading: true);
    final response = await _interface.delete(id);
    if (response.isRight()) {
      await _getAuthorsNotifier.get(id);
      if (_getAuthorsNotifier.state.exception != null) {
        state = state.copyWith(
          isLoading: false,
          failureOrSuccessOption: some(
            left(_getAuthorsNotifier.state.exception!),
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
