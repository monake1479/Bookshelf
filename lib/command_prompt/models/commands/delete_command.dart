import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';
import 'package:ztp_projekt/command_prompt/providers.dart';

const _tables = [
  'book',
  'author',
];

class DeleteCommand implements Command {
  @override
  String get command => 'delete';

  @override
  String get description => 'Deletes a record from the database';

  @override
  Future<void> execute(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) async {
    final table = args[0].toLowerCase();
    final id = int.parse(args[1].toLowerCase());
    if (table == _tables[0]) {
      ref
          .read(commandPromptStreamControllerProvider)
          .add('\nRecord deleted successfully');
      await ref.read(manageBooksNotifierProvider.notifier).delete(id);
    }
    if (table == _tables[1]) {
      ref
          .read(commandPromptStreamControllerProvider)
          .add('\nRecord deleted successfully');
      await ref.read(manageAuthorsNotifierProvider.notifier).delete(id);
    }
  }

  @override
  CommandValidationError? validate(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) {
    if (args.length != 2) {
      return CommandValidationError(
        message: 'Invalid number of arguments',
        command: command,
      );
    }
    final table = args[0].toLowerCase();
    final id = args[1].toLowerCase();
    if (!_tables.contains(table)) {
      return CommandValidationError(
        message: 'Invalid table name',
        command: command,
      );
    }
    if (int.tryParse(id) == null) {
      return CommandValidationError(
        message: 'Invalid ID',
        command: command,
      );
    }
    final parsedId = int.parse(id);
    if (table == _tables[0]) {
      final books = ref.watch(getBooksNotifierProvider).books;
      final book = books.firstWhereOrNull((book) => book.id == parsedId);
      if (book == null) {
        return CommandValidationError(
          message: 'Book with ID $parsedId does not exist',
          command: command,
        );
      }
    }
    if (table == _tables[1]) {
      final authors = ref.watch(getAuthorsNotifierProvider).authors;
      final author =
          authors.firstWhereOrNull((author) => author.id == parsedId);
      if (author == null) {
        return CommandValidationError(
          message: 'Author with ID $parsedId does not exist',
          command: command,
        );
      }
      //check if author does not have any books
      final books = ref.watch(getBooksNotifierProvider).books;
      final booksByAuthor = books.where((book) => book.authorId == parsedId);
      if (booksByAuthor.isNotEmpty) {
        return CommandValidationError(
          message:
              'Author with ID $parsedId has books assigned to him, delete them first',
          command: command,
        );
      }
    }
    return null;
  }

  @override
  String printUsage() {
    final List<String> usage = [
      'Usage: delete <table> <id>',
      'Available tables: ${_tables.join(', ')}',
    ];
    return usage.join('\n');
  }
}
