import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:my_chat/screens/users/models/user_list_response.dart';
import 'package:my_chat/service_impl/auth_service_impl.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/services/auth_service.dart';
import 'package:my_chat/services/users_service.dart';

class UsersServiceImpl extends UsersService {
  final AuthService authService = AuthServiceImpl();
  @override
  Future<UserListResponse> getAllUsers(String? offSet) async {
    try {
      //Khushal: Get all users
      DocumentList documents = await AppWriteService.databases.listDocuments(
        databaseId: AppCredentials.databaseId,
        collectionId: AppCredentials.userCollection,
        queries: [
          Query.limit(10),
          if (offSet != null) Query.cursorAfter(offSet),
          Query.notEqual("id", AppWriteService.user?.id),
          Query.orderDesc("\$createdAt")
        ],
      );
      List<AuthUser> allAuthUsers = [];
      for (Document d in documents.documents) {
        AuthUser authUser = AuthUser.fromJson(d.data);
        //Khushal: If user have profile then should get it
        if (authUser.profileId != null) {
          authUser.profile =
              await authService.getUserProfilePic(authUser.profileId!);
        }
        allAuthUsers.add(authUser);
      }

      String? lastId =
          documents.documents.length < 10 ? null : documents.documents.last.$id;
      return UserListResponse(
          total: documents.total, lastId: lastId, users: allAuthUsers);
    } catch (e) {
      return Future.error(e);
    }
  }
}
