import 'package:flutter/material.dart';
import 'package:my_chat/constants/constants.dart';
import 'package:my_chat/utils/app_colors.dart';

class WidgetHelpers {
  static void showSnackbar({required String msg, bool isError = true}) {
    ScaffoldMessenger.of(Constants.navigatorKey.currentContext!)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1500),
          backgroundColor: isError ? Colors.red : Colors.green,
          content: Text(
            msg,
            style: const TextStyle(color: AppColors.whiteColor),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
