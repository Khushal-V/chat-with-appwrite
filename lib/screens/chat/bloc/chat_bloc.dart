import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:my_chat/constants/constants.dart';
import 'package:my_chat/custom_widgets/image_picker_view.dart';
import 'package:my_chat/screens/chat/models/create_new_chat.dart';
import 'package:my_chat/screens/messages/models/message.dart';
import 'package:my_chat/services/chat_service.dart';
import 'package:my_chat/services/messages_service.dart';
import 'package:my_chat/utils/error_mixin.dart';
import 'package:uuid/uuid.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> with ErrorMixin {
  final ChatService chatService;
  final MessagesService messagesService;
  ChatBloc({required this.chatService, required this.messagesService})
      : super(ChatInitial()) {
    on<ChatEvent>((event, emit) {});
    on<UpdateNewChatMessageEvent>(
      (event, emit) => emit(UpdateNewChatMessageState(payload: event.payload)),
    );
    on<CreateNewChatEvent>(_createNewChat);
    on<SnedTextMessageEvent>(_snedTextMessage);
    on<SelectChatImageEvent>(_selectChatImage);
    on<RemoveSelectedImageEvent>(_removeSelectedImage);
    on<UpdateLastChatMessageEvent>(_updateLastChatMessage);

    on<DeleteSelectedMessagesEvent>(_deleteSelectedMessages);

    on<UpdateSelectChatImageEvent>(
      (event, emit) => emit(SelectChatImageState(event.files)),
    );
  }

  //Khushal: Create new chat flow
  _createNewChat(CreateNewChatEvent event, Emitter<ChatState> emit) async {
    emit(CreatingNewChatBusyState());
    try {
      await chatService.createNewChat(event.chat);
      emit(CreateNewChatSuccessState());
    } catch (e) {
      //Khushal: Show error if any occured
      emit(CreateNewChatFailureState(handleError(e)));
    }
  }

  //Khushal: Send message flow
  _snedTextMessage(SnedTextMessageEvent event, Emitter<ChatState> emit) async {
    try {
      Messages messages = event.messages;
      //Khushal: Update message status to sent
      messages.status = MessageStatus.sent;
      messages.createdAt = DateTime.now().toIso8601String();
      messages.id = const Uuid().v1();

      //Khushal: Check if message have any file
      if (messages.localFiles?.isNotEmpty == true) {
        //Khushal: If message have file update message status
        messages.status = MessageStatus.sending;

        //Khushal: Update message in local to display image from path
        emit(UpdateLocalMessageState(messages: messages));
        List<String> fileIds = [];

        //Khushal: Upload message images
        for (int i = 0; i < messages.localFiles!.length; i++) {
          String fileId = await messagesService.uploadImageFile(
              messages.localFiles![i].path, "");

          fileIds.add(fileId);
        }

        //Khushal: Update message images ids
        messages.images = fileIds;
        messages.status = MessageStatus.sent;

        //Khushal: Create new message
        await messagesService.sendTextMessage(messages);
        add(UpdateLastChatMessageEvent(messages: messages));
      } else {
        emit(UpdateLocalMessageState(messages: messages));
        //Khushal: Sent new message
        await messagesService.sendTextMessage(messages);
        add(UpdateLastChatMessageEvent(messages: messages));
      }
      emit(MessageSentSuccessState());
    } catch (e) {
      emit(MessageSentFailureState(e.toString()));
    }
  }

  //Khushal: Select message image flow
  _selectChatImage(SelectChatImageEvent event, Emitter<ChatState> emit) async {
    ImagePickerView(
      allowMultiple: true,
      (pickedFile) {
        add(UpdateSelectChatImageEvent(files: pickedFile ?? []));
      },
    ).show(Constants.navigatorKey.currentContext!);
  }

  //Khushal: Remove message image flow
  _removeSelectedImage(
      RemoveSelectedImageEvent event, Emitter<ChatState> emit) async {
    emit(RemoveSelectedImageState(event.file));
  }

  //Khushal: Remove message image flow
  _updateLastChatMessage(
      UpdateLastChatMessageEvent event, Emitter<ChatState> emit) async {
    try {
      await chatService.updateLastChatMessage(event.messages);
    } catch (e) {
      emit(MessageSentFailureState(e.toString()));
    }
  }

  //Khushal: Remove message image flow
  _deleteSelectedMessages(
      DeleteSelectedMessagesEvent event, Emitter<ChatState> emit) async {
    for (Messages message in event.messages) {
      message.isDeleted = true;
      add(UpdateNewChatMessageEvent(payload: message));
    }
    messagesService.deleteMessages(event.messages);
  }
}
