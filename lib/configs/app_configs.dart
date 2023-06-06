import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  final String appTitle;
  final BuildFlavors buildFlavor;

  static late AppConfig _instance;

  static AppConfig get instance {
    return _instance;
  }

  factory AppConfig({
    required String appTitle,
    required BuildFlavors buildFlavor,
  }) {
    return _instance = AppConfig._internal(
      appTitle,
      buildFlavor,
    );
  }

  AppConfig._internal(
    this.appTitle,
    this.buildFlavor,
  );

  Future<void> loadENV() async {
    await dotenv.load(fileName: buildFlavor.environmentName);
  }
}

enum BuildFlavors {
  Production,
  Staging,
  Development,
}

extension BuildFlavorsHelpers on BuildFlavors {
  String get name => describeEnum(this);
  bool get isProduction => this == BuildFlavors.Production;
  bool get isStaging => this == BuildFlavors.Staging;
  bool get isDevelopment => this == BuildFlavors.Development;

  String get environmentName {
    switch (this) {
      case BuildFlavors.Production:
        return ".env";
      case BuildFlavors.Staging:
        return ".env";
      case BuildFlavors.Development:
        return ".env";
    }
  }
}
