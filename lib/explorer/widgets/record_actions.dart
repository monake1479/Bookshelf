import 'package:flutter/material.dart';

class RecordActions extends StatelessWidget {
  RecordActions({super.key, this.onDelete, this.onEdit});
  final void Function()? onDelete;
  final void Function()? onEdit;
  final FocusNode _editFocusNode = FocusNode();
  final FocusNode _deleteFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          focusNode: _editFocusNode,
          highlightColor: Theme.of(context).colorScheme.secondaryContainer,
          focusColor: Theme.of(context).colorScheme.secondaryContainer,
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: onEdit ?? _editFocusNode.requestFocus,
        ),
        IconButton(
          focusNode: _deleteFocusNode,
          highlightColor: Theme.of(context).colorScheme.errorContainer,
          focusColor: Theme.of(context).colorScheme.errorContainer,
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: onDelete ?? _deleteFocusNode.requestFocus,
        ),
      ],
    );
  }
}
