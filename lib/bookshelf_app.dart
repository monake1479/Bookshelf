import 'package:flutter/material.dart';
import 'package:ztp_projekt/home_page.dart';

class BookshelfApp extends StatelessWidget {
  const BookshelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF541ea6),
        ),
      ),
      home: const HomePage(),
    );
  }
}
