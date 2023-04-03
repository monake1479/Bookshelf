import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/get_authors/get_authors_notiffier.dart';
import 'package:ztp_projekt/authors/controllers/get_authors/get_authors_state.dart';
import 'package:ztp_projekt/authors/repositories/author_repository.dart';
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
