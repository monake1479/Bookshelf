// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/get_authors/get_authors_state.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_state.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/authors/models/author.dart';
import 'package:ztp_projekt/common/widgets/bookshelf_exception_dialog.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/edit_author_dialog.dart';
import 'package:ztp_projekt/explorer/widgets/record_actions.dart';
import 'package:ztp_projekt/explorer/widgets/record_header_cell.dart';
import 'package:ztp_projekt/explorer/widgets/records_row.dart';

class AuthorsTabView extends StatelessWidget {
  const AuthorsTabView({
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
                title: 'Last Name',
                textStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
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
            final getAuthorsState = ref.watch(getAuthorsNotifierProvider);

            log('getAuthorsState.authors.length:${getAuthorsState.authors.length}');
            log('in build getAuthorsState.authors: ${getAuthorsState.authors}');

            if (getAuthorsState.authors.isEmpty) {
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
                      Text(getAuthorsState.authors[index].firstName),
                      Text(getAuthorsState.authors[index].lastName),
                      RecordActions(
                        onEdit: () async {
                          await _onAuthorEditTap(
                            ref,
                            context,
                            getAuthorsState.authors[index],
                          );
                        },
                        onDelete: () async {
                          await _onAuthorDeleteTap(
                            ref,
                            context,
                            getAuthorsState.authors[index].id,
                          );
                        },
                      ),
                    ],
                  ),
                  childCount: getAuthorsState.authors.length,
                ),
              );
            }
          },
        ),
      ],
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
