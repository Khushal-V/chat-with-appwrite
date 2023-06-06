import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:appwrite/models.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/services/auth_service.dart';
import 'package:my_chat/utils/error_mixin.dart';
import 'package:my_chat/utils/hive_service.dart';

class AuthServiceImpl extends AuthService with ErrorMixin {
  @override
  Future<AuthUser?> createNewUser(AuthUser user) async {
    try {
      //Khushal: Create new user collection
      await AppWriteService.databases.createDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.userCollection,
        data: user.toJson(),
        documentId: user.id ?? "",
      );
      return user;
    } catch (e) {
      print(e.toString());
      return Future.error(handleError(e));
    }
  }

  @override
  Future<AuthUser?> getCurrentUser(String userId) async {
    try {
      //Khushal: Get current user details
      Document document = await AppWriteService.databases.getDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.userCollection,
        documentId: userId,
      );
      AuthUser authUser = AuthUser.fromJson(document.data);
      //Khushal: If user have profileId then should get profile image
      if (authUser.profileId != null) {
        Uint8List profileImage =
            await getUserProfilePic(authUser.profileId ?? "");
        authUser.profile = profileImage;
      }

      return authUser;
    } catch (e) {
      print(e.toString());
      return Future.error(handleError(e));
    }
  }

  @override
  Future<bool> deleteCurrentSession() async {
    try {
      //Khushal: Delete current loggedIn user session
      await AppWriteService.account
          .deleteSession(sessionId: HiveService().getData(HiveKey.sessionId));
      return true;
    } catch (e) {
      return Future.error(handleError(e));
    }
  }

  @override
  Future<String> uploadProfileImage(String path) async {
    try {
      //Khushal: Upload user profile pic
      File result = await AppWriteService.storage.createFile(
        bucketId: AppCredentials.profileBucketCollection,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: path),
      );
      print(result.$id);
      return result.$id;
    } catch (e) {
      print(e.toString());
      return Future.error(handleError(e));
    }
  }

  @override
  Future<User> updatePassword(String password, String oldPassword) async {
    try {
      //Khushal: Update user password
      return await AppWriteService.account
          .updatePassword(password: password, oldPassword: oldPassword);
    } catch (e) {
      print(e.toString());
      return Future.error(handleError(e));
    }
  }

  @override
  Future<User> updateName(String name) async {
    try {
      //Khushal: Update user name
      return await AppWriteService.account.updateName(name: name);
    } catch (e) {
      return Future.error(handleError(e));
    }
  }

  @override
  Future<AuthUser> updateUser(AuthUser user) async {
    try {
      //Khushal: Update user in to collectiom
      await AppWriteService.databases.updateDocument(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.userCollection,
        data: user.toJson(),
        documentId: user.id ?? "",
      );
      return user;
    } catch (e) {
      print(e.toString());
      return Future.error(handleError(e));
    }
  }

  @override
  Future<Uint8List> getUserProfilePic(String fileId) async {
    try {
      //Khushal: Get user profile pic
      return await AppWriteService.storage.getFilePreview(
        bucketId: AppCredentials.profileBucketCollection,
        fileId: fileId,
      );
    } catch (e) {
      print(e.toString());
      return Future.error(handleError(e));
    }
  }

  @override
  Future<bool> deleteUserProfile(String fileId) async {
    try {
      //Khushal: Delete user profile pic
      await AppWriteService.storage.deleteFile(
        bucketId: AppCredentials.profileBucketCollection,
        fileId: fileId,
      );
      return true;
    } catch (e) {
      print(e.toString());
      return Future.error(handleError(e));
    }
  }
}
