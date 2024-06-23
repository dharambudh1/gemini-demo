import "dart:developer";
import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:get/get.dart";
import "package:permission_handler/permission_handler.dart";

class AppPermService extends GetxService {
  factory AppPermService() {
    return _singleton;
  }

  AppPermService._internal();
  static final AppPermService _singleton = AppPermService._internal();

  Future<bool> permissionPhotos() async {
    bool hasPhotosPermission = false;

    try {
      final PermissionStatus try0 = await Permission.photos.status;
      if (try0 == PermissionStatus.granted) {
        hasPhotosPermission = true;
      } else {
        final PermissionStatus try1 = await Permission.photos.request();
        if (try1 == PermissionStatus.granted) {
          hasPhotosPermission = true;
        } else {}
      }
      log("Photos perm: $hasPhotosPermission");
    } on Exception catch (error, stackTrace) {
      log(
        "Exception caught",
        error: error,
        stackTrace: stackTrace,
      );
    } finally {}

    return Future<bool>.value(hasPhotosPermission);
  }

  Future<bool> permissionStorage() async {
    bool hasStoragePermission = false;

    try {
      final PermissionStatus try0 = await Permission.storage.status;
      if (try0 == PermissionStatus.granted) {
        hasStoragePermission = true;
      } else {
        final PermissionStatus try1 = await Permission.storage.request();
        if (try1 == PermissionStatus.granted) {
          hasStoragePermission = true;
        } else {}
      }
      log("Storage perm: $hasStoragePermission");
    } on Exception catch (error, stackTrace) {
      log(
        "Exception caught",
        error: error,
        stackTrace: stackTrace,
      );
    } finally {}

    return Future<bool>.value(hasStoragePermission);
  }

  Future<bool> permissionCam() async {
    bool hasCameraPermission = false;

    try {
      final PermissionStatus try0 = await Permission.camera.status;
      if (try0 == PermissionStatus.granted) {
        hasCameraPermission = true;
      } else {
        final PermissionStatus try1 = await Permission.camera.request();
        if (try1 == PermissionStatus.granted) {
          hasCameraPermission = true;
        } else {}
      }
      log("Camera perm: $hasCameraPermission");
    } on Exception catch (error, stackTrace) {
      log(
        "Exception caught",
        error: error,
        stackTrace: stackTrace,
      );
    } finally {}

    return Future<bool>.value(hasCameraPermission);
  }

  Future<bool> permissionMic() async {
    bool hasMicrophonePermission = false;

    try {
      final PermissionStatus try0 = await Permission.microphone.status;
      if (try0 == PermissionStatus.granted) {
        hasMicrophonePermission = true;
      } else {
        final PermissionStatus try1 = await Permission.microphone.request();
        if (try1 == PermissionStatus.granted) {
          hasMicrophonePermission = true;
        } else {}
      }
      log("Microphone perm: $hasMicrophonePermission");
    } on Exception catch (error, stackTrace) {
      log(
        "Exception caught",
        error: error,
        stackTrace: stackTrace,
      );
    } finally {}

    return Future<bool>.value(hasMicrophonePermission);
  }

  Future<bool> permissionPhotoOrStorage() async {
    bool perm = false;

    try {
      if (Platform.isIOS) {
        perm = await permissionPhotos();
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
        perm = info.version.sdkInt <= 32
            ? await permissionStorage()
            : await permissionPhotos();
      } else {}
      log("Photo Or Storage perm: $perm");
    } on Exception catch (error, stackTrace) {
      log(
        "Exception caught",
        error: error,
        stackTrace: stackTrace,
      );
    } finally {}

    return Future<bool>.value(perm);
  }
}
