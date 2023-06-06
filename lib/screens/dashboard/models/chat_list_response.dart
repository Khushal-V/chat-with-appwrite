import 'package:my_chat/screens/chat/models/create_new_chat.dart';

class ChatListResponse {
  final int total;
  List<CreateNewChat> chats;
  final String? lastId;

  ChatListResponse({required this.total, required this.chats, this.lastId});
}
