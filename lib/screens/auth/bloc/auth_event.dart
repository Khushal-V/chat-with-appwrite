part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class UserLoginEvent extends AuthEvent {
  final LoginRequest request;

  UserLoginEvent({required this.request});
}

class UserRegistrationEvent extends AuthEvent {
  final RegistrationRequest request;
  final XFile? selectProfile;

  UserRegistrationEvent({
    required this.request,
    this.selectProfile,
  });
}

class SelectUserImageEvent extends AuthEvent {
  SelectUserImageEvent();
}

class UpdateUserImageEvent extends AuthEvent {
  final XFile selectedImage;
  UpdateUserImageEvent({required this.selectedImage});
}
