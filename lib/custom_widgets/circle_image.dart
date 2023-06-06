import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:sizer/sizer.dart';

class CircleImage extends StatelessWidget {
  final Uint8List? image;
  final double? height;
  final double? width;
  const CircleImage({super.key, this.image, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final bool isImage = image != null;
    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).primaryColor),
          image: isImage
              ? DecorationImage(
                  image: MemoryImage(
                    image!,
                  ),
                  fit: BoxFit.fill,
                )
              : null,
        ),
        height: height ?? 35.sp,
        width: width ?? 35.sp,
        child: isImage
            ? 0.hSizedBox
            : Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
      ),
    );
  }
}

class ProfileImageView extends StatelessWidget {
  final String? imagePath;
  final Uint8List? profileImage;
  final Function()? onTap;
  const ProfileImageView(
      {super.key, this.imagePath, this.onTap, this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ClipOval(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
                image: imagePath != null
                    ? DecorationImage(
                        image: FileImage(
                          File(imagePath!),
                        ),
                        fit: BoxFit.fill)
                    : profileImage != null
                        ? DecorationImage(
                            image: MemoryImage(
                              profileImage!,
                            ),
                            fit: BoxFit.fill)
                        : null,
              ),
              height: 75.sp,
              width: 75.sp,
              child: imagePath == null && profileImage == null
                  ? Center(
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : 0.hSizedBox,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 40.w,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteColor,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
              ),
              height: 20.sp,
              width: 20.sp,
              child: Icon(
                Icons.camera,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
