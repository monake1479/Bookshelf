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
    final colorScheme = theme.colorScheme;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            exception.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: colorScheme.error,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                child: const Text('Ok'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
