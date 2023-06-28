import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat/configs/base_response.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/utils/extensions.dart';

class MessagesResponse {
  final int total;
  List<Messages> messages;
  final String? lastId;

  MessagesResponse({required this.total, required this.messages, this.lastId});
}

class Messages extends BaseResponse {
  String? chatId;
  String? senderId;
  String? receiverId;
  String? message;
  MessageStatus? status;
  List<String>? images;
  MessageTypes? messageType;
  List<XFile>? localFiles;
  List<Uint8List>? uploadedFile;
  bool? isDeleted;

  Messages({
    this.chatId,
    this.senderId,
    this.message,
    this.messageType,
    this.receiverId,
    this.images = const [],
    this.status,
    this.localFiles,
    this.uploadedFile,
    this.isDeleted,
  });

  Messages.fromJson(Map<String, dynamic> json) : super.fromMap(json) {
    if (json.containsKey("data")) {
      json = json['data'];
    }

    chatId = json['chatId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = json['message'];
    messageType = json['messageType']
        .toString()
        .toEnum<MessageTypes>(MessageTypes.values);
    images = json['imageIds'].cast<String>();
    status =
        json['status'].toString().toEnum<MessageStatus>(MessageStatus.values);
    isDeleted = json["isDeleted"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['message'] = message;
    data['messageType'] = messageType?.name;
    data['imageIds'] = images!.map((e) => e.toString()).toList();
    data['status'] = status?.name;
    data["isDeleted"] = isDeleted;
    return data;
  }

  bool get isCurrentUser => senderId == AppWriteService.user?.id;

  List<String> get imageUrls =>
      images
          ?.map((e) =>
              "https://cloud.appwrite.io/v1/storage/buckets/${AppCredentials.bucketCollection}/files/$e/view?project=${AppCredentials.projectId}&mode=admin")
          .toList() ??
      [];
}

enum MessageTypes {
  text,
  photo,
  video,
}

enum MessageStatus {
  sent,
  sending,
  failed,
}

extension MessageStatusHelpers on MessageStatus {
  bool get isSent => this == MessageStatus.sent;
  bool get isSending => this == MessageStatus.sending;
  bool get isFailed => this == MessageStatus.failed;
}

extension MessageTypesHelpers on MessageTypes {
  bool get isText => this == MessageTypes.text;
  bool get isPhoto => this == MessageTypes.photo;
  bool get isVideo => this == MessageTypes.video;
}
