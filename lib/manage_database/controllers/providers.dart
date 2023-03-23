import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/manage_database/controllers/get_database/get_database_notifier.dart';
import 'package:ztp_projekt/manage_database/controllers/get_database/get_database_state.dart';
import 'package:ztp_projekt/manage_database/controllers/manage_database/manage_database_notifier.dart';
import 'package:ztp_projekt/manage_database/controllers/manage_database/manage_database_state.dart';

final getDatabaseNotifierProvider =
    StateNotifierProvider<GetDatabaseNotifier, GetDatabaseState>(
  (ref) => GetDatabaseNotifier(),
);
final manageDatabaseNotifierProvider =
    StateNotifierProvider<ManageDatabaseNotifier, ManageDatabaseState>(
  (ref) => ManageDatabaseNotifier(),
);
