import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/form/authors_form_notifier.dart';
import 'package:ztp_projekt/authors/controllers/form/authors_form_state.dart';
import 'package:ztp_projekt/authors/controllers/get_authors/get_authors_notifier.dart';
import 'package:ztp_projekt/authors/controllers/get_authors/get_authors_state.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_notifier.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_state.dart';
import 'package:ztp_projekt/authors/controllers/sort/sort_authors_notifier.dart';
import 'package:ztp_projekt/authors/controllers/sort/sort_authors_state.dart';
import 'package:ztp_projekt/authors/repositories/author_repository.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/database/controllers/providers.dart';

final _authorRepository = Provider(
  (ref) => AuthorRepository(
    ref.read(sqliteDatabaseRepositoryProvider),
  ),
  name: 'AuthorRepositoryProvider',
);

final getAuthorsNotifierProvider =
    StateNotifierProvider<GetAuthorsNotifier, GetAuthorsState>(
  (ref) => GetAuthorsNotifier(
    ref.read(_authorRepository),
  ),
  name: 'GetAuthorsNotifierProvider',
);

final manageAuthorsNotifierProvider =
    StateNotifierProvider<ManageAuthorsNotifier, ManageAuthorsState>(
  (ref) => ManageAuthorsNotifier(
    ref.read(getAuthorsNotifierProvider.notifier),
    ref.read(_authorRepository),
    ref.read(manageBooksNotifierProvider.notifier),
  ),
  name: 'ManageAuthorsNotifierProvider',
);

final authorFormNotifierProvider =
    StateNotifierProvider<AuthorsFormNotifier, AuthorsFormState>(
  (ref) => AuthorsFormNotifier(
    ref.read(manageAuthorsNotifierProvider.notifier),
  ),
  name: 'AuthorsFormNotifierProvider',
);

final sortAuthorsNotifierProvider =
    StateNotifierProvider<SortAuthorsNotifier, SortAuthorsState>(
  (ref) {
    final sortAuthorsNotifier = SortAuthorsNotifier();
    ref.listen(
      getAuthorsNotifierProvider,
      (previous, next) {
        sortAuthorsNotifier.authorList = next.authors;
      },
      fireImmediately: true,
    );
    return sortAuthorsNotifier;
  },
  name: 'SortAuthorsNotifierProvider',
);
