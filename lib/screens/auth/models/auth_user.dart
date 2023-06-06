import 'package:flutter/foundation.dart';

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
}
