import 'package:flutter/material.dart';
import 'package:ztp_projekt/console/command_line.dart';
import 'package:ztp_projekt/explorer/widgets/record_actions.dart';
import 'package:ztp_projekt/explorer/widgets/record_header_cell.dart';
import 'package:ztp_projekt/explorer/widgets/records_row.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('BookShelf'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
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
                        iconColor: colorScheme.primary.withOpacity(0.3),
                        selectedIconColor: colorScheme.primary,
                        onChanged: print,
                      ),
                      RecordHeaderCell.static(
                        title: 'Author',
                        textStyle: theme.textTheme.titleMedium!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RecordHeaderCell.static(
                        title: 'Publisher',
                        textStyle: theme.textTheme.titleMedium!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RecordHeaderCell(
                        title: 'Publication Date',
                        textStyle: theme.textTheme.titleMedium!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        iconColor: colorScheme.primary.withOpacity(0.3),
                        selectedIconColor: colorScheme.primary,
                        onChanged: print,
                      ),
                      RecordHeaderCell.static(
                        title: 'ISBN',
                        textStyle: theme.textTheme.titleMedium!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RecordHeaderCell(
                        title: 'Price',
                        textStyle: theme.textTheme.titleMedium!.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        iconColor: colorScheme.primary.withOpacity(0.3),
                        selectedIconColor: colorScheme.primary,
                        onChanged: print,
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => RecordsRow(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      children: [
                        const Text('Name'),
                        const Text('Author'),
                        const Text('Publisher'),
                        const Text('Publication Date'),
                        const Text('ISBN'),
                        const Text('Price'),
                        RecordActions(),
                      ],
                    ),
                    childCount: 30,
                  ),
                ),
              ],
            ),
          ),
          const ConsoleWidget(),
        ],
      ),
    );
  }
}
