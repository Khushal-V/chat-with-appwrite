import 'package:my_chat/configs/app_configs.dart';
import 'package:my_chat/main_common.dart';

Future<void> main() async {
  final appConfig = AppConfig(
    appTitle: "My Chat Production",
    buildFlavor: BuildFlavors.Production,
  );

  return mainCommon(appConfig);
}
