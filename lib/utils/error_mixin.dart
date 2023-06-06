import 'package:appwrite/appwrite.dart';

mixin ErrorMixin {
  String handleError(Object data) {
    print(data.toString());
    if (data is AppwriteException) {
      return data.message ?? "";
    } else {
      return data.toString();
    }
  }
}
