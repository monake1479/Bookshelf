import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/database/controllers/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<bool> future;
  @override
  void initState() {
    future = initialize(ref);
    super.initState();
  }

  Future<bool> initialize(
    WidgetRef ref,
  ) async {
    // return ref.read(databaseNotifierProvider.notifier).checkIsDatabaseMounted();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final databaseNotifier = ref.watch(databaseNotifierProvider.notifier);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bookshelf system'),
          ),
          body: FutureBuilder<bool>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.connectionState == ConnectionState.done) {
                return Text('Snapshot.data: ${snapshot.data}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await databaseNotifier.listAllFiles();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
