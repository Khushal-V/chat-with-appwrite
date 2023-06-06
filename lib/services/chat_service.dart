import 'package:my_chat/screens/chat/models/create_new_chat.dart';
import 'package:my_chat/screens/dashboard/models/chat_list_response.dart';
import 'package:my_chat/screens/messages/models/message.dart';

abstract class ChatService {
  Future<bool> createNewChat(CreateNewChat chat);

  Future<ChatListResponse> getChatList(String? cursorAfter);

  Future<bool> updateUnReadMessageCount(
      String chatID, String userId, int count);

  Future<bool> updateLastChatMessage(Messages message);
}
