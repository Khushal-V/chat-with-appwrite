import 'package:flutter/material.dart';
import 'package:my_chat/custom_widgets/circle_image.dart';
import 'package:my_chat/custom_widgets/title_text_view.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:sizer/sizer.dart';

class ChatImageView extends StatelessWidget {
  final List<String> imageUrls;
  const ChatImageView({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      width: 75.w,
      child: Stack(
        children: [
          if (imageUrls.length == 2) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    child: ChatImage(image: imageUrls.first),
                  ),
                ),
                const VerticalDivider(
                  color: AppColors.backgroundColor,
                  thickness: 2,
                  indent: 0,
                  endIndent: 0,
                  width: 1,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: ChatImage(image: imageUrls[1]),
                  ),
                ),
              ],
            ),
          ] else if (imageUrls.length == 3) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    child: SizedBox(
                      height: 25.h,
                      child: ChatImage(image: imageUrls.first),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: AppColors.backgroundColor,
                  thickness: 2,
                  indent: 0,
                  endIndent: 0,
                  width: 1,
                ),
                Expanded(
                  child: SizedBox(
                    height: 25.h,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: ChatImage(image: imageUrls[1]),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleTextView("+ ${getRemainingCount(2)}",
                      fontSize: 48, color: AppColors.backgroundColor),
                ],
              ),
            ),
          ] else if (imageUrls.length == 4) ...[
            Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                          ),
                          child: SizedBox(
                            height: 12.5.h,
                            child: ChatImage(image: imageUrls.first),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: AppColors.backgroundColor,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                        width: 1,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 12.4.h,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                            ),
                            child: ChatImage(image: imageUrls[1]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: AppColors.backgroundColor,
                  thickness: 1,
                  height: 0,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                          ),
                          child: SizedBox(
                            height: 12.5.h,
                            child: ChatImage(image: imageUrls[2]),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: AppColors.backgroundColor,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                        width: 1,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 12.4.h,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                            child: ChatImage(image: imageUrls[3]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else if ((imageUrls.length) > 4) ...[
            Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                          ),
                          child: SizedBox(
                            height: 12.5.h,
                            child: ChatImage(image: imageUrls.first),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: AppColors.backgroundColor,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                        width: 1,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 12.4.h,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                            ),
                            child: ChatImage(image: imageUrls[1]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: AppColors.backgroundColor,
                  thickness: 1,
                  height: 0,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                          ),
                          child: SizedBox(
                            height: 12.5.h,
                            child: ChatImage(image: imageUrls[2]),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: AppColors.backgroundColor,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                        width: 1,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 12.4.h,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                            child: ChatImage(image: imageUrls[3]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleTextView("+ ${getRemainingCount(4)}",
                      fontSize: 48, color: AppColors.backgroundColor),
                ],
              ),
            ),
          ] else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ChatImage(image: imageUrls.first),
            ),
          ],
        ],
      ),
    );
  }

  int getRemainingCount(int minuesCount) => (imageUrls.length) - minuesCount;
}

class ChatImage extends StatelessWidget {
  final String image;
  const ChatImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      width: double.maxFinite,
      child: NetworkCachedImage(image: image),
    );
  }
}
