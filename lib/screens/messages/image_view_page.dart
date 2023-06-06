import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

class ImageViewPage extends StatelessWidget {
  final Uint8List imageData;
  const ImageViewPage({super.key, required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          PhotoView(
            imageProvider: MemoryImage(imageData),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12.sp),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
