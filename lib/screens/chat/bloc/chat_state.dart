part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class CreatingNewChatBusyState extends ChatState {
  CreatingNewChatBusyState();
}

class CreateNewChatSuccessState extends ChatState {
  CreateNewChatSuccessState();
}

class CreateNewChatFailureState extends ChatState {
  final String error;
  CreateNewChatFailureState(this.error);
}

class MessageSentSuccessState extends ChatState {
  MessageSentSuccessState();
}

class MessageSentFailureState extends ChatState {
  final String error;
  MessageSentFailureState(this.error);
}

class SelectChatImageState extends ChatState {
  final List<XFile> files;
  SelectChatImageState(this.files);
}

class RemoveSelectedImageState extends ChatState {
  final XFile file;
  RemoveSelectedImageState(this.file);
}

class UpdateLocalMessageState extends ChatState {
  final Messages messages;
  UpdateLocalMessageState({required this.messages});
}

class UpdateNewChatMessageState extends ChatState {
  final Messages payload;

  UpdateNewChatMessageState({required this.payload});
}
