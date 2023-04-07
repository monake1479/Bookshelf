import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ztp_projekt/common/utils/either_extension.dart';
import 'package:ztp_projekt/database/controllers/database_state.dart';
import 'package:ztp_projekt/database/interfaces/database_interface.dart';

class DatabaseNotifier extends StateNotifier<DatabaseState> {
  DatabaseNotifier(this._databaseInterface) : super(DatabaseState.initial());
  final DatabaseInterface _databaseInterface;
  void reset() {
    state = DatabaseState.initial();
  }

  bool isDbOpened() {
    return _databaseInterface.isDbOpened();
  }

  Future<void> create(String databaseName) async {
    state = state.copyWith(isLoading: true);
    final response = await _databaseInterface.createDb(databaseName);
    if (response.isRight()) {
      state = state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(right(unit)),
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(response.getLeftOrThrow())),
      );
    }
  }

  Future<void> open(String databaseName) async {
    state = state.copyWith(isLoading: true);
    final response = await _databaseInterface.openDb('$databaseName.db');
    log('response: ${response}');
    if (response.isRight()) {
      state = state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(right(response.getRightOrThrow())),
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(response.getLeftOrThrow())),
      );
    }
  }

  Future<void> close() async {
    state = state.copyWith(isLoading: true);
    await _databaseInterface.closeDb();
    state = state.copyWith(isLoading: false);
  }

  Future<void> openDatabaseFolder() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final Directory databaseDirectory =
        Directory('${documentsDirectory.path}/bookshelf/');
    if (!await databaseDirectory.exists()) {
      await databaseDirectory.create(recursive: true);
    }
    final Uri documentsUri = Uri.parse('${documentsDirectory.path}/bookshelf/');
    await launchUrl(documentsUri);
  }

  Future<void> listAllFiles() async {
    state = state.copyWith(isLoading: true);
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();

    final List<FileSystemEntity> systemFiles =
        Directory('${documentsDirectory.path}\\bookshelf\\').listSync();
    final List<String> filesPaths = [];
    for (final file in systemFiles) {
      if (file.path.endsWith('.db')) {
        filesPaths.add(file.path);
      }
    }
    state = state.copyWith(isLoading: false, databaseList: filesPaths);
  }

  String getDatabasePath() {
    return _databaseInterface.getDatabasePath().toLowerCase();
  }
}
