import 'package:flutter/foundation.dart';
import 'package:my_chat/services/appwirte_service.dart';

class AuthUser {
  String? name;
  String? id;
  String? email;
  String? profileId;
  Uint8List? profile;

  AuthUser({this.name, this.id, this.email, this.profileId});

  AuthUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    email = json['email'];
    profileId = json['profileId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    data['profileId'] = profileId;
    return data;
  }

  String? get profileUrl => profileId == null
      ? null
      : "https://cloud.appwrite.io/v1/storage/buckets/${AppCredentials.profileBucketCollection}/files/$profileId/view?project=${AppCredentials.projectId}&mode=admin";
}
