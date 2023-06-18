class CommandValidationError {
  CommandValidationError({
    required this.message,
    required this.command,
  });
  final String command;
  final String message;

  @override
  String toString() {
    final List<String> lines = [
      'Command: $command',
      'Message: $message',
    ];
    return lines.join('\n');
  }
}
