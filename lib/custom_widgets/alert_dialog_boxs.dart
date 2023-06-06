import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/custom_widgets/title_text_view.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:sizer/sizer.dart';

class AlertDialogBoxs extends StatelessWidget {
  final String title;
  final String content;
  final String nagativeText;
  final String positiveText;
  final Function()? onNagative;
  final Function()? onPositive;
  const AlertDialogBoxs(
      {super.key,
      required this.title,
      required this.content,
      this.onNagative,
      this.onPositive,
      this.nagativeText = AppStrings.cancel,
      this.positiveText = AppStrings.delete});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: contentWidget(context),
            actions: [
              CupertinoDialogAction(
                onPressed: onNagative ?? () => context.pop(),
                child: textWidget(nagativeText, context, false),
              ),
              CupertinoDialogAction(
                onPressed: onPositive,
                child: textWidget(positiveText, context, true),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: contentWidget(context),
            actions: [
              TextButton(
                onPressed: onNagative ?? () => context.pop(),
                child: textWidget(nagativeText, context, false),
              ),
              TextButton(
                onPressed: onPositive,
                child: textWidget(positiveText, context, true),
              ),
            ],
          );
        }
      },
    );
  }

  Widget contentWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.sp),
      child: TitleTextView(
        content,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget textWidget(String text, BuildContext context, bool isNagtive) {
    return TitleTextView(text,
        color: isNagtive ? AppColors.pinkColor : AppColors.textColor);
  }
}
