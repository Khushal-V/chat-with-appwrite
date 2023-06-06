import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/configs/app_images.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/custom_widgets/base_scaffold.dart';
import 'package:my_chat/custom_widgets/custom_button.dart';
import 'package:my_chat/custom_widgets/input.dart';
import 'package:my_chat/screens/auth/bloc/auth_bloc.dart';
import 'package:my_chat/screens/auth/models/login_request.dart';
import 'package:my_chat/subscribe/subscribe_channel_bloc.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/app_router.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:my_chat/utils/widget_helpers.dart';
import 'package:sizer/sizer.dart';
import 'package:my_chat/service_impl/auth_service_impl.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authService: AuthServiceImpl()),
      child: const LoginPageUI(),
    );
  }
}

class LoginPageUI extends StatefulWidget {
  const LoginPageUI({Key? key}) : super(key: key);

  @override
  State<LoginPageUI> createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        //Khushal: Show error if state is error state
        if (state is UserLoginFailureState) {
          WidgetHelpers.showSnackbar(msg: state.error);
        }

        //Khushal: If user login success state then should redirect in to dashboard page
        if (state is UserLoginSuccessState) {
          //Khushal: Login success then should subscribe chat and messages channels
          context
              .read<SubscribeChannelBloc>()
              .add(SubscribeMessageAndChatChannelEvent());

          //Khushal: Regirect to dashboard page
          context.pushNamedAndClearStack(path: RoutesName.base);
        }
      },
      builder: (context, state) {
        return BaseScafflod(
          appBarTitle: AppStrings.signIn,
          body: SingleChildScrollView(
            child: Column(
              children: [
                10.h.hSizedBox,
                //Khsuahl: App Logo
                SizedBox(
                  width: 50.w,
                  height: 50.w,
                  child: Image.asset(AppImages.appIcon),
                ),
                5.h.hSizedBox,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  child: Column(
                    children: [
                      //Khsuahl: Email text field
                      LoginInputs(
                        controller: _emailController,
                        title: AppStrings.email,
                      ),
                      2.h.hSizedBox,
                      //Khsuahl: Password text field
                      LoginInputs(
                        controller: _passwordController,
                        title: AppStrings.password,
                        obscureText: true,
                      ),
                      2.h.hSizedBox,
                      //Khsuahl: Login button
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              //Khushal: Show loader while calling api
                              isLoading: state is UserLoginBusyState,
                              title: AppStrings.login,
                              onTap: () {
                                //Khushal: Add login event with email and password
                                context.read<AuthBloc>().add(
                                      UserLoginEvent(
                                        request: LoginRequest(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      ),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                      1.h.hSizedBox,
                      //Khushal: Registration like
                      const RegistrationLink(),
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

class LoginInputs extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool obscureText;
  const LoginInputs(
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

class RegistrationLink extends StatelessWidget {
  const RegistrationLink({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(color: AppColors.textColor, fontSize: 18);
    return RichText(
      text: TextSpan(
        text: "${AppStrings.doNotHaveAccount} ",
        style: style,
        children: [
          TextSpan(
            text: AppStrings.register,
            style: style.copyWith(
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.pushNamed(path: RoutesName.registration),
          )
        ],
      ),
    );
  }
}
