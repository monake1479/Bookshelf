import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/explorer/controllers/sort_state.dart';
import 'package:ztp_projekt/explorer/models/sort_record.dart';

class SortNotifier extends StateNotifier<SortState> {
  SortNotifier() : super(SortState.initial());
  //if one of the sort types is selected, the other ones are set to none

  void setSortType(SortRecord sortRecord) {
    state = state.copyWith(
      sortBy: sortRecord,
    );
  }

  void reset() {
    state = state.copyWith(
      sortBy: null,
    );
  }
}
