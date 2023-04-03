import 'package:flutter/material.dart';

class SelectOrCreateDatabaseDialog extends StatefulWidget {
  const SelectOrCreateDatabaseDialog({super.key, this.selectedDatabase});

  final String? selectedDatabase;

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
              selectedDatabase: widget.selectedDatabase,
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

class _CreateDatabaseWidget extends StatelessWidget {
  const _CreateDatabaseWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'What should we call your new database?',
          style: theme.textTheme.labelLarge,
        ),
        const TextField(
          decoration: InputDecoration(
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
              onPressed: () {
                Navigator.pop(context);
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
  }
}

class _SelectDatabaseWidget extends StatelessWidget {
  const _SelectDatabaseWidget({
    required this.onCreateTap,
    required this.selectedDatabase,
  });

  final void Function() onCreateTap;
  final String? selectedDatabase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        ListTile(
          selected: 'Bookshelf' == selectedDatabase,
          leading: const Icon(
            Icons.file_open,
          ),
          title: const Text('Bookshelf'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.file_open,
          ),
          title: const Text('Bookshelf2'),
          onTap: () {
            Navigator.of(context).pop();
          },
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
}
