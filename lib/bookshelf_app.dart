import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/clear_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/delete_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/help_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/sort_command.dart';
import 'package:ztp_projekt/command_prompt/models/commands/switch_command.dart';
import 'package:ztp_projekt/command_prompt/providers.dart';
import 'package:ztp_projekt/common/shortcuts/bookshelf_shortcuts.dart';
import 'package:ztp_projekt/explorer/pages/records_page.dart';

class BookshelfApp extends ConsumerStatefulWidget {
  const BookshelfApp({super.key});

  @override
  ConsumerState<BookshelfApp> createState() => _BookshelfAppState();
}

class _BookshelfAppState extends ConsumerState<BookshelfApp> {
  @override
  void initState() {
    log('BookshelfApp initState');
    _initializeCommands(ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('BookshelfApp build');
    return MaterialApp(
      title: 'Bookshelf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF541EA6),
          brightness: Brightness.dark,
        ),
      ),
      home: const BookShelfShortcuts(child: RecordsPage()),
    );
  }

  void _initializeCommands(WidgetRef ref) {
    final List<Command> availableCommands = [
      HelpCommand(),
      ClearCommand(),
      SwitchCommand(),
      SortCommand(),
      DeleteCommand(),
    ];
    ref
        .read(commandPromptNotifierProvider.notifier)
        .registerCommands(availableCommands);
  }
}
