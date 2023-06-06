import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/constants/constants.dart';
import 'package:my_chat/custom_widgets/image_picker_view.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:my_chat/screens/auth/models/login_request.dart';
import 'package:my_chat/screens/auth/models/registration_request.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/services/auth_service.dart';
import 'package:my_chat/utils/error_mixin.dart';
import 'package:my_chat/utils/hive_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with ErrorMixin {
  final AuthService authService;
  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});

    on<UserLoginEvent>(_userLogin);
    on<UserRegistrationEvent>(_userRegistration);
    on<SelectUserImageEvent>(_selectUserImage);
    on<UpdateUserImageEvent>((event, emit) =>
        emit(UpdateUserImageState(selectedImage: event.selectedImage)));
  }

  //Khushal: User login flow
  _userLogin(UserLoginEvent event, Emitter<AuthState> emit) async {
    //Khushal: Validate uset input fields and return errors
    if (event.request.email.isEmpty) {
      return emit(UserLoginFailureState(error: AppErrors.pleaseEnterEmail));
    } else if (event.request.password.isEmpty) {
      return emit(UserLoginFailureState(error: AppErrors.pleaseEnterPassword));
    } else {
      emit(UserLoginBusyState());
      try {
        //Khushal: Create new email session
        Session session = await AppWriteService.account.createEmailSession(
            email: event.request.email, password: event.request.password);

        //Khushal: Store session ID to Hive DB, will use while user logout
        HiveService().addData(HiveKey.sessionId, session.$id);

        //Khushal: Get current user details based on userId
        AppWriteService.user = await authService.getCurrentUser(session.userId);

        emit(UserLoginSuccessState());
      } catch (e) {
        //Khushal: Show error if any error occured
        emit(UserLoginFailureState(error: handleError(e)));
      }
    }
  }

  //Khushal: Select user profile pic flow
  _selectUserImage(SelectUserImageEvent event, Emitter<AuthState> emit) async {
    ImagePickerView(
      (pickedFile) {
        if (pickedFile?.isNotEmpty == true) {
          add(UpdateUserImageEvent(selectedImage: pickedFile!.first));
        }
      },
      allowMultiple: false,
    ).show(Constants.navigatorKey.currentContext!);
  }

  //Khushal: User registration flow
  _userRegistration(
      UserRegistrationEvent event, Emitter<AuthState> emit) async {
    emit(UserRegistrationBusyState());
    try {
      //Khushal: Validate uset input fields and return errors
      if (event.request.name.isEmpty == true) {
        return emit(
            UserRegistrationFailureState(error: AppErrors.userNameCanNotEmpty));
      } else if (event.request.email.isEmpty == true) {
        return emit(
            UserRegistrationFailureState(error: AppErrors.emailCanNotEmpty));
      } else if (event.request.password.isEmpty == true) {
        return emit(
            UserRegistrationFailureState(error: AppErrors.passwordCanNotEmpty));
      } else if (event.request.confirmPassword.isEmpty == true) {
        return emit(UserRegistrationFailureState(
            error: AppErrors.confirmPasswordCanNotEmpty));
      } else if (event.request.confirmPassword != event.request.password) {
        return emit(UserRegistrationFailureState(
            error: AppErrors.passwordAndCPasswordNotMatch));
      }

      //Khushal: Create new user to Appwrite account
      final User user = await AppWriteService.account.create(
        userId: ID.unique(),
        email: event.request.email,
        password: event.request.password,
        name: event.request.name,
      );

      //Khushal: Creating user object to save collection
      AuthUser authUser = AuthUser(
        email: event.request.email,
        id: user.$id,
        name: event.request.name,
      );

      //Khushal: If user have select profile pic then should upload it to storage
      if (event.selectProfile != null) {
        String profile =
            await authService.uploadProfileImage(event.selectProfile!.path);
        authUser.profileId = profile;
      }

      //Khushal: Adding user entry in to collection
      await authService.createNewUser(
        authUser,
      );
      emit(UserRegistrationSuccessState());
    } catch (e) {
      //Khushal: Show error if any error occured
      emit(UserRegistrationFailureState(error: handleError(e)));
    }
  }
}
