import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ztp_projekt/common/shortcuts/intents/save_intent.dart';

class BookShelfShortcuts extends StatelessWidget {
  const BookShelfShortcuts({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.enter): const SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.numpadEnter): const SaveIntent(),
      },
      child: child,
    );
  }
}
