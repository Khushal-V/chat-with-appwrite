import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/custom_widgets/base_scaffold.dart';
import 'package:my_chat/custom_widgets/circle_image.dart';
import 'package:my_chat/custom_widgets/custom_button.dart';
import 'package:my_chat/custom_widgets/input.dart';
import 'package:my_chat/screens/auth/bloc/auth_bloc.dart';
import 'package:my_chat/screens/auth/models/registration_request.dart';
import 'package:my_chat/utils/app_router.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:my_chat/utils/widget_helpers.dart';
import 'package:sizer/sizer.dart';
import 'package:my_chat/service_impl/auth_service_impl.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authService: AuthServiceImpl()),
      child: const RegistrationPageUI(),
    );
  }
}

class RegistrationPageUI extends StatefulWidget {
  const RegistrationPageUI({Key? key}) : super(key: key);

  @override
  State<RegistrationPageUI> createState() => _RegistrationPageUIState();
}

class _RegistrationPageUIState extends State<RegistrationPageUI> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  XFile? selectedProfile;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        //Khushal: Show error if registration fail state
        if (state is UserRegistrationFailureState) {
          WidgetHelpers.showSnackbar(msg: state.error);
        }

        //Khushal: If registration success then should regirect to login page
        if (state is UserRegistrationSuccessState) {
          context.pushNamedAndClearStack(path: RoutesName.login);
        }
      },
      builder: (context, state) {
        //Khushal: Update user selected profile pic
        if (state is UpdateUserImageState) {
          selectedProfile = state.selectedImage;
        }
        return BaseScafflod(
          appBarTitle: AppStrings.signUp,
          body: SingleChildScrollView(
            child: Column(
              children: [
                5.h.hSizedBox,
                //Khushal: User profile pic view
                ProfileImageView(
                  imagePath: selectedProfile?.path,
                  onTap: () {
                    context.read<AuthBloc>().add(SelectUserImageEvent());
                  },
                ),
                5.h.hSizedBox,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  child: Column(
                    children: [
                      //Khushal: Name text filed
                      RegistrationInputs(
                        controller: _nameController,
                        title: AppStrings.name,
                      ),
                      2.h.hSizedBox,
                      //Khushal: Email text filed
                      RegistrationInputs(
                        controller: _emailController,
                        title: AppStrings.email,
                      ),
                      2.h.hSizedBox,
                      //Khushal: Password text filed
                      RegistrationInputs(
                        controller: _passwordController,
                        title: AppStrings.password,
                        obscureText: true,
                      ),
                      2.h.hSizedBox,
                      //Khushal: Confirm password text filed
                      RegistrationInputs(
                        controller: _confirmPasswordController,
                        title: AppStrings.confirmPassword,
                        obscureText: true,
                      ),
                      2.h.hSizedBox,
                      //Khushal: Regisration button
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              //Khushal: Show loader while calling registration api
                              isLoading: state is UserRegistrationBusyState,
                              title: AppStrings.register,
                              onTap: () {
                                //Khushal: Add user registration event with all fields
                                context.read<AuthBloc>().add(
                                      UserRegistrationEvent(
                                        request: RegistrationRequest(
                                          email: _emailController.text,
                                          name: _nameController.text,
                                          password: _passwordController.text,
                                          confirmPassword:
                                              _confirmPasswordController.text,
                                        ),
                                      ),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                      5.h.hSizedBox,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RegistrationInputs extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool obscureText;
  const RegistrationInputs(
      {super.key,
      required this.controller,
      required this.title,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: controller,
      title: title,
      obscureText: obscureText,
    );
  }
}
