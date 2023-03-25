import 'package:flutter/material.dart';
import 'package:ztp_projekt/common/utils/color_at_elevation.dart';

class RecordHeaderCell extends StatefulWidget {
  const RecordHeaderCell({
    super.key,
    required this.title,
    required this.iconColor,
    required this.onChanged,
    required this.textStyle,
    required this.selectedIconColor,
  }) : canFilter = true;

  const RecordHeaderCell.static({
    super.key,
    required this.title,
    required this.textStyle,
  })  : canFilter = false,
        iconColor = Colors.transparent,
        selectedIconColor = Colors.transparent,
        onChanged = _defaultOnChanged;

  final String title;
  final Color iconColor;
  final Color selectedIconColor;
  final TextStyle textStyle;
  final bool canFilter;
  final void Function(RecordHeaderCellState value) onChanged;

  @override
  State<RecordHeaderCell> createState() => _RecordHeaderCellState();
}

class _RecordHeaderCellState extends State<RecordHeaderCell>
    with TickerProviderStateMixin {
  late AnimationController _ascendingAnimationController;
  late AnimationController _descendingAnimationController;
  late Animation<Color?> _ascendingAnimation;
  late Animation<Color?> _descendingAnimation;
  RecordHeaderCellState _state = RecordHeaderCellState.none;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
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
      case RecordHeaderCellState.none:
        _ascendingAnimationController.forward();
        setState(() {
          _state = RecordHeaderCellState.ascending;
        });
        widget.onChanged(RecordHeaderCellState.ascending);
        break;
      case RecordHeaderCellState.ascending:
        _ascendingAnimationController.reverse();
        _descendingAnimationController.forward();
        setState(() {
          _state = RecordHeaderCellState.descending;
        });
        widget.onChanged(RecordHeaderCellState.descending);
        break;
      case RecordHeaderCellState.descending:
        _descendingAnimationController.reverse();
        setState(() {
          _state = RecordHeaderCellState.none;
        });
        widget.onChanged(RecordHeaderCellState.none);
        break;
    }
  }
}

enum RecordHeaderCellState {
  none,
  ascending,
  descending,
}

void _defaultOnChanged(RecordHeaderCellState value) {}
