part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoadingBusyState extends UsersState {}

class UserLoadedSuccessState extends UsersState {
  final UserListResponse response;

  UserLoadedSuccessState({required this.response});
}
