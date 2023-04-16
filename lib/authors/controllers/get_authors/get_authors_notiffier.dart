import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/get_authors/get_authors_state.dart';
import 'package:ztp_projekt/authors/interfaces/author_interface.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/common/utils/either_extension.dart';

class GetAuthorsNotifier extends StateNotifier<GetAuthorsState> {
  GetAuthorsNotifier(this._interface) : super(GetAuthorsState.initial());
  final AuthorInterface _interface;
  void reset() {
    state = GetAuthorsState.initial();
  }

  Future<void> getAll() async {
    state = state.copyWith(isLoading: true);
    final response = await _interface.getAll();
    if (response.isRight()) {
      state = state.copyWith(
        isLoading: false,
        authors: response.getRightOrThrow(),
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
      final List<Author> tempList = List<Author>.from(state.authors);
      final int authorIndex =
          tempList.indexWhere((element) => element.id == id);
      tempList.removeWhere((element) => element.id == id);
      tempList.insert(authorIndex, response.getRightOrThrow());
      state = state.copyWith(
        isLoading: false,
        authors: tempList,
        exception: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        exception: response.getLeftOrThrow(),
      );
    }
  }

  void delete(int id) {
    state = state.copyWith(isLoading: true);
    final tempList = List<Author>.from(state.authors);
    final authorById = tempList.firstWhere((element) => element.id == id);
    tempList.remove(authorById);
    state = state.copyWith(isLoading: false, authors: tempList);
  }
}
