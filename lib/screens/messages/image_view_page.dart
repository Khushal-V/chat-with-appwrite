import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/custom_widgets/loader_view.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';

class ImageViewPage extends StatelessWidget {
  final List<String> imageUrls;
  const ImageViewPage({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textColor,
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[index]),
              );
            },
            itemCount: imageUrls.length,
            loadingBuilder: (context, event) => const Center(
              child: LoaderView(),
            ),
            backgroundDecoration: const BoxDecoration(
              color: AppColors.textColor,
            ),
            // backgroundDecoration: widget.backgroundDecoration,
            // pageController: widget.pageController,
            // onPageChanged: onPageChanged,
          ),
          // PhotoView(
          //   imageProvider: MemoryImage(imageData),
          //   minScale: PhotoViewComputedScale.contained * 0.8,
          //   maxScale: PhotoViewComputedScale.covered * 2,
          // ),
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
