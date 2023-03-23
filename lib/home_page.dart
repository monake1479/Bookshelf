import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/manage_database/controllers/providers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final manageDatabaseNotifier =
            ref.watch(manageDatabaseNotifierProvider.notifier);
        final getDatabaseNotifier =
            ref.watch(getDatabaseNotifierProvider.notifier);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bookshelf system'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await manageDatabaseNotifier.insertAuthor();
                  },
                  child: const Text('Insert Book'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await getDatabaseNotifier.getBooks();
                  },
                  child: const Text('Show Books'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Insert Author'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await getDatabaseNotifier.getAuthors();
                  },
                  child: const Text('Show Authors'),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await ref.read(getDatabaseNotifierProvider.notifier).getBooks();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
