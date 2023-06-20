import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/add_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/clear_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/delete_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/edit_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/help_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/show_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/sort_command.dart';
import 'package:ztp_projekt/command_prompt/providers.dart';

class CommandPromptController {
  CommandPromptController(this.ref);

  final List<Command> _commands = [
    HelpCommand(),
    ShowCommand(),
    AddCommand(),
    EditCommand(),
    DeleteCommand(),
    SortCommand(),
    ClearCommand(),
  ];

  final Ref ref;

  Future<void> onCommand(String command) async {
    String newMessage = '\n> $command';
    //tokenize command
    final tokens = _tokenizeCommand(command);
    log(tokens.toString());
    final commandName = tokens[0];
    final commandArgs = tokens.sublist(1);
    //try to find command in registered commands
    final commandToExecute =
        _commands.firstWhereOrNull((element) => element.command == commandName);
    //if not found, return error
    if (commandToExecute == null) {
      newMessage +=
          '\nCommand $commandName not found, type help for list of available commands';
      ref.read(commandPromptStreamControllerProvider).add(newMessage);
      return;
    }
    //validate command
    final validationError =
        commandToExecute.validate(commandArgs, ref, _commands);
    if (validationError != null) {
      newMessage += '\n$validationError';
      ref.read(commandPromptStreamControllerProvider).add(newMessage);
      return;
    }
    ref.read(commandPromptStreamControllerProvider).add(newMessage);
    //execute command
    await commandToExecute.execute(commandArgs, ref, _commands);
  }

  List<String> _tokenizeCommand(String command) {
    //first get all String with spaces by finding all text between quotes
    final List<String> quotedStrings =
        RegExp('"(.*?)"').allMatches(command).map((e) => e.group(0)!).toList();
    //replace all quoted strings with placeholder
    final String commandWithPlaceholders = quotedStrings.fold(
      command,
      (previousValue, element) => previousValue.replaceAll(
        element,
        '%',
      ),
    );
    //split command by spaces
    final List<String> splitTokens = commandWithPlaceholders.split(' ');
    //replace placeholders with original strings and remove quotes
    final List<String> tokens = splitTokens.map((e) {
      if (e == '%') {
        return quotedStrings.removeAt(0).replaceAll('"', '');
      }
      return e;
    }).toList();
    return tokens;
  }
}
