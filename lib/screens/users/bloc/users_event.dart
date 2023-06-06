part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class LoadUsersEvent extends UsersEvent {
  final String? offSet;

  LoadUsersEvent({this.offSet});
}
