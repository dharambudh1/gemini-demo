import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:gemini_demo/util/app_perm_service.dart";
import "package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "package:media_info/media_info.dart";

class AppImageVideoPicker {
  factory AppImageVideoPicker() {
    return _singleton;
  }

  AppImageVideoPicker._internal();
  static final AppImageVideoPicker _singleton = AppImageVideoPicker._internal();

  final ImagePicker _picker = ImagePicker();
  final MediaInfo _mediaInfo = MediaInfo();

  Future<void> openImageVideoPicker({
    required Function(String filePath) filePathCallback,
    required bool isForVideo,
  }) async {
    await Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16),
          const Text(
            "Action Perform",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ListTile(
            dense: true,
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text("Camera"),
            onTap: () async {
              Get.back();

              final String filePath = await onSelectCamera(
                isForVideo: isForVideo,
              );
              await mainProcedure(
                filePath: filePath,
                filePathCallback: filePathCallback,
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(
              isForVideo
                  ? Icons.video_collection_outlined
                  : Icons.photo_library_outlined,
            ),
            title: Text(
              isForVideo ? "Video Library" : "Photo Library",
            ),
            onTap: () async {
              Get.back();

              final String filePath = await onSelectPhotoLibrary(
                isForVideo: isForVideo,
              );
              await mainProcedure(
                filePath: filePath,
                filePathCallback: filePathCallback,
              );
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      isScrollControlled: true,
    );
    return Future<void>.value();
  }

  Future<void> mainProcedure({
    required String filePath,
    required Function(String filePath) filePathCallback,
  }) async {
    if (filePath.isNotEmpty) {
      final int sizeInBytes = File(filePath).lengthSync();
      final double sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb > 20) {
        const GetSnackBar snackBar = GetSnackBar(
          message: "File size should ne less than 20 MB",
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        );
        Get.showSnackbar(snackBar);
      } else {
        Map<String, dynamic> info = <String, dynamic>{};
        info = await _mediaInfo.getMediaInfo(filePath);

        log("getMediaInfo: $info");

        if (info.containsKey("durationMs")) {
          final num durationMs = info["durationMs"];
          final num durationinMinutes = durationMs / 60000;

          if (durationinMinutes > 5) {
            const GetSnackBar snackBar = GetSnackBar(
              message: "File duration should ne less than 5 minutes",
              duration: Duration(seconds: 4),
              backgroundColor: Colors.red,
            );
            Get.showSnackbar(snackBar);
          } else {
            filePathCallback(filePath);
          }
        } else {
          filePathCallback(filePath);
        }
      }
    } else {}
    return Future<void>.value();
  }

  Future<String> onSelectCamera({required bool isForVideo}) async {
    String filePath = "";
    final bool hasPerm = await AppPermService().permissionPhotoOrStorage();
    if (hasPerm) {
      const ImageSource src = ImageSource.camera;
      final XFile file = isForVideo
          ? await _picker.pickVideo(source: src) ?? XFile("")
          : await _picker.pickImage(source: src) ?? XFile("");
      filePath = file.path;
    } else {
      const GetSnackBar snackBar = GetSnackBar(
        message: "Camera Permission Needed",
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red,
      );
      Get.showSnackbar(snackBar);
    }
    return Future<String>.value(filePath);
  }

  Future<String> onSelectPhotoLibrary({required bool isForVideo}) async {
    String filePath = "";
    final bool hasPerm = await AppPermService().permissionPhotoOrStorage();
    if (hasPerm) {
      const ImageSource src = ImageSource.gallery;
      final XFile file = isForVideo
          ? await _picker.pickVideo(source: src) ?? XFile("")
          : await _picker.pickImage(source: src) ?? XFile("");
      filePath = file.path;
    } else {
      final GetSnackBar snackBar = GetSnackBar(
        message: isForVideo
            ? "Video Library Permission Needed"
            : "Photo Library Permission Needed",
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red,
      );
      Get.showSnackbar(snackBar);
    }
    return Future<String>.value(filePath);
  }
}
