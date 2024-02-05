import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/books/models/book.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';

final _tables = [
  'book',
  'author',
];
final _booksFields = [
  'title',
  'authorID',
  'publisher',
  'publicationDate',
  'isbn',
  'price',
];
final _authorsFields = ['name', 'surname'];

class EditCommand implements Command {
  @override
  String get command => 'edit';

  @override
  String get description => 'Edits a record in specified table';

  @override
  Future<void> execute(
    List<String> args,
    Ref<Object?> ref,
    List<Command> availableCommands,
  ) async {
    //check if we are trying to change book
    if (args[0] == _tables[0]) {
      //find book with given id
      Book book = ref
          .read(getBooksNotifierProvider)
          .books
          .firstWhere((book) => book.id == int.parse(args[1]));
      //check which field we are trying to change
      if (args[2] == _booksFields[0]) {
        //change title
        book = book.copyWith(title: args[3]);
      }
      if (args[2] == _booksFields[1]) {
        //change authorID
        book = book.copyWith(authorId: int.parse(args[3]));
      }
      if (args[2] == _booksFields[2]) {
        //change publisher
        book = book.copyWith(publisher: args[3]);
      }
      if (args[2] == _booksFields[3]) {
        //change publicationDate
        book = book.copyWith(publicationDate: DateTime.tryParse(args[3])!);
      }
      if (args[2] == _booksFields[4]) {
        //change isbn
        book = book.copyWith(isbnNumber: args[3]);
      }
      if (args[2] == _booksFields[5]) {
        //change price
        book = book.copyWith(price: double.parse(args[3]));
      }
      //update book
      await ref.read(bookFormNotifierProvider.notifier).setInitialBook(book);
      await ref.read(bookFormNotifierProvider.notifier).update();
    }
    //check if we are trying to change author
    else {
      //find author with given id
      Author author = ref
          .read(getAuthorsNotifierProvider)
          .authors
          .firstWhere((author) => author.id == int.parse(args[1]));
      //check which field we are trying to change
      if (args[2] == _authorsFields[0]) {
        //change name
        author = author.copyWith(firstName: args[3]);
      }
      if (args[2] == _authorsFields[1]) {
        //change surname
        author = author.copyWith(lastName: args[3]);
      }
      //update author
      ref.read(authorFormNotifierProvider.notifier).setInitialAuthor(author);
      await ref.read(authorFormNotifierProvider.notifier).update();
    }
  }

  @override
  CommandValidationError? validate(
    List<String> args,
    Ref<Object?> ref,
    List<Command> availableCommands,
  ) {
    if (args.length != 4) {
      return CommandValidationError(
        command: command,
        message:
            'Command takes four arguments, type "help add" for more information',
      );
    }
    if (!_tables.contains(args[0])) {
      return CommandValidationError(
        command: command,
        message: 'Invalid table, type "help add" for more information',
      );
    }

    //check if id is a number
    if (int.tryParse(args[1]) == null) {
      return CommandValidationError(
        command: command,
        message: 'Invalid id, type "help add" for more information',
      );
    }
    if (args[0] == _tables[0]) {
      if (ref
          .read(getBooksNotifierProvider)
          .books
          .where((book) => book.id == int.parse(args[1]))
          .isEmpty) {
        return CommandValidationError(
          command: command,
          message: 'Book with given id does not exist',
        );
      }
      if (!_booksFields.contains(args[2])) {
        return CommandValidationError(
          command: command,
          message: 'Invalid field, type "help add" for more information',
        );
      }
      if (args[2] == _booksFields[1]) {
        if (ref
            .read(getAuthorsNotifierProvider)
            .authors
            .where((author) => author.id == int.parse(args[3]))
            .isEmpty) {
          return CommandValidationError(
            command: command,
            message: 'Author with given id does not exist',
          );
        }
      }
      //check if we are trying to change publicationDate and if so check if it is a valid date
      if (args[2] == _booksFields[3]) {
        final date = DateTime.tryParse(args[3]);
        if (date == null) {
          return CommandValidationError(
            command: command,
            message: 'Invalid date',
          );
        }
      }
      //check if we are trying to change price and if so check if it is a valid price
      if (args[2] == _booksFields[5]) {
        final price = double.tryParse(args[3]);
        if (price == null) {
          return CommandValidationError(
            command: command,
            message: 'Invalid price',
          );
        }
      }
    }
    if (args[0] == _tables[1]) {
      if (ref
          .read(getAuthorsNotifierProvider)
          .authors
          .where((author) => author.id == int.parse(args[1]))
          .isEmpty) {
        return CommandValidationError(
          command: command,
          message: 'Author with given id does not exist',
        );
      }
      if (!_authorsFields.contains(args[2])) {
        return CommandValidationError(
          command: command,
          message: 'Invalid field, type "help add" for more information',
        );
      }
    }
    return null;
  }

  @override
  String printUsage() {
    final List<String> usage = [
      'Usage: edit <table> <id> <field> <value>',
      'Edits a record in specified table',
      'Available tables: ${_tables.join(', ')}',
      'Available fields for books: ${_booksFields.join(', ')}',
      'Available fields for authors: ${_authorsFields.join(', ')}',
    ];
    return usage.join('\n');
  }
}
