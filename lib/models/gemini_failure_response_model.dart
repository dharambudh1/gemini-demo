class GeminiFailureResponseModel {
  GeminiFailureResponseModel({this.error});

  GeminiFailureResponseModel.fromJson(Map<String, dynamic> json) {
    error = json["error"] != null ? Error.fromJson(json["error"]) : null;
  }

  Error? error;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (error != null) {
      data["error"] = error!.toJson();
    }
    return data;
  }
}

class Error {
  Error({this.code, this.message, this.status});
  
  Error.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    status = json["status"];
  }

  int? code;
  String? message;
  String? status;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    data["message"] = message;
    data["status"] = status;
    return data;
  }
}
