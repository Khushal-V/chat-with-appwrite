part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class CreateNewChatEvent extends ChatEvent {
  final CreateNewChat chat;

  CreateNewChatEvent({required this.chat});
}

class SnedTextMessageEvent extends ChatEvent {
  final Messages messages;

  SnedTextMessageEvent({
    required this.messages,
  });
}

class SendFileMessageEvent extends ChatEvent {
  final String filePath;

  SendFileMessageEvent({required this.filePath});
}

class SelectChatImageEvent extends ChatEvent {}

class UpdateSelectChatImageEvent extends ChatEvent {
  final List<XFile> files;

  UpdateSelectChatImageEvent({required this.files});
}

class RemoveSelectedImageEvent extends ChatEvent {
  final XFile file;

  RemoveSelectedImageEvent({required this.file});
}

class UpdateNewChatMessageEvent extends ChatEvent {
  final Messages payload;

  UpdateNewChatMessageEvent({required this.payload});
}

class UpdateLastChatMessageEvent extends ChatEvent {
  final Messages messages;

  UpdateLastChatMessageEvent({required this.messages});
}

class DeleteSelectedMessagesEvent extends ChatEvent {
  final List<Messages> messages;

  DeleteSelectedMessagesEvent({required this.messages});
}
