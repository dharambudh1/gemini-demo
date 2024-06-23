import "dart:developer";
import "dart:io";

import "package:gemini_demo/models/gemini_failure_response_model.dart";
import "package:gemini_demo/models/gemini_success_response_model.dart";
import "package:get/get.dart";

class APIService extends GetConnect {
  factory APIService() {
    return _singleton;
  }

  APIService._internal();

  static final APIService _singleton = APIService._internal();

  static String baseURL = "https://generativelanguage.googleapis.com";
  static String baseURLVer = "/v1beta";
  static String baseURLEndPoint = "/models/gemini-1.5-flash:generateContent";
  static String token = "AIzaSyAs7KNYkgfiw3kESMWuGW0dWaf7p9KSJv8";
  static String url = "$baseURL$baseURLVer$baseURLEndPoint";

  @override
  void onInit() {
    super.onInit();

    timeout = const Duration(minutes: 10);
    maxAuthRetries = 3;
    log("APIService: onInit(): ${timeout.inSeconds}");
  }

  Future<void> funcGeminiAPI({
    required Map<String, dynamic> requestModel,
    required Function(GeminiSuccessResponseModel response) successCallback,
    required Function(GeminiFailureResponseModel response) failureCallback,
  }) async {
    final Map<String, String> requestheaders = <String, String>{
      "Content-Type": "application/json",
    };

    final Map<String, dynamic> requestBody = requestModel;

    final Map<String, dynamic> requestQuery = <String, Object>{
      "key": token,
    };

    final Response<dynamic> response = await post(
      url,
      requestBody,
      headers: requestheaders,
      query: requestQuery,
    );

    response.statusCode == HttpStatus.ok
        ? successCallback(GeminiSuccessResponseModel.fromJson(response.body))
        : failureCallback(GeminiFailureResponseModel.fromJson(response.body));
    return Future<void>.value();
  }
}
