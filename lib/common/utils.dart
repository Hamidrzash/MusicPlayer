import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {}
  }
}
