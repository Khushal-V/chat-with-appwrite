import 'package:image_picker/image_picker.dart';
import 'package:my_chat/utils/permissions_helpers.dart';

class ImagePickerHelpers {
  static Future<List<XFile>?> selectImage({
    required ImageSource imageSource,
    required bool allowMultiple,
  }) async {
    if (imageSource == ImageSource.gallery) {
      bool? galleryPermission =
          await PermissionsHelper.checkForMediaPermission();
      if (galleryPermission == true) {
        if (allowMultiple) {
          List<XFile>? selectedFile = await ImagePicker().pickMultiImage();
          return selectedFile;
        } else {
          XFile? selectedFile =
              await ImagePicker().pickImage(source: imageSource);
          if (selectedFile != null) {
            return [selectedFile];
          }
        }
      }
    } else {
      bool? galleryPermission =
          await PermissionsHelper.checkForCameraPermissions();
      if (galleryPermission == true) {
        XFile? selectedFile = await ImagePicker().pickImage(
          source: imageSource,
          imageQuality: 60,
        );
        if (selectedFile != null) {
          return [selectedFile];
        }
      }
    }
    return null;
  }
}
