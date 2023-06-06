import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/configs/app_images.dart';
import 'package:my_chat/screens/splash/bloc/splash_bloc.dart';
import 'package:my_chat/service_impl/auth_service_impl.dart';
import 'package:my_chat/subscribe/subscribe_channel_bloc.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/app_router.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:sizer/sizer.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(authService: AuthServiceImpl())
        ..add(
          CheckUserIsLoggedInEvent(),
        ),
      child: const SplashPageUI(),
    );
  }
}

class SplashPageUI extends StatefulWidget {
  const SplashPageUI({Key? key}) : super(key: key);

  @override
  State<SplashPageUI> createState() => _SplashPageUIState();
}

class _SplashPageUIState extends State<SplashPageUI> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        //Khushal: If user not loggedIn should redirect to login page
        if (state is UserIsNotLoggedInState) {
          context.pushNamedAndClearStack(path: RoutesName.login);
        }

        //Khushal: If user loggedIn should redirect to dashboard page
        if (state is UserAlreadyLoggedInState) {
          //Khushal: Subscribe chat and message channels to get updates
          context
              .read<SubscribeChannelBloc>()
              .add(SubscribeMessageAndChatChannelEvent());
          context.pushNamedAndClearStack(path: RoutesName.base);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Center(
            child: SizedBox(
              width: 50.w,
              height: 50.w,
              child: Image.asset(AppImages.appIcon),
            ),
          ),
        );
      },
    );
  }
}
