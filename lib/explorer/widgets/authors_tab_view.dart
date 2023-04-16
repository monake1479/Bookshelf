// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/manage_authors/manage_authors_state.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      Text(getAuthorsState.authors[index].firstName),
                      Text(getAuthorsState.authors[index].lastName),
                      RecordActions(
                        onEdit: () async {
                          ref
                              .read(authorFormNotifierProvider.notifier)
                              .setInitialAuthor(getAuthorsState.authors[index]);
                          await EditAuthorDialog.show(
                            context,
                            getAuthorsState.authors[index],
                          );
                        },
                        onDelete: () async {
                          await _onAuthorDeleteTap(
                              ref, context, getAuthorsState.authors[index].id);
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
    int index,
  ) async {
    final authorFormState = ref.read(authorFormNotifierProvider);
    final authorFormNotifier = ref.read(authorFormNotifierProvider.notifier);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: Text(
              'Edit author',
              textAlign: TextAlign.center,
            ),
          ),
          contentPadding: const EdgeInsets.all(8),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.30,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    initialValue: authorFormState.firstName,
                    decoration: InputDecoration(
                      labelText: 'First name',
                      errorText: authorFormState.isFirstNameValid
                          ? null
                          : 'Field cannot be empty',
                    ),
                    onChanged: (firstName) {
                      ref
                          .read(authorFormNotifierProvider.notifier)
                          .updateFirstName(firstName);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    initialValue: authorFormState.lastName,
                    decoration: InputDecoration(
                      labelText: 'Last name',
                      errorText: authorFormState.isLastNameValid
                          ? null
                          : 'Field cannot be empty',
                    ),
                    onChanged: authorFormNotifier.updateLastName,
                  ),
                ),
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () async {
                    if (authorFormState.isFirstNameValid &&
                        authorFormState.isLastNameValid) {
                      await authorFormNotifier.updateAuthor();
                      if (ref.read(manageAuthorsNotifierProvider).isException) {
                        await BookshelfExceptionDialog.show(
                          context,
                          ref.read(manageAuthorsNotifierProvider).getException!,
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
        );
      },
    );
  }

  Future<void> _onAuthorDeleteTap(
    WidgetRef ref,
    BuildContext context,
    int index,
  ) async {
    final getAuthorsState = ref.read(getAuthorsNotifierProvider);
    final manageAuthorsNotifier =
        ref.read(manageAuthorsNotifierProvider.notifier);

    await manageAuthorsNotifier.delete(getAuthorsState.authors[index].id);
    if (ref.read(manageAuthorsNotifierProvider).isException) {
      await BookshelfExceptionDialog.show(
        context,
        ref.read(manageAuthorsNotifierProvider).getException!,
        () {
          Navigator.of(context).pop();
        },
      );
    }
  }
}
