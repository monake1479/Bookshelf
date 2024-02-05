import 'dart:async';

import 'package:ztp_projekt/explorer/controllers/sort_state.dart';
import 'package:ztp_projekt/explorer/models/sort_record.dart';

class StateToRecordTransformer
    implements StreamTransformer<SortState, SortRecord?> {
  StateToRecordTransformer();

  final _controller = StreamController<SortRecord?>.broadcast();

  StreamSubscription<SortState>? _subscription;

  @override
  Stream<SortRecord?> bind(Stream<SortState> stream) {
    _subscription = stream.listen(
      (event) {
        _controller.add(event.sortBy);
      },
      onDone: () {
        _subscription?.cancel();
        _controller.close();
      },
      onError: (error) {
        _subscription?.cancel();
        _controller.close();
      },
      cancelOnError: true,
    );

    return _controller.stream;
  }

  @override
  StreamTransformer<SortState, SortRecord> cast<SortState, SortRecord>() =>
      StreamTransformer.castFrom(this);
}
