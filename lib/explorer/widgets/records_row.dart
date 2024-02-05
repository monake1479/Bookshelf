import 'package:flutter/material.dart';
import 'package:ztp_projekt/common/utils/color_at_elevation.dart';

class RecordsRow extends StatefulWidget {
  const RecordsRow({
    super.key,
    required this.children,
    this.color = Colors.transparent,
    this.elevation = 0,
    this.padding,
    this.canHover = true,
  });
  final List<Widget> children;
  final Color color;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final bool canHover;

  @override
  State<RecordsRow> createState() => _RecordsRowState();
}

class _RecordsRowState extends State<RecordsRow> {
  List<Widget> _children = [];
  final FocusNode _focusNode = FocusNode();
  @override
  void didChangeDependencies() {
    _createChildren();
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _createChildren();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: _focusNode,
      splashColor: widget.color.withSurfaceTint(context, widget.elevation + 2),
      highlightColor:
          widget.color.withSurfaceTint(context, widget.elevation + 1),
      focusColor: widget.color.withSurfaceTint(context, widget.elevation + 1),
      hoverColor: widget.color.withSurfaceTint(context, widget.elevation + 1),
      onTap: widget.canHover ? _focusNode.requestFocus : null,
      child: Material(
        color: widget.color,
        elevation: widget.elevation,
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: Row(
            children: _children,
          ),
        ),
      ),
    );
  }

  void _createChildren() {
    _children = [];
    for (var i = 0; i < widget.children.length; i++) {
      if (i == 0) {
        _children.add(
          SizedBox(
            width: 50,
            child: widget.children[i],
          ),
        );
        continue;
      }
      _children.add(
        Expanded(
          child: widget.children[i],
        ),
      );
    }
  }
}
