import 'package:freezed_annotation/freezed_annotation.dart';

part 'command_prompt_state.freezed.dart';

@freezed
class CommandPromptState with _$CommandPromptState {
  const factory CommandPromptState({
    required String lastMessage,
    required bool isWorking,
  }) = _CommandPromptState;

  factory CommandPromptState.initial() => const CommandPromptState(
        lastMessage:
            '[BookShelf v1] database initialized \ntype "/help" for more information',
        isWorking: false,
      );
}
