import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/explorer/controllers/sort_notifier.dart';
import 'package:ztp_projekt/explorer/controllers/sort_state.dart';
import 'package:ztp_projekt/explorer/models/current_tab_enum.dart';

final sortNotifierProvider = StateNotifierProvider<SortNotifier, SortState>(
  (ref) => SortNotifier(),
  name: 'SortNotifierProvider',
);

final recordsStreamControllerProvider = Provider<StreamController<CurrentTab>>(
  (ref) => StreamController.broadcast(),
  name: 'RecordsStreamControllerProvider',
);
