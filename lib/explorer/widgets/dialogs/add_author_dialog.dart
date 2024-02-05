// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/form/authors_form_state.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_state.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/common/widgets/bookshelf_exception_dialog.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class AddAuthorDialog extends StatefulWidget {
  const AddAuthorDialog({super.key});

  static Future<void> show(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => const AddAuthorDialog(),
    );
  }

  @override
  State<AddAuthorDialog> createState() => _AddAuthorDialogState();
}

class _AddAuthorDialogState extends State<AddAuthorDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final textTheme = Theme.of(context).textTheme;
        final authorsFormNotifier =
            ref.watch(authorFormNotifierProvider.notifier);

        return WillPopScope(
          onWillPop: () async {
            authorsFormNotifier.reset();
            return true;
          },
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(32),
            title: Row(
              children: [
                IconButton(
                  onPressed: () {
                    authorsFormNotifier.reset();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
                  child: Text(
                    'Add author',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'First name',
                            ),
                            validator: (firstName) {
                              if (firstName == null || firstName.isEmpty) {
                                return 'Field cannot be empty';
                              }
                              return null;
                            },
                            onChanged: authorsFormNotifier.updateFirstName,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Last name',
                          ),
                          validator: (lastName) {
                            if (lastName == null || lastName.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                          onChanged: authorsFormNotifier.updateLastName,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  await _insertOnPressed(ref, context);
                },
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _insertOnPressed(WidgetRef ref, BuildContext context) async {
    final authorsFormNotifier = ref.read(authorFormNotifierProvider.notifier);

    if (ref.read(authorFormNotifierProvider).isFormValid) {
      await authorsFormNotifier.insert();
      if (ref.read(manageAuthorsNotifierProvider).isException) {
        await BookshelfExceptionDialog.show(
          context,
          ref.read(manageAuthorsNotifierProvider).getException!,
          () {
            Navigator.of(context).pop();
          },
        );
      } else {
        await ref.read(manageBooksNotifierProvider.notifier).getAll();
        Navigator.of(context).pop();
      }
    } else {
      _formKey.currentState!.validate();
    }
  }
}
