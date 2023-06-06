import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';

abstract class AuthService {
  Future<AuthUser?> getCurrentUser(String userId);

  Future<AuthUser?> createNewUser(AuthUser user);

  Future<bool> deleteCurrentSession();

  Future<String> uploadProfileImage(String path);

  Future<Uint8List> getUserProfilePic(String fileId);

  Future<bool> deleteUserProfile(String fileId);

  Future<User> updatePassword(String password, String oldPassword);

  Future<User> updateName(String name);

  Future<AuthUser> updateUser(AuthUser user);
}
