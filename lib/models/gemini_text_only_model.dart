class GeminiTextOnlyModel {
  GeminiTextOnlyModel({this.contents});

  GeminiTextOnlyModel.fromJson(Map<String, dynamic> json) {
    if (json["contents"] != null) {
      contents = <Contents>[];
      for (final dynamic v in json["contents"] as List<dynamic>) {
        contents!.add(Contents.fromJson(v));
      }
    }
  }

  List<Contents>? contents;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contents != null) {
      data["contents"] = contents!.map((Contents v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contents {
  Contents({this.parts});

  Contents.fromJson(Map<String, dynamic> json) {
    if (json["parts"] != null) {
      parts = <Parts>[];
      for (final dynamic v in json["parts"] as List<dynamic>) {
        parts!.add(Parts.fromJson(v));
      }
    }
  }

  List<Parts>? parts;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (parts != null) {
      data["parts"] = parts!.map((Parts v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parts {
  Parts({this.text});

  Parts.fromJson(Map<String, dynamic> json) {
    text = json["text"];
  }

  String? text;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    return data;
  }
}
