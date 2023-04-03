import 'package:flutter/material.dart';
import 'package:ztp_projekt/console/command_line.dart';
import 'package:ztp_projekt/explorer/widgets/authors_tab_view.dart';
import 'package:ztp_projekt/explorer/widgets/books_tab_view.dart';
import 'package:ztp_projekt/explorer/widgets/dialogs/select_or_create_database_dialog.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool databaseNotSelected = true;
  String? selectedDatabase = 'Bookshelf';

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (databaseNotSelected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDbChangeDialog(context, selectedDatabase);
      });
    }
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
                _showDbChangeDialog(context, selectedDatabase);
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
                if (databaseNotSelected)
                  const EmptyTabView()
                else
                  const BooksTabView(),
                if (databaseNotSelected)
                  const EmptyTabView()
                else
                  const AuthorsTabView(),
              ],
            ),
          ),
          const ConsoleWidget(),
        ],
      ),
    );
  }

  void _showDbChangeDialog(BuildContext context, String? selectedDatabaseName) {
    showDialog(
      context: context,
      builder: (context) => SelectOrCreateDatabaseDialog(
        selectedDatabase: selectedDatabaseName,
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
