import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static HiveService? _instance;

  factory HiveService() {
    _instance ??= HiveService._();
    return _instance!;
  }

  HiveService._();

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    for (final box in HiveBox.values) {
      await Hive.openBox(
        box.boxName,
      );
    }
  }

  Box<dynamic> getBox(HiveBox box) {
    return Hive.box(
      box.boxName,
    );
  }

  Future<void> addData<T>(HiveKey key, dynamic data) async {
    final bx = getBox(key.box);
    await bx.put(key.name, data);
  }

  dynamic getData<T>(
    HiveKey key, {
    dynamic defaultValue,
  }) {
    final bx = getBox(key.box);
    return bx.get(
      key.name,
      defaultValue: defaultValue,
    );
  }

  Future<int> clear(
    HiveBox box,
  ) async {
    final bx = getBox(box);
    return bx.clear();
  }
}

enum HiveBox { core }

extension HiveBoxHelpers on HiveBox {
  String get boxName {
    switch (this) {
      case HiveBox.core:
        return 'core';
    }
  }
}

enum HiveKey {
  //Core
  sessionId,
}

extension HiveKeyHelpers on HiveKey {
  HiveBox get box {
    switch (this) {
      default:
        return HiveBox.core;
    }
  }
}
