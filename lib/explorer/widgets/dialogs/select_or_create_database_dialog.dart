// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/common/widgets/bookshelf_exception_dialog.dart';
import 'package:ztp_projekt/database/controllers/database_state.dart';
import 'package:ztp_projekt/database/controllers/providers.dart';

class SelectOrCreateDatabaseDialog extends StatefulWidget {
  const SelectOrCreateDatabaseDialog({
    super.key,
  });

  @override
  State<SelectOrCreateDatabaseDialog> createState() =>
      _SelectOrCreateDatabaseDialogState();
}

class _SelectOrCreateDatabaseDialogState
    extends State<SelectOrCreateDatabaseDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool creationMode = false;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      setState(() {
        creationMode = _tabController.index == 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          AnimatedOpacity(
            opacity: creationMode ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: creationMode
                  ? () {
                      _tabController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 200),
                      );
                    }
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: Text(
              creationMode ? 'Create new database' : 'Select a database',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      content: SizedBox(
        height: 150,
        width: 300,
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _SelectDatabaseWidget(
              onCreateTap: () {
                setState(() {
                  creationMode = true;
                });
                _tabController.animateTo(
                  1,
                  duration: const Duration(milliseconds: 200),
                );
              },
            ),
            const _CreateDatabaseWidget(),
          ],
        ),
      ),
    );
  }
}

class _CreateDatabaseWidget extends StatefulWidget {
  const _CreateDatabaseWidget();

  @override
  State<_CreateDatabaseWidget> createState() => _CreateDatabaseWidgetState();
}

class _CreateDatabaseWidgetState extends State<_CreateDatabaseWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer(
      builder: (context, ref, child) {
        final databaseNotifier = ref.watch(databaseNotifierProvider.notifier);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'What should we call your new database?',
              style: theme.textTheme.labelLarge,
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Database name',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      await databaseNotifier.create(_controller.text);
                      if (ref.read(databaseNotifierProvider).isException) {
                        await BookshelfExceptionDialog.show(
                          context,
                          ref.read(databaseNotifierProvider).getException!,
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                  label: const Text('Create'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class _SelectDatabaseWidget extends StatelessWidget {
  const _SelectDatabaseWidget({
    required this.onCreateTap,
  });

  final void Function() onCreateTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Consumer(
      builder: (context, ref, child) {
        final databaseState = ref.watch(databaseNotifierProvider);
        final databaseNotifier = ref.watch(databaseNotifierProvider.notifier);
        if (databaseState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (databaseState.databaseList.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: databaseState.databaseList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      selected: databaseNotifier.getDatabasePath() ==
                          databaseState.databaseList[index].toLowerCase(),
                      leading: const Icon(
                        Icons.file_open,
                      ),
                      title: Text(databaseState.databasesNames[index]),
                      onTap: () async {
                        await databaseNotifier
                            .open(databaseState.databasesNames[index]);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.add_circle_rounded,
                  color: colorScheme.tertiary,
                ),
                title: const Text('Create new database'),
                onTap: onCreateTap,
              )
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ListTile(
                leading: Icon(
                  Icons.folder_off_rounded,
                ),
                title: Text('Database folder is empty.'),
              ),
              ListTile(
                leading: Icon(
                  Icons.add_circle_rounded,
                  color: colorScheme.tertiary,
                ),
                title: const Text('Create new database'),
                onTap: onCreateTap,
              )
            ],
          );
        }
      },
    );
  }
}
