import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/custom_widgets/title_text_view.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/image_picker_helpers.dart';
import 'package:sizer/sizer.dart';

class ImagePickerView extends StatelessWidget {
  final Function(List<XFile>? pickedFile) returnFile;
  final bool allowMultiple;
  const ImagePickerView(
    this.returnFile, {
    Key? key,
    this.allowMultiple = true,
  }) : super(key: key);

  void show(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => BottomImagePickerUI(
        returnFile: returnFile,
        allowMultiple: allowMultiple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BottomImagePickerUI extends StatefulWidget {
  final Function(List<XFile>? pickedFile) returnFile;
  final bool allowMultiple;
  const BottomImagePickerUI({
    super.key,
    required this.returnFile,
    required this.allowMultiple,
  });

  @override
  State<BottomImagePickerUI> createState() => _BottomImagePickerUIState();
}

class _BottomImagePickerUIState extends State<BottomImagePickerUI> {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Center(
        child: TitleTextView(
          AppStrings.selectImageSource,
          fontSize: 20.sp,
          color: AppColors.textColor,
        ),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            pickImage(
              imageSource: ImageSource.camera,
            );
            Navigator.pop(context);
          },
          child: TitleTextView(
            AppStrings.camera,
            fontSize: 18.sp,
            color: AppColors.blueColor,
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            pickImage(
              imageSource: ImageSource.gallery,
            );
            Navigator.pop(context);
          },
          child: TitleTextView(
            AppStrings.gallery,
            fontSize: 18.sp,
            color: AppColors.blueColor,
          ),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const TitleTextView(AppStrings.cancel),
      ),
    );
  }

  Future<void> pickImage({
    required ImageSource imageSource,
  }) async {
    List<XFile>? xFile = await ImagePickerHelpers.selectImage(
        imageSource: imageSource, allowMultiple: widget.allowMultiple);
    widget.returnFile(xFile);
  }
}
