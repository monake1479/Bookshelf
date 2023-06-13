import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/form/authors_form_state.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_notifier.dart';
import 'package:ztp_projekt/authors/models/author.dart';

class AuthorsFormNotifier extends StateNotifier<AuthorsFormState> {
  AuthorsFormNotifier(this._manageAuthorsNotifier)
      : super(AuthorsFormState.initial());

  final ManageAuthorsNotifier _manageAuthorsNotifier;

  void reset() {
    state = AuthorsFormState.initial();
  }

  Future<void> update() async {
    state = state.copyWith(isLoading: true);
    await _manageAuthorsNotifier.update(state.toAuthor.toMap, state.id!);
    state = AuthorsFormState.initial();
  }

  Future<void> insert() async {
    state = state.copyWith(isLoading: true);
    await _manageAuthorsNotifier.insert(state.toInsertMap);
    state = AuthorsFormState.initial();
  }

  void setInitialAuthor(Author author) {
    state = state.copyWith(
      id: author.id,
      firstName: author.firstName,
      lastName: author.lastName,
    );
  }

  void updateFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }
}
