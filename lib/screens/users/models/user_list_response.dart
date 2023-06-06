import 'package:my_chat/screens/auth/models/auth_user.dart';

class UserListResponse {
  final int total;
  final String? lastId;
  final List<AuthUser> users;

  UserListResponse({required this.total, required this.users, this.lastId});
}
