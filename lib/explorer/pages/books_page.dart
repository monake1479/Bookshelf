// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ztp_projekt/books/controllers/manage_books/manage_books_state.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/books/models/book.dart';
import 'package:ztp_projekt/books/models/books_sort_field.dart';
import 'package:ztp_projekt/common/models/bookshelf_exception.dart';
import 'package:ztp_projekt/common/widgets/bookshelf_exception_dialog.dart';
import 'package:ztp_projekt/explorer/models/sort_field.dart';
import 'package:ztp_projekt/explorer/models/sort_record.dart';
import 'package:ztp_projekt/explorer/providers.dart';
import 'package:ztp_projekt/explorer/utils/state_to_record_transformer.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/edit_book_dialog.dart';
import 'package:ztp_projekt/explorer/widgets/record_actions.dart';
import 'package:ztp_projekt/explorer/widgets/record_header_cell.dart';
import 'package:ztp_projekt/explorer/widgets/records_row.dart';

class BooksPage extends ConsumerWidget {
  const BooksPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final sortBooksState = ref.watch(sortBooksNotifierProvider);
    final sortNotifier = ref.read(sortNotifierProvider.notifier);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ElevationOverlay.applySurfaceTint(
            colorScheme.surface,
            colorScheme.surfaceTint,
            2,
          ),
          floating: true,
          snap: true,
          pinned: true,
          collapsedHeight: kToolbarHeight,
          flexibleSpace: RecordsRow(
            canHover: false,
            children: [
              RecordHeaderCell.static(
                title: 'ID',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              RecordHeaderCell(
                title: 'Name',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                iconColor: colorScheme.tertiary.withOpacity(0.5),
                selectedIconColor: colorScheme.tertiary,
                onChanged: (value) => _onRecordHeaderCellChange(value, ref),
                stateStream: sortNotifier.stream
                    .transform<SortRecord?>(StateToRecordTransformer()),
                sortField: SortField.bookTitle,
              ),
              RecordHeaderCell.static(
                title: 'Author',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              RecordHeaderCell.static(
                title: 'Publisher',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              RecordHeaderCell(
                title: 'Publication Date',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                iconColor: colorScheme.tertiary.withOpacity(0.5),
                selectedIconColor: colorScheme.tertiary,
                onChanged: (value) => _onRecordHeaderCellChange(value, ref),
                stateStream: sortNotifier.stream
                    .transform<SortRecord?>(StateToRecordTransformer()),
                sortField: SortField.bookPublicationDate,
              ),
              RecordHeaderCell.static(
                title: 'ISBN',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              RecordHeaderCell(
                title: 'Price',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                iconColor: colorScheme.tertiary.withOpacity(0.5),
                selectedIconColor: colorScheme.tertiary,
                onChanged: (value) => _onRecordHeaderCellChange(value, ref),
                stateStream: sortNotifier.stream
                    .transform<SortRecord?>(StateToRecordTransformer()),
                sortField: SortField.bookPrice,
              ),
              RecordHeaderCell.static(
                title: 'Actions',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Builder(
          builder: (context) {
            if (sortBooksState.books.isEmpty) {
              return const SliverPadding(
                padding: EdgeInsets.only(top: 20),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Text('Books table is empty'),
                  ),
                ),
              );
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RecordsRow(
                    key: UniqueKey(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      Text(sortBooksState.books[index].id.toString()),
                      Text(sortBooksState.books[index].title),
                      Text(sortBooksState.books[index].authorName),
                      Text(sortBooksState.books[index].publisher),
                      Text(
                        DateFormat('dd-MM-yyyy').format(
                          sortBooksState.books[index].publicationDate,
                        ),
                      ),
                      Text(sortBooksState.books[index].isbnNumber),
                      Text('${sortBooksState.books[index].price}'),
                      RecordActions(
                        onEdit: () async {
                          await _onBookEditTap(
                            ref,
                            context,
                            sortBooksState.books[index],
                          );
                        },
                        onDelete: () async {
                          await _onBookDeleteTap(
                            ref,
                            context,
                            sortBooksState.books[index].id,
                          );
                        },
                      ),
                    ],
                  ),
                  childCount: sortBooksState.books.length,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void _onRecordHeaderCellChange(SortRecord value, WidgetRef ref) {
    ref.read(sortBooksNotifierProvider.notifier).setSort(
          value.type,
          BooksSortFieldX.fromSortField(value.field),
        );
    ref.read(sortNotifierProvider.notifier).setSortType(value);
  }

  Future<void> _onBookEditTap(
    WidgetRef ref,
    BuildContext context,
    Book book,
  ) async {
    await ref.read(bookFormNotifierProvider.notifier).setInitialBook(book);
    if (ref.read(bookFormNotifierProvider).author != null) {
      await EditBookDialog.show(
        context,
        book,
      );
    } else {
      await BookshelfExceptionDialog.show(
        context,
        const BookshelfException.authorNotFoundError(),
        () {},
      );
    }
  }

  Future<void> _onBookDeleteTap(
    WidgetRef ref,
    BuildContext context,
    int bookId,
  ) async {
    await ref.read(manageBooksNotifierProvider.notifier).delete(bookId);

    if (ref.read(manageBooksNotifierProvider).isException) {
      await BookshelfExceptionDialog.show(
        context,
        ref.read(manageBooksNotifierProvider).getException!,
        () {
          ref.read(manageBooksNotifierProvider.notifier).getAll();
          Navigator.of(context).pop();
        },
      );
    }
  }
}
