import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/authors/models/author_sort_field.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/books/models/books_sort_field.dart';
import 'package:ztp_projekt/command_prompt/models/command.dart';
import 'package:ztp_projekt/command_prompt/models/command_validation_error.dart';
import 'package:ztp_projekt/command_prompt/providers.dart';
import 'package:ztp_projekt/explorer/models/sort_field.dart';
import 'package:ztp_projekt/explorer/models/sort_record.dart';
import 'package:ztp_projekt/explorer/models/sort_type_enum.dart';
import 'package:ztp_projekt/explorer/providers.dart';

const _tables = ['books', 'authors'];
const _bookFields = ['title', 'publicationDate', 'price'];
const _authorFields = ['name', 'surname'];
const _orders = ['asc', 'desc'];

class SortCommand implements Command {
  @override
  String get command => 'sort';

  @override
  String get description =>
      'Sorts the list of books or authors by a given field.';

  @override
  Future<void> execute(
    List<String> args,
    Ref<Object?> ref,
    List<Command> availableCommands,
  ) async {
    final tableName = args[0].toLowerCase();
    final fieldName = args[1].toLowerCase();
    final order = args[2].toLowerCase();
    final SortField sortingField = _getSortField(tableName, fieldName);
    final SortType sortingType = _getSortType(order);
    ref.read(sortNotifierProvider.notifier).setSortType(
          SortRecord(
            field: sortingField,
            type: sortingType,
          ),
        );
    if (tableName == _tables[0]) {
      ref.read(sortBooksNotifierProvider.notifier).setSort(
            sortingType,
            BooksSortFieldX.fromSortField(sortingField),
          );
    } else if (tableName == _tables[1]) {
      ref.read(sortAuthorsNotifierProvider.notifier).setSort(
            sortingType,
            AuthorSortFieldX.fromSortField(sortingField),
          );
    } else {
      throw ArgumentError('Invalid table name');
    }
    ref
        .read(commandPromptStreamControllerProvider)
        .add('\nSorted by $fieldName $order');
  }

  @override
  CommandValidationError? validate(
    List<String> args,
    Ref<Object?> ref,
    List<Command> availableCommands,
  ) {
    if (args.length != 3) {
      return CommandValidationError(
        command: command,
        message: 'Invalid number of arguments. Expected 3, got ${args.length}',
      );
    }
    final tableName = args[0].toLowerCase();
    final fieldName = args[1].toLowerCase();
    final order = args[2].toLowerCase();
    if (!_tables.contains(args[0])) {
      return CommandValidationError(
        command: command,
        message: 'Invalid table name. Possible values: books, authors',
      );
    }
    if (tableName == _tables[0] && !_bookFields.contains(fieldName)) {
      return CommandValidationError(
        command: command,
        message:
            'Invalid field name. Possible values: title, publicationYear, cost',
      );
    }
    if (tableName == _tables[1] && !_authorFields.contains(fieldName)) {
      return CommandValidationError(
        command: command,
        message: 'Invalid field name. Possible values: name, surname',
      );
    }
    if (!_orders.contains(order)) {
      return CommandValidationError(
        command: command,
        message: 'Invalid order. Possible values: asc, desc',
      );
    }
    return null;
  }

  @override
  String printUsage() {
    final List<String> lines = [
      'Usage: sort <table> <field> <order>',
      'Sorts the list of books or authors by a given field.',
      '<table> - table to sort. Possible values: $_tables.',
      '<field> - field to sort by, Possible values: table books $_bookFields, table authors $_authorFields.',
      '<order> - order to sort by. Possible values: $_orders.'
    ];
    return lines.join('\n');
  }

  SortField _getSortField(String table, String field) {
    if (table == 'books') {
      switch (field) {
        case 'title':
          return SortField.bookTitle;
        case 'publicationYear':
          return SortField.bookPublicationDate;
        case 'cost':
          return SortField.bookPrice;
        default:
          throw ArgumentError('Invalid field name');
      }
    } else if (table == 'authors') {
      switch (field) {
        case 'name':
          return SortField.authorFirstName;
        case 'surname':
          return SortField.authorLastName;
        default:
          throw ArgumentError('Invalid field name');
      }
    } else {
      throw ArgumentError('Invalid table name');
    }
  }

  SortType _getSortType(String order) {
    switch (order) {
      case 'asc':
        return SortType.ascending;
      case 'desc':
        return SortType.descending;
      default:
        throw ArgumentError('Invalid order');
    }
  }
}
