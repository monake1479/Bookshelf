import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/console/command_line.dart';
import 'package:ztp_projekt/database/controllers/providers.dart';
import 'package:ztp_projekt/explorer/widgets/authors_tab_view.dart';
import 'package:ztp_projekt/explorer/widgets/books_tab_view.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/add_author_dialog.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/add_book_dialog.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/select_or_create_database_dialog.dart';

class RecordsPage extends ConsumerStatefulWidget {
  const RecordsPage({super.key});

  @override
  ConsumerState<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends ConsumerState<RecordsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    if (!ref.read(databaseNotifierProvider.notifier).isDbOpened()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(databaseNotifierProvider.notifier).listAllFiles();
        _showDbChangeDialog(context);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final databaseState = ref.watch(databaseNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'BookShelf',
          style: theme.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Builder(
            builder: (context) {
              if (databaseState.isDatabaseOpened) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: TextButton.icon(
                    onPressed: () async {
                      if (_tabController.index == 0) {
                        await AddBookDialog.show(context);
                      } else {
                        await AddAuthorDialog.show(context);
                      }
                    },
                    label: Text(
                      'Add record',
                      style: TextStyle(color: colorScheme.tertiary),
                    ),
                    icon: Icon(
                      Icons.add_circle,
                      color: colorScheme.tertiary,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              label: Text(
                'Open databases folder',
                style: TextStyle(color: colorScheme.tertiary),
              ),
              icon: Icon(
                Icons.folder_rounded,
                color: colorScheme.tertiary,
              ),
              onPressed: () async {
                await ref
                    .read(databaseNotifierProvider.notifier)
                    .openDatabaseFolder();
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              label: Text(
                'Change database',
                style: TextStyle(color: colorScheme.tertiary),
              ),
              icon: Icon(
                Icons.change_circle_rounded,
                color: colorScheme.tertiary,
              ),
              onPressed: () {
                ref.read(databaseNotifierProvider.notifier).listAllFiles();
                _showDbChangeDialog(context);
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: colorScheme.secondary,
          labelColor: colorScheme.secondary,
          tabs: const [
            Tab(
              text: 'Books',
              icon: Icon(Icons.menu_book_rounded),
            ),
            Tab(
              text: 'Authors',
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Builder(
                  builder: (context) {
                    if (databaseState.isDatabaseOpened) {
                      return const BooksTabView();
                    } else {
                      return const EmptyTabView();
                    }
                  },
                ),
                Builder(
                  builder: (context) {
                    if (databaseState.isDatabaseOpened) {
                      return const AuthorsTabView();
                    } else {
                      return const EmptyTabView();
                    }
                  },
                )
              ],
            ),
          ),
          const ConsoleWidget(),
        ],
      ),
    );
  }

  void _showDbChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SelectOrCreateDatabaseDialog(),
    );
  }
}

class EmptyTabView extends StatelessWidget {
  const EmptyTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No database selected',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
