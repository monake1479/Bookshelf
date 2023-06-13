import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_size/window_size.dart';
import 'package:ztp_projekt/bookshelf_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    setWindowTitle('BookShelf');
    setWindowMaxSize(const Size(1920, 1080));
    setWindowMinSize(const Size(1350, 720));
  }

  await initializeDateFormatting().then(
    (_) => runApp(
      const ProviderScope(child: BookshelfApp()),
    ),
  );
}
