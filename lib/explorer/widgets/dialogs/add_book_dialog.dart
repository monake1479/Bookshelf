// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/books/controllers/form/book_form_state.dart';
import 'package:ztp_projekt/books/controllers/manage_books/manage_books_state.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/common/widgets/bookshelf_exception_dialog.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class AddBookDialog extends StatefulWidget {
  const AddBookDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const AddBookDialog(),
    );
  }

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _priceTextController = TextEditingController();
  bool _authorError = false;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final textTheme = Theme.of(context).textTheme;
        final colorScheme = Theme.of(context).colorScheme;
        final bookFormNotifier = ref.watch(bookFormNotifierProvider.notifier);
        final bookFormState = ref.watch(bookFormNotifierProvider);
        final getAuthorsState = ref.watch(getAuthorsNotifierProvider);

        return WillPopScope(
          onWillPop: () async {
            bookFormNotifier.reset();
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
                        bookFormNotifier.reset();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
                      child: Text(
                        'Add book',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                            validator: (title) {
                              if (title == null || title.isEmpty) {
                                return 'Field cannot be empty';
                              }
                              return null;
                            },
                            onChanged: bookFormNotifier.updateTitle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: DropdownButton2<Author>(
                            isExpanded: true,
                            onChanged: (author) {
                              if (author != null) {
                                setState(() {
                                  _authorError = false;
                                });
                                bookFormNotifier.updateAuthor(author);
                              }
                            },
                            underline: const SizedBox(),
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            value: bookFormState.author,
                            items: getAuthorsState.authors
                                .map(
                                  (author) => DropdownMenuItem<Author>(
                                    value: author,
                                    child: Text(author.fullName),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (_authorError) {
                              return Text(
                                'Field cannot by empty',
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontSize: textTheme.bodySmall!.fontSize,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Publisher',
                            ),
                            validator: (publisher) {
                              if (publisher == null || publisher.isEmpty) {
                                return 'Field cannot be empty';
                              }
                              return null;
                            },
                            onChanged: bookFormNotifier.updatePublisher,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            controller: _dateTextController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Publication date',
                            ),
                            validator: (publicationDate) {
                              if (publicationDate == null ||
                                  publicationDate.isEmpty) {
                                return 'Field cannot be empty';
                              }
                              return null;
                            },
                            onTap: () async {
                              final pickedDate = await _showTableCalendar(
                                context,
                                bookFormState.publicationDate ?? DateTime.now(),
                              );

                              if (pickedDate != null) {
                                bookFormNotifier
                                    .updatePublicationDate(pickedDate);
                                _dateTextController.text =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                              } else {
                                bookFormNotifier
                                    .updatePublicationDate(DateTime.now());
                                _dateTextController.text =
                                    DateFormat('dd-MM-yyyy')
                                        .format(DateTime.now());
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'ISBN number',
                            ),
                            validator: (isbnNumber) {
                              if (isbnNumber == null || isbnNumber.isEmpty) {
                                return 'Field cannot be empty';
                              }
                              return null;
                            },
                            onChanged: bookFormNotifier.updateIsbnNumber,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            controller: _priceTextController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                            ),
                            validator: (price) {
                              if (price == null || price.isEmpty) {
                                return 'Field cannot be empty';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('^[0-9]+\\.?[0-9]*'),
                              ),
                              FilteringTextInputFormatter.deny(
                                RegExp('[a-z]'),
                              ),
                              FilteringTextInputFormatter.deny(
                                RegExp(','),
                              )
                            ],
                            onChanged: (price) {
                              if (price.isNotEmpty) {
                                bookFormNotifier
                                    .updatePrice(double.parse(price));
                              } else {
                                bookFormNotifier.updatePrice(null);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () async {
                    await _addOnPressed(ref, context);
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> _showTableCalendar(
    BuildContext context,
    DateTime initialDay,
  ) async {
    final pickedDate = await showDialog<DateTime?>(
      context: context,
      builder: (context) => DatePickerDialog(
        initialDate: initialDay,
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
      ),
    );

    return pickedDate;
  }

  Future<void> _addOnPressed(WidgetRef ref, BuildContext context) async {
    final bookFormNotifier = ref.read(bookFormNotifierProvider.notifier);
    final bookFormState = ref.read(bookFormNotifierProvider);
    if (ref.read(bookFormNotifierProvider).isFormValid) {
      await bookFormNotifier.insert();
      if (ref.read(manageBooksNotifierProvider).isException) {
        await BookshelfExceptionDialog.show(
          context,
          ref.read(manageBooksNotifierProvider).getException!,
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
      if (bookFormState.author == null) {
        setState(() {
          _authorError = true;
        });
      }
    }
  }
}
