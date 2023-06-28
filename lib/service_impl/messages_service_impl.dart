import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:my_chat/screens/messages/models/message.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/services/messages_service.dart';
import 'package:my_chat/utils/error_mixin.dart';

class MessagesServiceImpl extends MessagesService with ErrorMixin {
  @override
  Future<MessagesResponse> getUserMessage(
      String chatID, String? cursorAfter) async {
    try {
      //Khushal: Get user messages list
      DocumentList documents = await AppWriteService.databases.listDocuments(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.messagesCollection,
        queries: [
          Query.equal("chatId", chatID),
          Query.orderDesc("\$createdAt"),
          Query.limit(10),
          if (cursorAfter != null) Query.cursorAfter(cursorAfter),
        ],
      );
      // Completer<MessagesResponse> messagesCompleter =
      //     Completer<MessagesResponse>();
      // List<Future<Messages>> messages =
      //     await documents.documents.map((e) async {
      //   Messages messages = Messages.fromJson(e.toMap());
      //   //Khushal: If message type photo then should get message images
      //   if (messages.messageType?.isPhoto == true) {
      //     messages.uploadedFile = [];
      //     for (String fileId in messages.images ?? []) {
      //       try {
      //         Uint8List file = await getUploadedFile(fileId);
      //         messages.uploadedFile!.add(file);
      //       } catch (e) {}
      //     }
      //   }
      //   return messages;
      // }).toList();
      // List<Messages> allMessages = await Future.wait(await messages);
      List<Messages> allMessages =
          documents.documents.map((e) => Messages.fromJson(e.toMap())).toList();
      String? lastId =
          documents.documents.length < 10 ? null : documents.documents.last.$id;
      return MessagesResponse(
          messages: allMessages, total: documents.total, lastId: lastId);
      // messagesCompleter.complete(MessagesResponse(
      //     messages: allMessages, total: documents.total, lastId: lastId));
      // return messagesCompleter.future;
    } catch (e) {
      print(e.toString());
      return Future.value(
          MessagesResponse(messages: [], total: 0, lastId: null));
    }
  }

  @override
  Future<bool> updateTextMessage(Messages messages) async {
    try {
      //Khushal: Update text message
      await AppWriteService.databases.updateDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.messagesCollection,
        data: messages.toJson(),
        documentId: messages.id ?? "",
      );
      return true;
    } catch (e) {
      return Future.error(handleError(e));
    }
  }

  @override
  Future<Uint8List> getUploadedFile(String fileId) async {
    try {
      //Khushal: Get message uploaded file
      Uint8List result = await AppWriteService.storage.getFileView(
        bucketId: AppCredentials.bucketCollection,
        fileId: fileId,
      );
      return result;
    } catch (e) {
      return Future.error(handleError(e));
    }
  }

  @override
  Future<String> uploadImageFile(String filePath, String fileId) async {
    try {
      //Khushal: Upload message image
      File result = await AppWriteService.storage.createFile(
        bucketId: AppCredentials.bucketCollection,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: filePath),
      );
      print(result.$id);
      return result.$id;
    } catch (e) {
      print(e.toString());
      return Future.error(handleError(e));
    }
  }

  @override
  Future<String> sendTextMessage(Messages messages) async {
    try {
      //Khushal: Create new message
      Document createDoc = await AppWriteService.databases.createDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.messagesCollection,
        data: messages.toJson(),
        documentId: messages.id ?? "",
      );

      return createDoc.$id;
    } catch (e) {
      print(e.toString());
      return Future.value(handleError(e));
    }
  }

  @override
  Future<bool> deleteMessages(List<Messages> messages) async {
    for (Messages message in messages) {
      if (message.images?.isNotEmpty == true) {
        for (String imageId in message.images ?? []) {
          try {
            //Khushal: Upload message image
            await AppWriteService.storage.deleteFile(
              bucketId: AppCredentials.bucketCollection,
              fileId: imageId,
            );
          } catch (e) {
            print(e.toString());
          }
        }
      }

      try {
        //Khushal: Create new message
        message.isDeleted = true;
        message.message = "";
        message.images = [];
        await AppWriteService.databases.updateDocument(
          databaseId: AppCredentials.databaseId,
          collectionId: AppCredentials.messagesCollection,
          data: message.toJson(),
          documentId: message.id ?? "",
        );
      } catch (e) {
        print(e.toString());
      }
    }
    return true;
  }
}
