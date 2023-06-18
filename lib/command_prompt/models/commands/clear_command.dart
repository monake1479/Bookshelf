import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';
import 'package:ztp_projekt/command_prompt/providers.dart';

class ClearCommand implements Command {
  @override
  String get command => 'clear';

  @override
  String get description => 'Clears the command prompt history';

  @override
  Future<String?> execute(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) async {
    ref.read(commandPromptHistoryTextControllerProvider).text = '';
    return 'Cleared.';
  }

  @override
  String printUsage() {
    final List<String> usage = [
      'Usage: /clear',
      'Clears the command prompt history',
    ];
    return usage.join('\n');
  }

  @override
  CommandValidationError? validate(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) {
    if (args.isNotEmpty) {
      return CommandValidationError(
        command: command,
        message: 'Command does not take any arguments',
      );
    }
    return null;
  }
}
