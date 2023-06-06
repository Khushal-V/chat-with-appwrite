import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chat/configs/app_configs.dart';
import 'package:my_chat/configs/my_http_overrides.dart';
import 'package:my_chat/main_app.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/utils/hive_service.dart';

Future<void> runMainZoneGuard(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      runApp(await builder());
    },
    (error, stackTrace) {},
  );
}

void mainCommon(AppConfig appConfig) {
  // EnableFlutterDriverExtension();
  runMainZoneGuard(() async {
    //Khushal: Load environment
    await appConfig.loadENV();

    //Khushal: Setup appwrite service
    AppWriteService.init();

    await HiveService().init();

    //Khushal: Set mobile portraitUp property
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    try {
      HttpOverrides.global = MyHttpOverrides();
    } catch (_) {}

    return const MyApp();
  });
}
