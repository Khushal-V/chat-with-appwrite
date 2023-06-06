import 'package:flutter/material.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:sizer/sizer.dart';

class LoaderView extends StatelessWidget {
  final Color? loaderColor;
  const LoaderView({super.key, this.loaderColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14.sp,
      width: 14.sp,
      child: CircularProgressIndicator(
        color: loaderColor ?? AppColors.whiteColor,
      ),
    );
  }
}
