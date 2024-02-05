import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ztp_projekt/command_prompt/controllers/command_prompt_controller.dart';

final commandPromptControllerProvider = Provider<CommandPromptController>(
  CommandPromptController.new,
  name: 'CommandPromptControllerProvider',
);

final commandPromptStreamControllerProvider =
    Provider<StreamController<String>>(
  (ref) {
    final controller = StreamController<String>();
    ref.onDispose(controller.close);
    return controller;
  },
  name: 'CommandPromptMessagesStreamProvider',
);

final commandPromptHistoryTextControllerProvider =
    Provider<TextEditingController>(
  (ref) => TextEditingController(),
  name: 'CommandPromptHistoryTextControllerProvider',
);
