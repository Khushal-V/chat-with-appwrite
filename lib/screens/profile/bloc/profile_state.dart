part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class LogoutCurrentUserSuccessState extends ProfileState {}

class LogoutCurrentUserBusyState extends ProfileState {}

class LogoutCurrentUserFailureState extends ProfileState {
  final String error;

  LogoutCurrentUserFailureState({required this.error});
}

class UpdatePasswordBusyState extends ProfileState {}

class UpdatePasswordFailureState extends ProfileState {
  final String error;

  UpdatePasswordFailureState({required this.error});
}

class UpdatePasswordSuccessState extends ProfileState {}

class UpdateProfileBusyState extends ProfileState {}

class UpdateProfileFailureState extends ProfileState {
  final String error;

  UpdateProfileFailureState({required this.error});
}

class UpdateProfileSuccessState extends ProfileState {}

class UpdateUserImageState extends ProfileState {
  final XFile selectedImage;
  UpdateUserImageState({required this.selectedImage});
}
