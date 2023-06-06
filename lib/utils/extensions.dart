import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_chat/utils/app_router.dart';

extension SizedBoxHelpers on num {
  SizedBox get hSizedBox => SizedBox(height: toDouble());
  SizedBox get wSizedBox => SizedBox(width: toDouble());
}

extension RoutesHelpers on BuildContext {
  void push(Object nextScreen) {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => nextScreen as Widget,
      ),
    );
  }

  Future<dynamic> pushWithResult(Object nextScreen) async {
    return await Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => nextScreen as Widget,
      ),
    );
  }

  Future<dynamic> pushAndClearStack(Object nextScreen) async {
    return await Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(
        builder: (context) => nextScreen as Widget,
      ),
      (route) => false,
    );
  }

  void pushNamed({required String path, dynamic arguments}) async {
    Navigator.pushNamed(this, path, arguments: arguments);
  }

  Future<Object?> pushNamedWithResult(
      {required String path, dynamic arguments}) async {
    return await Navigator.pushNamed(this, path, arguments: arguments);
  }

  void pushNamedAndClearStack({required String path, dynamic arguments}) async {
    Navigator.pushNamedAndRemoveUntil(this, path, (route) => false);
  }

  void pop({dynamic arguments}) async {
    Navigator.pop(this, arguments);
  }
}

extension StringHelpers on String? {
  Routings get getRoutingData {
    final uriData = Uri.parse(this ?? "");
    return Routings(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}

extension EnumParser on String {
  T? toEnum<T>(List<T> values) {
    return values.firstWhereOrNull(
        (e) => e.toString().toLowerCase().split(".").last == toLowerCase());
  }
}

extension DateExtension on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);
    if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays == 0) {
      return DateFormat("hh:mm a").format(toUtc().toLocal());
    } else {
      return DateFormat("dd MMM").format(toUtc().toLocal());
    }
  }

  String get formatMessageTime => DateFormat("hh:mm a").format(this);
}
