part of 'messages_bloc.dart';

@immutable
abstract class MessagesEvent {}

class RefreshMessagesEvent extends MessagesEvent {}

class GetUserMessagesEvent extends MessagesEvent {
  final String chatId;
  final String? cursorAfter;

  GetUserMessagesEvent({
    required this.chatId,
    this.cursorAfter,
  });
}

class UpdateNewMessageEvent extends MessagesEvent {
  final Messages message;
  final String chatID;

  UpdateNewMessageEvent({required this.message, required this.chatID});
}

class UpdateLocalMessageEvent extends MessagesEvent {
  final Messages message;

  UpdateLocalMessageEvent({required this.message});
}

class UpdateMessageUnReadCountEvent extends MessagesEvent {
  final String chatID;
  final String userId;
  final int count;

  UpdateMessageUnReadCountEvent(
      {required this.userId, required this.chatID, required this.count});
}

class AddPageListnerEvent extends MessagesEvent {
  final String chatId;

  AddPageListnerEvent({required this.chatId});
}

class CreateDeleteMessageListEvent extends MessagesEvent {
  final Messages message;

  CreateDeleteMessageListEvent({required this.message});
}

class UpdateDeletedMessageListEvent extends MessagesEvent {
  final List<Messages> messages;

  UpdateDeletedMessageListEvent({required this.messages});
}
