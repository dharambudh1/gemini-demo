import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:gemini_demo/models/custom_model.dart";
import "package:gemini_demo/models/gemini_failure_response_model.dart";
import "package:gemini_demo/models/gemini_success_response_model.dart";
import "package:gemini_demo/service/api_service.dart";
import "package:get/get.dart";
import "package:mime/mime.dart";

class ChatController extends GetxController {
  final RxList<CustomModel> chatList = <CustomModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    Get.put(APIService());
  }

  Future<void> makAnAPICall({
    required Map<String, dynamic> requestModel,
    required Function(GeminiSuccessResponseModel response) successCallback,
    required Function(GeminiFailureResponseModel response) failureCallback,
  }) async {
    await APIService().funcGeminiAPI(
      requestModel: requestModel,
      successCallback: successCallback,
      failureCallback: failureCallback,
    );
    return Future<void>.value();
  }
}

String getMimeType(String path) {
  final String temp = path;
  return lookupMimeType(temp) ?? "application/octet-stream";
}

String convertToBase64(String path) {
  final Uint8List uint8list = File(path).readAsBytesSync();
  return base64Encode(uint8list);
}

Uint8List decodeFromBase64(String encoded) {
  final Uint8List uint8list = base64Url.decode(encoded);
  return uint8list;
}
