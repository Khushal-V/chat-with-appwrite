import 'dart:convert';

import 'package:my_chat/configs/base_response.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:my_chat/screens/messages/models/message.dart';
import 'package:my_chat/utils/extensions.dart';

class CreateNewChat extends BaseResponse {
  String? lastMessage;
  MessageTypes? lastMessageType;
  List<String>? users;
  AuthUser? chatUser;
  Map<String, dynamic>? unreadCount;

  CreateNewChat(
      {this.lastMessage,
      required this.users,
      this.chatUser,
      this.unreadCount,
      this.lastMessageType});

  CreateNewChat copyWith({
    String? lastMessage,
    MessageTypes? lastMessageType,
    List<String>? users,
    AuthUser? chatUser,
    Map<String, dynamic>? unreadCount,
  }) {
    return CreateNewChat(
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      users: users ?? this.users,
      chatUser: chatUser ?? this.chatUser,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  CreateNewChat.fromJson(Map<String, dynamic> json) : super.fromMap(json) {
    if (json.containsKey("data")) {
      json = json["data"];
    }
    users = json['users'].cast<String>();
    lastMessage = json['lastMessage'];
    if (json['unreadCount'] != null) {
      unreadCount = jsonDecode(json['unreadCount']);
    }
    lastMessageType = json['lastMessageType']
        .toString()
        .toEnum<MessageTypes>(MessageTypes.values);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lastMessage'] = lastMessage;
    data['users'] = users;
    data['unreadCount'] = jsonEncode(unreadCount);
    data['lastMessageType'] = lastMessageType?.name;
    return data;
  }
}
