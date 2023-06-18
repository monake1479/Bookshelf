import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ztp_projekt/explorer/models/sort_record.dart';

part 'sort_state.freezed.dart';

@freezed
class SortState with _$SortState {
  const factory SortState({
    required SortRecord? sortBy,
  }) = _SortState;

  factory SortState.initial() => const SortState(
        sortBy: null,
      );
}
