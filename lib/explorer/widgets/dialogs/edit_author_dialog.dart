// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/form/authors_form_state.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_state.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/common/widgets/bookshelf_exception_dialog.dart';

class EditAuthorDialog extends StatefulWidget {
  const EditAuthorDialog({required this.author, super.key});

  final Author author;

  static Future<void> show(
    BuildContext context,
    Author author,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => EditAuthorDialog(
        author: author,
      ),
    );
  }

  @override
  State<EditAuthorDialog> createState() => _EditAuthorDialogState();
}

class _EditAuthorDialogState extends State<EditAuthorDialog> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    _firstNameController = TextEditingController(text: widget.author.firstName);
    _lastNameController = TextEditingController(text: widget.author.lastName);
    super.initState();
  }

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
            contentPadding: const EdgeInsets.all(8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                        'Edit author',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First name',
                            errorText: _firstNameController.text.isNotEmpty
                                ? null
                                : 'Field cannot be empty',
                          ),
                          onChanged: (firstName) {
                            authorsFormNotifier.updateFirstName(firstName);
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last name',
                            errorText: _lastNameController.text.isNotEmpty
                                ? null
                                : 'Field cannot be empty',
                          ),
                          onChanged: (lastName) {
                            authorsFormNotifier.updateLastName(lastName);
                            setState(() {});
                          },
                        ),
                      ),
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                        ),
                        onPressed: () async {
                          if (ref
                                  .read(authorFormNotifierProvider)
                                  .isFirstNameValid &&
                              ref
                                  .read(authorFormNotifierProvider)
                                  .isLastNameValid) {
                            await authorsFormNotifier.updateAuthor();
                            if (ref
                                .read(manageAuthorsNotifierProvider)
                                .isException) {
                              await BookshelfExceptionDialog.show(
                                context,
                                ref
                                    .read(manageAuthorsNotifierProvider)
                                    .getException!,
                                () {
                                  Navigator.of(context).pop();
                                },
                              );
                            }

                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                        ),
                        label: const Text('Edit'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
