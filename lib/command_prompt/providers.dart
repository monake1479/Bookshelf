import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/controllers/command_prompt_notifier.dart';
import 'package:ztp_projekt/command_prompt/controllers/command_prompt_state.dart';

final commandPromptNotifierProvider = StateNotifierProvider.autoDispose<
    CommandPromptNotifier, CommandPromptState>(
  (ref) {
    final notifier = CommandPromptNotifier(ref);
    ref.keepAlive();
    return notifier;
  },
  name: 'CommandPromptNotifierProvider',
);

final commandPromptHistoryTextControllerProvider =
    Provider<TextEditingController>(
  (ref) => TextEditingController(),
  name: 'CommandPromptHistoryTextControllerProvider',
);
