import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';
import 'package:ztp_projekt/command_prompt/providers.dart';
import 'package:ztp_projekt/explorer/models/current_tab_enum.dart';
import 'package:ztp_projekt/explorer/providers.dart';

final _tables = ['authors', 'books'];

class ShowCommand implements Command {
  @override
  String get command => 'show';

  @override
  String get description =>
      'Switches the current tab between the authors and books';

  @override
  Future<String?> execute(
    List<String> args,
    Ref<Object?> ref,
    List<Command> availableCommands,
  ) async {
    final tabToSwitchTo = CurrentTabFactory.fromString(args[0].toLowerCase());
    ref.read(recordsStreamControllerProvider).add(tabToSwitchTo);
    ref
        .read(commandPromptStreamControllerProvider)
        .add('\nSwitched to ${tabToSwitchTo.name} tab');
    return null;
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
        message: 'Command takes one argument',
      );
    }
    if (!_tables.contains(args[0])) {
      return CommandValidationError(
        command: command,
        message: 'Invalid argument',
      );
    }
    return null;
  }

  @override
  String printUsage() {
    final List<String> usage = [
      'Usage: switch <table>',
      'Switches the current tab between the authors and books',
      'Available tables: ${_tables.join(', ')}',
    ];
    return usage.join('\n');
  }
}
