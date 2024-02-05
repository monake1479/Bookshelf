import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/authors/controllers/providers.dart';
import 'package:ztp_projekt/books/controllers/providers.dart';
import 'package:ztp_projekt/console/command_line.dart';
import 'package:ztp_projekt/database/controllers/providers.dart';
import 'package:ztp_projekt/explorer/models/current_tab_enum.dart';
import 'package:ztp_projekt/explorer/pages/authors_page.dart';
import 'package:ztp_projekt/explorer/pages/books_page.dart';
import 'package:ztp_projekt/explorer/providers.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/add_author_dialog.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/add_book_dialog.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/select_or_create_database_dialog.dart';

const recordsBodyKey = Key('recordsBodyKey');

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
    ref.read(recordsStreamControllerProvider).stream.listen((event) {
      if (event == CurrentTab.books) {
        _tabController.animateTo(0);
      } else {
        _tabController.animateTo(1);
      }
    });
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref.read(sortNotifierProvider.notifier).reset();
        ref.read(sortAuthorsNotifierProvider.notifier).resetSortingCriteria();
        ref.read(sortBooksNotifierProvider.notifier).resetSortingCriteria();
      }
    });
    if (!ref.read(databaseNotifierProvider.notifier).isDbOpened()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(databaseNotifierProvider.notifier).listAllFiles();
        SelectOrCreateDatabaseDialog.show(context);
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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Text(
                    'BookShelf',
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'v1.0.0',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Authors:',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Dominik Edgar Szpilski 147915',
                    style: theme.textTheme.bodySmall!.copyWith(),
                  ),
                  Text(
                    'Daniel Obłąk 147916',
                    style: theme.textTheme.bodySmall!.copyWith(),
                  ),
                ],
              ),
            ),
            //open database folder
            ListTile(
              title: Text(
                'Open database folder',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: colorScheme.tertiary,
                ),
              ),
              onTap: () async {
                await ref
                    .read(databaseNotifierProvider.notifier)
                    .openDatabaseFolder();
              },
              leading: Icon(
                Icons.folder_rounded,
                color: colorScheme.tertiary,
              ),
            ),
            ListTile(
              title: Text(
                'Change database',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: colorScheme.tertiary,
                ),
              ),
              onTap: () async {
                await ref
                    .read(databaseNotifierProvider.notifier)
                    .listAllFiles();
                if (mounted) {
                  await SelectOrCreateDatabaseDialog.show(context);
                }
              },
              leading: Icon(
                Icons.change_circle_rounded,
                color: colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        title: Text(
          'BookShelf',
          style: theme.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: colorScheme.tertiary),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              label: Text(
                'Add record',
                style: TextStyle(color: colorScheme.tertiary),
              ),
              icon: Icon(
                Icons.add_circle,
                color: colorScheme.tertiary,
              ),
              onPressed: () async {
                if (_tabController.index == 0) {
                  await AddBookDialog.show(context);
                } else {
                  await AddAuthorDialog.show(context);
                }
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
            key: recordsBodyKey,
            child: TabBarView(
              controller: _tabController,
              children: [
                Builder(
                  builder: (context) {
                    if (databaseState.isDatabaseOpened) {
                      return const BooksPage();
                    } else {
                      return const EmptyTabView();
                    }
                  },
                ),
                Builder(
                  builder: (context) {
                    if (databaseState.isDatabaseOpened) {
                      return const AuthorsPage();
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
