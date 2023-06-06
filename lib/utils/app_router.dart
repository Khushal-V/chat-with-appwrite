import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/screens/auth/login_page.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:my_chat/screens/auth/registration_page.dart';
import 'package:my_chat/screens/chat/chat_page.dart';
import 'package:my_chat/screens/dashboard/dashboard_page.dart';
import 'package:my_chat/screens/messages/image_view_page.dart';
import 'package:my_chat/screens/profile/change_password_page.dart';
import 'package:my_chat/screens/profile/profile_page.dart';
import 'package:my_chat/screens/splash/splash_page.dart';
import 'package:my_chat/screens/users/users_page.dart';
import 'package:my_chat/utils/extensions.dart';

class Routings {
  String? route;
  Map<String, dynamic>? queryParameters;

  Routings({this.route, this.queryParameters});

  Routings.fromJson(Map<String, dynamic> json) {
    route = json['route'];
    queryParameters = json['queryParameters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['route'] = route;
    data['queryParameters'] = queryParameters;
    return data;
  }
}

class RoutesName {
  static const String splash = "/";
  static const String base = "/home";
  static const String login = "/login";
  static const String registration = "/registration";
  static const String selectUser = "/select-user";
  static const String chat = "/chat";
  static const String messages = "/messages";
  static const String profile = "/profile";
  static const String changePassword = "/change-password";
  static const String viewImage = "/view-image";
}

Route<dynamic> commonNavigation(RouteSettings settings) {
  final routingData = settings.name!.getRoutingData; // Get the routing Data
  switch (routingData.route) {
    case RoutesName.splash:
      return _getPageRoute(
        const SplashPage(),
        settings,
      );
    case RoutesName.login:
      return _getPageRoute(
        const LoginPage(),
        settings,
      );
    case RoutesName.registration:
      return _getPageRoute(
        const RegistrationPage(),
        settings,
      );
    case RoutesName.base:
      return _getPageRoute(
        const DashboardPage(),
        settings,
      );
    case RoutesName.selectUser:
      return _getPageRoute(
        const UsersPage(),
        settings,
      );
    case RoutesName.chat:
      return _getPageRoute(
        ChatPage(
          user: settings.arguments as AuthUser,
        ),
        settings,
      );
    case RoutesName.profile:
      return _getPageRoute(
        const ProfilePage(),
        settings,
      );
    case RoutesName.changePassword:
      return _getPageRoute(
        const ChangePasswordPage(),
        settings,
      );
    case RoutesName.viewImage:
      return _getPageRoute(
        ImageViewPage(imageData: settings.arguments as Uint8List),
        settings,
      );
    default:
      return _getPageRoute(
        Container(),
        settings,
      );
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  //return CupertinoRoute(enterPage: child);
  if (Platform.isIOS) {
    return CupertinoPageRoute(builder: (BuildContext context) => child);
  } else if (Platform.isAndroid) {
    return MaterialPageRoute(builder: (BuildContext context) => child);
  } else {
    return _FadeRoute(child: child, routeName: settings.name ?? "");
  }
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _FadeRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class CupertinoRoute extends PageRouteBuilder {
  final Widget enterPage;

  CupertinoRoute({required this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return enterPage;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.linearToEaseOut,
                  reverseCurve: Curves.easeInToLinear,
                ),
              ),
              child: enterPage,
            );
          },
        );
}
