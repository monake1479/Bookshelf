import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';

abstract class Command {
  Command(this._command, this._description)
      : assert(
          _command.characters.first != '/',
          'Command cannot start with "/"',
        );
  final String _command;
  final String _description;

  String get command => _command;
  String get description => _description;

  Future<String?> execute(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) async {
    throw UnimplementedError();
  }

  CommandValidationError? validate(
    List<String> args,
    Ref ref,
    List<Command> availableCommands,
  ) {
    throw UnimplementedError();
  }

  String printUsage() {
    throw UnimplementedError();
  }
}
