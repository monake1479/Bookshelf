import 'package:flutter/material.dart';
import 'package:ztp_projekt/common/shortcuts/bookshelf_shortcuts.dart';
import 'package:ztp_projekt/explorer/pages/records_page.dart';

class BookshelfApp extends StatelessWidget {
  const BookshelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
}
