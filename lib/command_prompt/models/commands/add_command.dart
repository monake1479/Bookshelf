import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';

final _tables = ['books', 'authors'];

class AddCommand implements Command {
  @override
  String get command => 'add';

  @override
  String get description => 'Adds a new book or author to the database';

  @override
  Future<String?> execute(
    List<String> args,
    Ref<Object?> ref,
    List<Command> availableCommands,
  ) {
    throw UnimplementedError();
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
        message: 'No table specified. Use "/help add" for more information',
      );
    }
    if (!_tables.contains(args[0])) {
      return CommandValidationError(
        command: command,
        message: 'Invalid table name. Use "/help add" for more information',
      );
    }
    if (args[0] == 'authors') {
      if (args.length != 3) {
        return CommandValidationError(
          command: command,
          message:
              'Invalid number of arguments. Use "/help add" for more information',
        );
      }
    } else if (args[0] == 'books') {
      if (args.length != 7) {
        return CommandValidationError(
          command: command,
          message:
              'Invalid number of arguments. Use "/help add" for more information',
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
