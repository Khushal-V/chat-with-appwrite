import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_chat/screens/users/models/user_list_response.dart';
import 'package:my_chat/services/users_service.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersService userService;
  UsersBloc({required this.userService}) : super(UsersInitial()) {
    on<UsersEvent>((event, emit) {});
    on<LoadUsersEvent>(_loadUsers);
  }

  //Khushal: Get all user from appwrite collection
  _loadUsers(LoadUsersEvent event, Emitter<UsersState> emit) async {
    UserListResponse userListResponse =
        await userService.getAllUsers(event.offSet);
    emit(UserLoadedSuccessState(response: userListResponse));
  }
}
