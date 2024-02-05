// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_state.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/authors/models/author_sort_field.dart';
import 'package:ztp_projekt/common/widgets/bookshelf_exception_dialog.dart';
import 'package:ztp_projekt/explorer/models/sort_field.dart';
import 'package:ztp_projekt/explorer/models/sort_record.dart';
import 'package:ztp_projekt/explorer/providers.dart';
import 'package:ztp_projekt/explorer/utils/state_to_record_transformer.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/edit_author_dialog.dart';
import 'package:ztp_projekt/explorer/widgets/record_actions.dart';
import 'package:ztp_projekt/explorer/widgets/record_header_cell.dart';
import 'package:ztp_projekt/explorer/widgets/records_row.dart';

class AuthorsPage extends ConsumerWidget {
  const AuthorsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedAuthorsState = ref.watch(sortAuthorsNotifierProvider);
    final sortNotifier = ref.read(sortNotifierProvider.notifier);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
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
                sortField: SortField.authorFirstName,
              ),
              RecordHeaderCell(
                title: 'Last Name',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                iconColor: colorScheme.tertiary.withOpacity(0.5),
                selectedIconColor: colorScheme.tertiary,
                onChanged: (value) => _onRecordHeaderCellChange(value, ref),
                stateStream: sortNotifier.stream
                    .transform<SortRecord?>(StateToRecordTransformer()),
                sortField: SortField.authorLastName,
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
            if (sortedAuthorsState.authors.isEmpty) {
              return const SliverPadding(
                padding: EdgeInsets.only(top: 20),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Text('Authors table is empty'),
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
                      Text(sortedAuthorsState.authors[index].id.toString()),
                      Text(sortedAuthorsState.authors[index].firstName),
                      Text(sortedAuthorsState.authors[index].lastName),
                      RecordActions(
                        onEdit: () async {
                          await _onAuthorEditTap(
                            ref,
                            context,
                            sortedAuthorsState.authors[index],
                          );
                        },
                        onDelete: () async {
                          await _onAuthorDeleteTap(
                            ref,
                            context,
                            sortedAuthorsState.authors[index].id,
                          );
                        },
                      ),
                    ],
                  ),
                  childCount: sortedAuthorsState.authors.length,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void _onRecordHeaderCellChange(
    SortRecord value,
    WidgetRef ref,
  ) {
    ref.read(sortAuthorsNotifierProvider.notifier).setSort(
          value.type,
          AuthorSortFieldX.fromSortField(value.field),
        );
    ref.read(sortNotifierProvider.notifier).setSortType(
          value,
        );
  }

  Future<void> _onAuthorEditTap(
    WidgetRef ref,
    BuildContext context,
    Author author,
  ) async {
    ref.read(authorFormNotifierProvider.notifier).setInitialAuthor(author);
    await EditAuthorDialog.show(
      context,
      author,
    );
  }

  Future<void> _onAuthorDeleteTap(
    WidgetRef ref,
    BuildContext context,
    int authorId,
  ) async {
    await ref.read(manageAuthorsNotifierProvider.notifier).delete(authorId);

    if (ref.read(manageAuthorsNotifierProvider).isException) {
      await BookshelfExceptionDialog.show(
        context,
        ref.read(manageAuthorsNotifierProvider).getException!,
        () {
          ref.read(manageAuthorsNotifierProvider.notifier).getAll();
          Navigator.of(context).pop();
        },
      );
    }
  }
}
