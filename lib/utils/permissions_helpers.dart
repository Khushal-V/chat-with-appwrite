import 'dart:io';

import 'package:my_chat/constants/constants.dart';
import 'package:my_chat/custom_widgets/alert_dialog_boxs.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  static Future<bool?> checkForCameraPermissions() async {
    var status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      showPermissionAlertDialog(
        "Camera Permission",
        "Allow the camera permission",
      );
      return null;
    } else if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool?> checkForMediaPermission() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.request();

      if (status.isPermanentlyDenied) {
        showPermissionAlertDialog(
          "Media Permission",
          "Allow media permission",
        );
        return null;
      } else if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      var status = await Permission.mediaLibrary.request();
      if (status.isPermanentlyDenied) {
        showPermissionAlertDialog(
          "Storag Permission",
          "Allow storage permission",
        );
        return null;
      } else if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  static void showPermissionAlertDialog(
    String title,
    String description,
  ) {
    AlertDialogBoxs(
      content: description,
      title: title,
      positiveText: "Settings",
      nagativeText: "Cancel",
      onPositive: () {
        openAppSettings();
      },
    ).showConfirmationDialog(Constants.navigatorKey.currentContext!);
    // ShowCustomDialog(
    //   title: title,
    //   msg: description,
    //   positiveTitle: AppLocalizations.of(context)!.appSettings,
    //   negativeTitle: AppLocalizations.of(context)!.notNow,
    //   onPositivePressed: (BuildContext context) {
    //     openAppSettings();
    //   },
    // ).show(context);
  }
}
