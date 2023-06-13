import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/form/authors_form_notifier.dart';
import 'package:ztp_projekt/authors/controllers/form/authors_form_state.dart';
import 'package:ztp_projekt/authors/controllers/get_authors/get_authors_notifier.dart';
import 'package:ztp_projekt/authors/controllers/get_authors/get_authors_state.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_notifier.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_state.dart';
import 'package:ztp_projekt/authors/repositories/author_repository.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/database/controllers/providers.dart';

final _authorRepository = Provider(
  (ref) => AuthorRepository(
    ref.watch(sqliteDatabaseRepositoryProvider),
  ),
);

final getAuthorsNotifierProvider =
    StateNotifierProvider<GetAuthorsNotifier, GetAuthorsState>(
  (ref) => GetAuthorsNotifier(
    ref.watch(_authorRepository),
  ),
);

final manageAuthorsNotifierProvider =
    StateNotifierProvider<ManageAuthorsNotifier, ManageAuthorsState>(
  (ref) => ManageAuthorsNotifier(
    ref.watch(getAuthorsNotifierProvider.notifier),
    ref.watch(_authorRepository),
    ref.watch(manageBooksNotifierProvider.notifier),
  ),
);

final authorFormNotifierProvider =
    StateNotifierProvider<AuthorsFormNotifier, AuthorsFormState>(
  (ref) => AuthorsFormNotifier(
    ref.watch(manageAuthorsNotifierProvider.notifier),
  ),
);
