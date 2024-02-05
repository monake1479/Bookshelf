import 'package:flutter/material.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';

class BookshelfExceptionDialog extends StatelessWidget {
  const BookshelfExceptionDialog({
    required this.exception,
    required this.onPressed,
    super.key,
  });
  final BookshelfException exception;
  final void Function() onPressed;

  static Future<void> show(
    BuildContext context,
    BookshelfException exception,
    void Function() onPressed,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BookshelfExceptionDialog(
        exception: exception,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(32),
      title: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: Text(
              'Error',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              exception.description,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
