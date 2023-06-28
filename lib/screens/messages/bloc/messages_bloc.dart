import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_chat/screens/messages/models/message.dart';
import 'package:my_chat/services/chat_service.dart';
import 'package:my_chat/services/messages_service.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final MessagesService messagesService;
  final ChatService chatService;
  MessagesBloc({required this.messagesService, required this.chatService})
      : super(MessagesState(
            pagingController: PagingController(firstPageKey: null))) {
    on<MessagesEvent>((event, emit) {});
    on<RefreshMessagesEvent>((event, emit) =>
        emit(state.copyWith(pagingController: state.pagingController)));
    on<GetUserMessagesEvent>(_getUserMessages);
    on<UpdateNewMessageEvent>(_updateNewMessage);
    on<UpdateMessageUnReadCountEvent>(_updateMessageUnReadCount);
    on<UpdateLocalMessageEvent>(_updateLocalMessage);
    on<AddPageListnerEvent>(_addPageListner);
    on<CreateDeleteMessageListEvent>(_createDeleteMessageList);
    on<UpdateDeletedMessageListEvent>(_updateDeletedMessageList);
  }

  //Khushal: Get user messages
  _getUserMessages(
      GetUserMessagesEvent event, Emitter<MessagesState> emit) async {
    try {
      //Khushal: User messages response
      MessagesResponse message =
          await messagesService.getUserMessage(event.chatId, event.cursorAfter);

      //Khushal: "message.lastId" not null then should update next page last ID
      if (message.lastId != null) {
        state.pagingController.appendPage(message.messages, message.lastId);
        state.pagingController.itemList!.toSet().toList();
      } else {
        //Khushal: "message.lastId" have null then should update last page
        state.pagingController.appendLastPage(message.messages);
      }
    } catch (e) {
      state.pagingController.appendLastPage([]);
    }
  }

  //Khushal: Add page listner to listen messages
  _addPageListner(
      AddPageListnerEvent event, Emitter<MessagesState> emit) async {
    state.pagingController.addPageRequestListener((pageKey) {
      add(GetUserMessagesEvent(cursorAfter: pageKey, chatId: event.chatId));
    });
  }

  //Khushal: Update local message while selected message have image
  _updateLocalMessage(
      UpdateLocalMessageEvent event, Emitter<MessagesState> emit) async {
    state.pagingController.itemList!.insert(0, event.message);
    add(RefreshMessagesEvent());
  }

  //Khushal: Update message list with incomming message
  _updateNewMessage(
      UpdateNewMessageEvent event, Emitter<MessagesState> emit) async {
    Messages message = event.message;
    //Khushal: Check new message status is sent and message have curent chatID
    if (message.chatId == event.chatID && message.status?.isSent == true) {
      //Khushal: Check message images
      // if (message.messageType?.isPhoto == true) {
      //   List<Uint8List> files = [];
      //   //Khushal: Get message images
      //   for (String fileId in message.images ?? []) {
      //     Uint8List file = await messagesService.getUploadedFile(fileId);
      //     files.add(file);
      //   }
      //   //Khushal: Update message images
      //   message.uploadedFile = files;
      // }

      //Khushal: Get current message from list
      Messages? allReadyMessage = state.pagingController.itemList!
          .firstWhereOrNull((element) => element.id == message.id);
      //Khushal: if "allReadyMessage" is null then insert new message
      if (allReadyMessage == null) {
        state.pagingController.itemList!.insert(0, message);
      } else {
        //Khushal: if "allReadyMessage" is not null then should update existing message
        final index = state.pagingController.itemList!
            .indexWhere((element) => element.id == message.id);
        state.pagingController.itemList![index] = message;
      }
      add(RefreshMessagesEvent());
      //Khushal: Update unread message count
      add(UpdateMessageUnReadCountEvent(
          chatID: event.chatID, userId: message.senderId!, count: 0));
    }
  }

  //Khushal: update unread message count
  _updateMessageUnReadCount(
      UpdateMessageUnReadCountEvent event, Emitter<MessagesState> emit) async {
    await chatService.updateUnReadMessageCount(
        event.chatID, event.userId, event.count);
  }

  //Khushal: update delete messages list
  _createDeleteMessageList(
      CreateDeleteMessageListEvent event, Emitter<MessagesState> emit) async {
    List<Messages> allMessages = state.deleteMessages.map((e) => e).toList();
    final Messages? existingMessage = allMessages
        .firstWhereOrNull((element) => element.id == event.message.id);
    if (existingMessage == null) {
      allMessages.add(event.message);
    } else {
      allMessages.removeWhere((element) => element.id == event.message.id);
    }
    emit(state.copyWith(
        pagingController: state.pagingController, deleteMessages: allMessages));
  }

  //Khushal: update deleted message list
  _updateDeletedMessageList(
      UpdateDeletedMessageListEvent event, Emitter<MessagesState> emit) async {
    emit(state.copyWith(
        pagingController: state.pagingController,
        deleteMessages: event.messages));
  }
}
