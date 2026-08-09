

import 'package:directorateofculture/presentation/pages/AI/chat_message_model.dart';

abstract class AssistantState {}

class AssistantInitial extends AssistantState {}

class AssistantLoading extends AssistantState {
  final List<ChatMessageModel> messages;
  AssistantLoading(this.messages);
}

class AssistantLoaded extends AssistantState {
  final List<ChatMessageModel> messages;
  AssistantLoaded(this.messages);
}

class AssistantError extends AssistantState {
  final List<ChatMessageModel> messages;
  final String message;
  AssistantError(this.messages, this.message);
}
