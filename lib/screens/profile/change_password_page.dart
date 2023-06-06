import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/custom_widgets/base_scaffold.dart';
import 'package:my_chat/custom_widgets/custom_button.dart';
import 'package:my_chat/custom_widgets/input.dart';
import 'package:my_chat/screens/profile/bloc/profile_bloc.dart';
import 'package:my_chat/service_impl/auth_service_impl.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:my_chat/utils/widget_helpers.dart';
import 'package:sizer/sizer.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(authService: AuthServiceImpl()),
      child: const ChangePasswordPageUI(),
    );
  }
}

class ChangePasswordPageUI extends StatefulWidget {
  const ChangePasswordPageUI({super.key});

  @override
  State<ChangePasswordPageUI> createState() => _ChangePasswordPageUIState();
}

class _ChangePasswordPageUIState extends State<ChangePasswordPageUI> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseScafflod(
      appBarTitle: AppStrings.changePassword,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          //Khushal: Show error id getting error state
          if (state is UpdatePasswordFailureState) {
            WidgetHelpers.showSnackbar(msg: state.error);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 14.sp),
            child: Column(
              children: [
                //Khushal: Old password text filed
                Input(
                  hintText: "",
                  title: AppStrings.oldPassword,
                  controller: oldPasswordController,
                  obscureText: true,
                ),
                16.hSizedBox,
                //Khushal: New password text filed
                Input(
                  hintText: "",
                  title: AppStrings.newPassword,
                  controller: newPasswordController,
                  obscureText: true,
                ),
                16.hSizedBox,
                //Khushal: New confirm password text filed
                Input(
                  hintText: "",
                  title: AppStrings.confimrNewPassword,
                  controller: confirmNewPasswordController,
                  obscureText: true,
                ),
                2.h.hSizedBox,
                //Khushal: Update password button
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: AppStrings.update,
                        //Khushal: Show loader while updating password
                        isLoading: state is UpdatePasswordBusyState,
                        onTap: () {
                          //Khushal: Add event to update password
                          context.read<ProfileBloc>().add(UpdatePasswordEvent(
                              password: newPasswordController.text,
                              oldPassword: oldPasswordController.text,
                              confirmPassword:
                                  confirmNewPasswordController.text));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
