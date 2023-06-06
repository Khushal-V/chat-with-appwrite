part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class UserLoginBusyState extends AuthState {}

class UserLoginSuccessState extends AuthState {}

class UserLoginFailureState extends AuthState {
  final String error;

  UserLoginFailureState({required this.error});
}

class UserRegistrationBusyState extends AuthState {}

class UserRegistrationSuccessState extends AuthState {}

class UserRegistrationFailureState extends AuthState {
  final String error;

  UserRegistrationFailureState({required this.error});
}

class UpdateUserImageState extends AuthState {
  final XFile selectedImage;
  UpdateUserImageState({required this.selectedImage});
}
