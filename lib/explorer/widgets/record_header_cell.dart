import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ztp_projekt/common/utils/color_at_elevation.dart';
import 'package:ztp_projekt/explorer/models/sort_field.dart';
import 'package:ztp_projekt/explorer/models/sort_record.dart';
import 'package:ztp_projekt/explorer/models/sort_type_enum.dart';

class RecordHeaderCell extends StatefulWidget {
  const RecordHeaderCell({
    super.key,
    required this.title,
    required this.iconColor,
    required this.onChanged,
    required this.textStyle,
    required this.selectedIconColor,
    required this.stateStream,
    required this.sortField,
  }) : canFilter = true;

  const RecordHeaderCell.static({
    super.key,
    required this.title,
    required this.textStyle,
  })  : canFilter = false,
        iconColor = Colors.transparent,
        selectedIconColor = Colors.transparent,
        onChanged = _defaultOnChanged,
        stateStream = const Stream.empty(),
        sortField = null;

  final String title;
  final Color iconColor;
  final Color selectedIconColor;
  final TextStyle textStyle;
  final bool canFilter;
  final SortField? sortField;
  final Stream<SortRecord?>? stateStream;
  final void Function(SortRecord value) onChanged;

  @override
  State<RecordHeaderCell> createState() => _RecordHeaderCellState();
}

class _RecordHeaderCellState extends State<RecordHeaderCell>
    with TickerProviderStateMixin {
  late AnimationController _ascendingAnimationController;
  late AnimationController _descendingAnimationController;
  late Animation<Color?> _ascendingAnimation;
  late Animation<Color?> _descendingAnimation;
  SortType _state = SortType.none;

  StreamSubscription<SortRecord?>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _streamSubscription = widget.stateStream!.listen((event) {
      if (event == null) {
        _onStateChanged(SortType.none);
        return;
      }
      if (event.field != widget.sortField) {
        _onStateChanged(SortType.none);
        return;
      }
      _onStateChanged(event.type);
    });
    _ascendingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _descendingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    final ColorTween colorTween = ColorTween(
      begin: widget.iconColor,
      end: widget.selectedIconColor,
    );
    _ascendingAnimation = colorTween.animate(_ascendingAnimationController);
    _descendingAnimation = colorTween.animate(_descendingAnimationController);
  }

  @override
  void dispose() {
    _ascendingAnimationController.dispose();
    _descendingAnimationController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor:
          Theme.of(context).colorScheme.surface.withSurfaceTint(context, 5),
      splashColor:
          Theme.of(context).colorScheme.surface.withSurfaceTint(context, 8),
      hoverColor:
          Theme.of(context).colorScheme.surface.withSurfaceTint(context, 5),
      onTap: widget.canFilter ? _onTap : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: widget.textStyle,
              ),
              if (widget.canFilter)
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    AnimatedBuilder(
                      animation: _descendingAnimation,
                      builder: (context, child) {
                        return Icon(
                          Icons.arrow_drop_up,
                          color: _descendingAnimation.value,
                        );
                      },
                    ),
                    Positioned(
                      top: 6,
                      child: AnimatedBuilder(
                        animation: _ascendingAnimation,
                        builder: (context, child) {
                          return Icon(
                            Icons.arrow_drop_down,
                            color: _ascendingAnimation.value,
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTap() {
    switch (_state) {
      case SortType.none:
        _ascendingAnimationController.forward();

        setState(() {
          _state = SortType.ascending;
        });
        break;
      case SortType.ascending:
        _ascendingAnimationController.reverse();
        _descendingAnimationController.forward();

        setState(() {
          _state = SortType.descending;
        });
        break;
      case SortType.descending:
        _descendingAnimationController.reverse();
        setState(() {
          _state = SortType.none;
        });
        break;
    }
    if (_state == SortType.none) {
      widget
          .onChanged(SortRecord(field: widget.sortField!, type: SortType.none));
    } else {
      widget.onChanged(SortRecord(field: widget.sortField!, type: _state));
    }
  }

  void _onStateChanged(SortType newState) {
    setState(() {
      _state = newState;
    });
    switch (_state) {
      case SortType.none:
        _ascendingAnimationController.reverse();
        _descendingAnimationController.reverse();
        break;
      case SortType.ascending:
        _ascendingAnimationController.forward();
        _descendingAnimationController.reverse();
        break;
      case SortType.descending:
        _ascendingAnimationController.reverse();
        _descendingAnimationController.forward();
        break;
    }
  }
}

void _defaultOnChanged(SortRecord value) {}
