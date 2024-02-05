import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';
import 'package:ztp_projekt/command_prompt/providers.dart';

final _tables = ['book', 'author'];

class AddCommand implements Command {
  @override
  String get command => 'add';

  @override
  String get description => 'Adds a new book or author to the database';

  @override
  Future<void> execute(
    List<String> args,
    Ref<Object?> ref,
    List<Command> availableCommands,
  ) async {
    if (args[0] == _tables[0]) {
      ref.read(bookFormNotifierProvider.notifier).reset();
      await ref.read(bookFormNotifierProvider.notifier).updateForm(
            title: args[1],
            authorId: int.parse(args[2]),
            publisher: args[3],
            publicationDate: DateTime.parse(args[4]),
            isbnNumber: args[5],
            price: double.parse(args[6]),
          );
      ref.read(commandPromptStreamControllerProvider).add('\nBook added');
      await ref.read(bookFormNotifierProvider.notifier).insert();
    } else {
      ref.read(authorFormNotifierProvider.notifier).reset();
      ref.read(authorFormNotifierProvider.notifier).updateForm(
            firstName: args[1],
            lastName: args[2],
          );
      ref.read(commandPromptStreamControllerProvider).add('\nAuthor added');
      await ref.read(authorFormNotifierProvider.notifier).insert();
    }
    return;
  }

  @override
  CommandValidationError? validate(
    List<String> args,
    Ref<Object?> ref,
    List<Command> availableCommands,
  ) {
    if (args.isEmpty) {
      return CommandValidationError(
        command: command,
        message: 'No table specified. Use "help add" for more information',
      );
    }
    if (!_tables.contains(args[0])) {
      return CommandValidationError(
        command: command,
        message: 'Invalid table name. Use "help add" for more information',
      );
    }
    if (args[0] == _tables[1]) {
      if (args.length != 3) {
        return CommandValidationError(
          command: command,
          message:
              'Invalid number of arguments. Use "help add" for more information',
        );
      }
    } else if (args[0] == _tables[0]) {
      if (args.length != 7) {
        return CommandValidationError(
          command: command,
          message:
              'Invalid number of arguments. Use "help add" for more information',
        );
      }
      //check if authorId is valid
      try {
        int.parse(args[2]);
      } catch (e) {
        return CommandValidationError(
          command: command,
          message: 'Invalid authorId. Use "help add" for more information',
        );
      }
      final authorId = int.parse(args[2]);
      final author = ref
          .read(getAuthorsNotifierProvider)
          .authors
          .firstWhereOrNull((element) => element.id == authorId);
      if (author == null) {
        return CommandValidationError(
          command: command,
          message: 'Author with id $authorId does not exist',
        );
      }
      //check if price is valid
      try {
        double.parse(args[6]);
      } catch (e) {
        return CommandValidationError(
          command: command,
          message: 'Invalid price. Use "help add" for more information',
        );
      }
      //check if date can be parsed
      try {
        DateTime.parse(args[4]);
      } catch (e) {
        return CommandValidationError(
          command: command,
          message:
              'Invalid date format. Format your date as "YYYY-DD-MM" Use "help add" for more information',
        );
      }
    }
    return null;
  }

  @override
  String printUsage() {
    final List<String> usage = [
      'Usage: add <table> <arguments>',
      'Available tables: ${_tables.join(', ')}',
      'Available arguments:',
      'authors: <firstName> <lastName>',
      'books: <title> <authorId> <publisher> <publicationDate> <isbnNumber> <price>',
    ];
    return usage.join('\n');
  }
}
