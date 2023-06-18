import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/controllers/command_prompt_state.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';

class CommandPromptNotifier extends StateNotifier<CommandPromptState> {
  CommandPromptNotifier(this.ref) : super(CommandPromptState.initial());

  final List<Command> _commands = [];

  final Ref ref;

  void registerCommands(List<Command> commands) {
    _commands.addAll(commands);
  }

  Future<void> onCommand(String command) async {
    state = state.copyWith(
      isWorking: true,
    );
    String newMessage = '\n> $command';
    //tokenize command
    final tokens = command.split(' ');
    final commandName = tokens[0].split('/').last;
    final commandArgs = tokens.sublist(1);
    //try to find command in registered commands
    final commandToExecute =
        _commands.firstWhereOrNull((element) => element.command == commandName);
    //if not found, return error
    if (commandToExecute == null) {
      newMessage +=
          '\nCommand $commandName not found, type /help for list of available commands';
      state = state.copyWith(
        lastMessage: newMessage,
        isWorking: false,
      );
      return;
    }
    //validate command
    final validationError =
        commandToExecute.validate(commandArgs, ref, _commands);
    if (validationError != null) {
      newMessage += '\n$validationError';
      state = state.copyWith(
        lastMessage: newMessage,
        isWorking: false,
      );
      return;
    }
    //execute command
    final response =
        await commandToExecute.execute(commandArgs, ref, _commands);
    if (response != null) {
      newMessage += '\n$response';
    } else {
      newMessage += '\nCommand $commandName executed successfully';
    }
    if (mounted) {
      state = state.copyWith(
        lastMessage: newMessage,
        isWorking: false,
      );
    }
  }

  @override
  void dispose() {
    log('CommandPromptNotifier.dispose');
    super.dispose();
  }
}
