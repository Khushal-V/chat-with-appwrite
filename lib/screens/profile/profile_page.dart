import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/custom_widgets/base_scaffold.dart';
import 'package:my_chat/custom_widgets/circle_image.dart';
import 'package:my_chat/custom_widgets/custom_button.dart';
import 'package:my_chat/custom_widgets/input.dart';
import 'package:my_chat/screens/profile/bloc/profile_bloc.dart';
import 'package:my_chat/service_impl/auth_service_impl.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/utils/app_router.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:my_chat/utils/widget_helpers.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        authService: AuthServiceImpl(),
      ),
      child: const ProfilePageUI(),
    );
  }
}

class ProfilePageUI extends StatefulWidget {
  const ProfilePageUI({super.key});

  @override
  State<ProfilePageUI> createState() => _ProfilePageUIState();
}

class _ProfilePageUIState extends State<ProfilePageUI> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  XFile? selectedFile;

  @override
  void initState() {
    super.initState();
    nameController.text = AppWriteService.user?.name ?? "";
    emailController.text = AppWriteService.user?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BaseScafflod(
      appBarTitle: AppStrings.profile,
      body: SingleChildScrollView(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            //Khushal: Show error if getting any while updating profile
            if (state is UpdateProfileFailureState) {
              WidgetHelpers.showSnackbar(
                msg: state.error,
              );
            }
          },
          builder: (context, state) {
            //Khushal: Update selected profile of user
            if (state is UpdateUserImageState) {
              selectedFile = state.selectedImage;
            }
            return Column(
              children: [
                5.h.hSizedBox,
                //Khushal: Profile pic view
                ProfileImageView(
                  imagePath: selectedFile?.path,
                  profileImage: AppWriteService.user?.profile,
                  onTap: () {
                    context.read<ProfileBloc>().add(SelectUserImageEvent());
                  },
                ),
                5.h.hSizedBox,
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.sp, vertical: 16.sp),
                  child: Column(
                    children: [
                      //Khushal: User name text field
                      Input(
                        hintText: "",
                        title: AppStrings.name,
                        controller: nameController,
                        keyboardType: TextInputType.text,
                      ),
                      16.hSizedBox,
                      //Khushal: User email text field
                      Input(
                        hintText: "",
                        title: AppStrings.email,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: false,
                      ),
                      2.h.hSizedBox,
                      //Khushal: Update profile button
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: AppStrings.updateProfile,
                              //Khushal: Show loader while updating profile
                              isLoading: state is UpdateProfileBusyState,
                              onTap: () {
                                //Khushal: Add new event to update profile
                                context
                                    .read<ProfileBloc>()
                                    .add(UpdateUserProfileEvent(
                                      name: nameController.text,
                                      selectedFile: selectedFile,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                      3.h.hSizedBox,
                      //Khushal: Logout and Update password view
                      const LogoutAndUpdatePasswordView(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LogoutAndUpdatePasswordView extends StatelessWidget {
  const LogoutAndUpdatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        //Khushal: If user user logout success then should redirect to login page
        if (state is LogoutCurrentUserSuccessState) {
          context.pushNamedAndClearStack(path: RoutesName.login);
        }
      },
      builder: (context, state) {
        return Row(
          children: [
            //Khushal: Update password button
            Expanded(
              child: CustomButton(
                title: AppStrings.updatePassword,
                onTap: () {
                  context.pushNamed(path: RoutesName.changePassword);
                },
              ),
            ),
            10.wSizedBox,
            //Khushal: Logout button
            Expanded(
              child: CustomButton(
                //Khushal: Show loader while logging out user
                isLoading: state is LogoutCurrentUserBusyState,
                title: AppStrings.logout,
                onTap: () {
                  //Khushal: Add event to logout current user
                  context.read<ProfileBloc>().add(LogoutCurrentUserEvent());
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
