import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/constants/constants.dart';
import 'package:my_chat/custom_widgets/image_picker_view.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/services/auth_service.dart';
import 'package:my_chat/utils/widget_helpers.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthService authService;
  ProfileBloc({required this.authService}) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {});
    on<LogoutCurrentUserEvent>(_logoutCurrentUser);
    on<UpdatePasswordEvent>(_updatePassword);
    on<UpdateUserProfileEvent>(_updateUserProfile);
    on<SelectUserImageEvent>(_selectUserImage);
    on<UpdateUserImageEvent>((event, emit) =>
        emit(UpdateUserImageState(selectedImage: event.selectedImage)));
  }

  //Khushal: Logout user flow
  _logoutCurrentUser(
      LogoutCurrentUserEvent event, Emitter<ProfileState> emit) async {
    emit(LogoutCurrentUserBusyState());
    try {
      await authService.deleteCurrentSession();
      emit(LogoutCurrentUserSuccessState());
    } catch (e) {
      WidgetHelpers.showSnackbar(msg: e.toString(), isError: true);
      emit(LogoutCurrentUserFailureState(error: e.toString()));
    }
  }

  //Khushal: Update user password flow
  _updatePassword(UpdatePasswordEvent event, Emitter<ProfileState> emit) async {
    emit(UpdatePasswordBusyState());
    try {
      //Khushal: Validate user password flow
      if (event.oldPassword.isEmpty) {
        return emit(UpdatePasswordFailureState(
            error: AppErrors.oldPasswordCanNotEmpty));
      } else if (event.password.isEmpty) {
        return emit(UpdatePasswordFailureState(
            error: AppErrors.newPasswordCanNotEmpty));
      } else if (event.confirmPassword.isEmpty) {
        return emit(UpdatePasswordFailureState(
            error: AppErrors.confirmPasswordCanNotEmpty));
      } else if (event.confirmPassword != event.password) {
        return emit(UpdatePasswordFailureState(
            error: AppErrors.newPasswordAndCPasswordNotMatch));
      }
      //Khushal: Calling update password api
      await authService.updatePassword(event.password, event.oldPassword);

      //Khushal: Show message that password updated
      WidgetHelpers.showSnackbar(
          msg: AppMessages.passwordUpdatedSuccessfully, isError: false);
      emit(UpdatePasswordSuccessState());
    } catch (e) {
      //Khushal: Show error if any occured
      emit(UpdatePasswordFailureState(error: e.toString()));
    }
  }

  //Khushal: Update user profile flow
  _updateUserProfile(
      UpdateUserProfileEvent event, Emitter<ProfileState> emit) async {
    emit(UpdateProfileBusyState());
    try {
      //Khushal: Validate user profile inputs
      if (event.name.isEmpty) {
        return emit(
            UpdateProfileFailureState(error: AppErrors.pleaseEnterName));
      } else if (event.name == AppWriteService.user?.name &&
          event.selectedFile == null) {
        return emit(
            UpdateProfileFailureState(error: AppMessages.noAnyChangesDetect));
      }

      //Khushal: Get current user
      AuthUser user = AppWriteService.user!;

      //Khushal: Check user have select new profile pic
      if (event.selectedFile != null) {
        //Khushal: Update user new profile pic
        String fileId =
            await authService.uploadProfileImage(event.selectedFile!.path);

        //Khushal: Delete old profile pic from storage
        if (user.profileId != null) {
          await authService.deleteUserProfile(user.profileId ?? "");
        }

        //Khushal: Update user object with new profileId
        user.profileId = fileId;

        // //Khushal: Get user profile with new profileId
        // user.profile = await authService.getUserProfilePic(fileId);
      }

      //Khushal: Update user name flow
      await authService.updateName(event.name);

      //Khushal: Update user name in to collection
      user.name = event.name;
      await authService.updateUser(user);

      //Khushal: Show message that profile updated
      WidgetHelpers.showSnackbar(
          msg: AppMessages.profileUpdatedSuccessfully, isError: false);
      emit(UpdateProfileSuccessState());
    } catch (e) {
      //Khushal: Show error if any occured
      emit(UpdateProfileFailureState(error: e.toString()));
    }
  }

  //Khushal: Select new profile pic flow
  _selectUserImage(
      SelectUserImageEvent event, Emitter<ProfileState> emit) async {
    ImagePickerView(
      (pickedFile) {
        if (pickedFile?.isNotEmpty == true) {
          add(UpdateUserImageEvent(selectedImage: pickedFile!.first));
        }
      },
      allowMultiple: false,
    ).show(Constants.navigatorKey.currentContext!);
  }
}
