import 'package:flutter/material.dart';
import 'package:my_chat/custom_widgets/loader_view.dart';
import 'package:my_chat/custom_widgets/title_text_view.dart';
import 'package:my_chat/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color? color;
  final TextStyle? titleStyle;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool isLoading;
  final Color? loaderColor;
  final Size? loaderSize;
  const CustomButton(
      {super.key,
      required this.title,
      this.color,
      this.titleStyle,
      this.onTap,
      this.padding,
      this.borderRadius,
      this.isLoading = false,
      this.loaderColor,
      this.loaderSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            color ?? Theme.of(context).buttonTheme.colorScheme!.background,
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 10,
            ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 2),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      onPressed: onTap,
      child: isLoading
          ? LoaderView(
              loaderColor: loaderColor,
            )
          : TitleTextView(
              title,
              color: titleStyle?.color ?? AppColors.whiteColor,
              fontSize: titleStyle?.fontSize ?? 16,
            ),
    );
  }
}
