import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';

const _tables = [
  'books',
  'authors',
];

class DeleteCommand implements Command {
  @override
  String get command => 'delete';

  @override
  String get description => 'Deletes a record from the database';

  @override
  Future<String?> execute(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) async {
    final table = args[0].toLowerCase();
    final id = int.parse(args[1].toLowerCase());
    if (table == _tables[0]) {
      await ref.read(manageBooksNotifierProvider.notifier).delete(id);
    }
    if (table == _tables[1]) {
      await ref.read(manageAuthorsNotifierProvider.notifier).delete(id);
    }
    return null;
  }

  @override
  CommandValidationError? validate(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) {
    final table = args[0].toLowerCase();
    final id = args[1].toLowerCase();
    if (args.length != 2) {
      return CommandValidationError(
        message: 'Invalid number of arguments',
        command: command,
      );
    }
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
