import 'package:permission_handler/permission_handler.dart';

class PermissionsClass {
  static Future<void> requestPermissions() async {
    final storageStatus = await Permission.storage.request();
    final locationStatus = await Permission.location.request();
    final storageStatusForAPi33 =
        await Permission.manageExternalStorage.request();

    if (locationStatus.isDenied ||
        (storageStatus.isDenied && storageStatusForAPi33.isDenied)) {
      await requestPermissions();
    }

    // if ((storageStatus.isDenied || locationStatus.isDenied)) {
    //   // You have the necessary permissions.
    //   await requestPermissions();
    // }
    // else {
    //   // Permissions are denied. You can show a message or request them again.
    // }
  }
}
