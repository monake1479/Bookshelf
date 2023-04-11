import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/explorer/widgets/record_actions.dart';
import 'package:ztp_projekt/explorer/widgets/record_header_cell.dart';
import 'package:ztp_projekt/explorer/widgets/records_row.dart';

class BooksTabView extends StatelessWidget {
  const BooksTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
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
              RecordHeaderCell(
                title: 'Name',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                iconColor: colorScheme.tertiary.withOpacity(0.5),
                selectedIconColor: colorScheme.tertiary,
                onChanged: print,
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
                onChanged: print,
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
                onChanged: print,
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
        Consumer(
          builder: (context, ref, child) {
            final getBooksState = ref.watch(getBooksNotifierProvider);
            final manageBooksNotifier =
                ref.watch(manageBooksNotifierProvider.notifier);
            if (getBooksState.books.isEmpty) {
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      Text(getBooksState.books[index].title),
                      Text(getBooksState.books[index].authorName),
                      Text(getBooksState.books[index].publisher),
                      Text('${getBooksState.books[index].publicationDate}'),
                      Text(getBooksState.books[index].isbnNumber),
                      Text('${getBooksState.books[index].price}'),
                      RecordActions(
                        onDelete: () async {
                          await manageBooksNotifier
                              .delete(getBooksState.books[index].id);
                        },
                      ),
                    ],
                  ),
                  childCount: getBooksState.books.length,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
