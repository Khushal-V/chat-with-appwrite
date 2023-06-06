import 'package:flutter/foundation.dart';
import 'package:my_chat/screens/messages/models/message.dart';

abstract class MessagesService {
  Future<bool> updateTextMessage(Messages messages);

  Future<MessagesResponse> getUserMessage(String chatID, String? cursorAfter);

  Future<Uint8List> getUploadedFile(String fileId);

  Future<String> sendTextMessage(Messages messages);

  Future<String> uploadImageFile(String filePath, String fileId);

  Future<bool> deleteMessages(List<Messages> messages);
}
