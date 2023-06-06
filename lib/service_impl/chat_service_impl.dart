import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:my_chat/screens/chat/models/create_new_chat.dart';
import 'package:my_chat/screens/dashboard/models/chat_list_response.dart';
import 'package:my_chat/screens/messages/models/message.dart';
import 'package:my_chat/service_impl/auth_service_impl.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/services/auth_service.dart';
import 'package:my_chat/services/chat_service.dart';
import 'package:my_chat/utils/error_mixin.dart';

class ChatServiceImpl extends ChatService with ErrorMixin {
  final AuthService authService = AuthServiceImpl();

  @override
  Future<bool> createNewChat(CreateNewChat chat) async {
    try {
      //Khushal: Check chat id already existing
      await AppWriteService.databases.getDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.chatCollection,
        documentId: chat.id!,
      );
      return true;
    } catch (e) {
      print(e.toString());
      if (e is AppwriteException) {
        if (e.code == 404) {
          //Khushal If chat dose not exist then should create new
          await AppWriteService.databases.createDocument(
            databaseId: AppCredentials.databaseId,
            collectionId: AppCredentials.chatCollection,
            data: chat.toJson(),
            documentId: chat.id!,
          );
          return Future.value(true);
        } else if (e.code == 409) {
          return Future.value(true);
        }
      }
      return Future.error(handleError(e));
    }
  }

  @override
  Future<ChatListResponse> getChatList(String? cursorAfter) async {
    try {
      //Khushal: Get user chat list
      DocumentList documents = await AppWriteService.databases.listDocuments(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.chatCollection,
        queries: [
          Query.orderDesc("\$updatedAt"),
          Query.limit(10),
          if (cursorAfter != null) Query.cursorAfter(cursorAfter),
        ],
      );
      List<CreateNewChat> chats = [];
      for (Document d in documents.documents) {
        CreateNewChat chat = CreateNewChat.fromJson(d.data);
        if (chat.users!.contains(AppWriteService.user?.id) &&
            chat.lastMessage != null) {
          //Khushal: Get chat user details
          AuthUser? authUser = await authService.getCurrentUser(chat.users!
              .firstWhere((element) => element != AppWriteService.user?.id));

          chat.chatUser = authUser;
          chats.add(chat);
        }
      }
      String? lastId =
          documents.documents.length < 10 ? null : documents.documents.last.$id;
      return ChatListResponse(
          total: documents.total, chats: chats, lastId: lastId);
    } catch (e) {
      print(e.toString());
      return ChatListResponse(chats: [], total: 0);
    }
  }

  @override
  Future<bool> updateUnReadMessageCount(
      String chatID, String userId, int count) async {
    try {
      //Khushal: Get chat document based on chatID
      Document document = await AppWriteService.databases.getDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.chatCollection,
        documentId: chatID,
      );

      CreateNewChat chat = CreateNewChat.fromJson(document.data);

      //Khushal: Update unread message count
      if (chat.unreadCount == null) {
        chat.unreadCount = {userId: count};
      } else {
        chat.unreadCount![userId] = count;
      }

      //Khushal: Update same doucment with updated unread count
      await AppWriteService.databases.updateDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.chatCollection,
        documentId: chatID,
        data: chat.toJson(),
      );
      return true;
    } catch (e) {
      return Future.error(handleError(e));
    }
  }

  @override
  Future<bool> updateLastChatMessage(Messages message) async {
    try {
      await Future.wait([Future.delayed(const Duration(milliseconds: 500))]);
      //Khushal: Get current user chat
      Document document = await AppWriteService.databases.getDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.chatCollection,
        documentId: message.chatId ?? "",
      );

      CreateNewChat chat = CreateNewChat.fromJson(document.data);

      //Khushal: Update last message of chat object
      chat.lastMessage = message.message;
      chat.lastMessageType = message.messageType;

      //Khushal: Update message unread count
      if (chat.unreadCount == null && chat.unreadCount?.isNotEmpty == true) {
        chat.unreadCount = {message.receiverId!: 1, message.senderId!: 0};
      } else {
        chat.unreadCount![message.receiverId!] =
            chat.unreadCount![message.receiverId!] + 1;
        chat.unreadCount![message.senderId!] = 0;
      }

      //Khushal: Update chat with latest last messages nad unread count
      await Future.wait([Future.delayed(const Duration(milliseconds: 500))]);
      await AppWriteService.databases.updateDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.chatCollection,
        data: chat.toJson(),
        documentId: message.chatId ?? "",
      );
      return true;
    } catch (e) {
      return Future.error(handleError(e));
    }
  }
}
