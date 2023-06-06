part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class LogoutCurrentUserEvent extends ProfileEvent {}

class UpdatePasswordEvent extends ProfileEvent {
  final String password;
  final String oldPassword;
  final String confirmPassword;

  UpdatePasswordEvent(
      {required this.password,
      required this.oldPassword,
      required this.confirmPassword});
}

class UpdateUserProfileEvent extends ProfileEvent {
  final String name;
  final XFile? selectedFile;

  UpdateUserProfileEvent({required this.name, this.selectedFile});
}

class SelectUserImageEvent extends ProfileEvent {
  SelectUserImageEvent();
}

class UpdateUserImageEvent extends ProfileEvent {
  final XFile selectedImage;
  UpdateUserImageEvent({required this.selectedImage});
}
