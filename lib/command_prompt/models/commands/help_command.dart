import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';

class HelpCommand implements Command {
  @override
  String get command => 'help';

  @override
  String get description => 'Displays list of available commands or help for '
      'specific command';

  @override
  Future<String?> execute(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) async {
    if (args.isEmpty) {
      final List<String> lines = [
        'Available commands:',
        ...availableCommands.map((e) => '/${e.command} - ${e.description}'),
      ];
      return lines.join('\n');
    } else {
      final foundCommand = availableCommands.firstWhereOrNull(
        (element) => element.command == args[0].toLowerCase(),
      );
      if (foundCommand != null) {
        return foundCommand.printUsage();
      }
    }
    return Future.value();
  }

  @override
  String printUsage() {
    const List<String> lines = [
      'Usage: /help [command]',
      'Displays list of available commands or help for specific command',
      'if command is specified, displays usage of that command'
    ];
    return lines.join('\n');
  }

  @override
  CommandValidationError? validate(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) {
    if (args.length > 1) {
      return CommandValidationError(
        command: command,
        message: 'Invalid number of arguments. Expected 1, got ${args.length}',
      );
    }
    if (args.isNotEmpty) {
      final foundCommand = availableCommands.firstWhereOrNull(
        (element) => element.command == args[0],
      );
      if (foundCommand == null) {
        return CommandValidationError(
          command: command,
          message: 'Command ${args[0]} not found',
        );
      }
    }
    return null;
  }
}
