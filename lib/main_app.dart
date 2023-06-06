import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/constants/constants.dart';
import 'package:my_chat/screens/chat/bloc/chat_bloc.dart';
import 'package:my_chat/service_impl/chat_service_impl.dart';
import 'package:my_chat/service_impl/messages_service_impl.dart';
import 'package:my_chat/subscribe/subscribe_channel_bloc.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/app_router.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SubscribeChannelBloc(),
            ),
            BlocProvider(
              create: (context) => ChatBloc(
                chatService: ChatServiceImpl(),
                messagesService: MessagesServiceImpl(),
              ),
            ),
          ],
          child: MaterialApp(
            title: AppStrings.appName,
            theme: ThemeData(
              primaryColor: AppColors.primaryColor,
              buttonTheme: const ButtonThemeData(
                buttonColor: AppColors.buttonbackgrouncolor,
                colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  primary: AppColors.buttonbackgrouncolor,
                  onPrimary: AppColors.buttonbackgrouncolor,
                  secondary: AppColors.buttonbackgrouncolor,
                  onSecondary: AppColors.buttonbackgrouncolor,
                  error: AppColors.buttonbackgrouncolor,
                  onError: AppColors.buttonbackgrouncolor,
                  background: AppColors.buttonbackgrouncolor,
                  onBackground: AppColors.buttonbackgrouncolor,
                  surface: AppColors.buttonbackgrouncolor,
                  onSurface: AppColors.buttonbackgrouncolor,
                ),
                textTheme: ButtonTextTheme.normal,
              ),
              appBarTheme: const AppBarTheme(
                color: AppColors.primaryColor,
              ),
            ),
            debugShowCheckedModeBanner: false,
            navigatorKey: Constants.navigatorKey,
            onGenerateRoute: commonNavigation,
            initialRoute: RoutesName.splash,
          ),
        );
      },
    );
  }
}
