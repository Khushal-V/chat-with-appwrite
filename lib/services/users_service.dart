import 'package:my_chat/screens/users/models/user_list_response.dart';

abstract class UsersService {
  Future<UserListResponse> getAllUsers(String? offSet);
}
