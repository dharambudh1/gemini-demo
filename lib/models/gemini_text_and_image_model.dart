class GeminiTextAndImageModel {
  GeminiTextAndImageModel({this.contents});

  GeminiTextAndImageModel.fromJson(Map<String, dynamic> json) {
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
  Parts({this.text, this.inlineData});

  Parts.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    inlineData = json["inline_data"] != null
        ? InlineData.fromJson(json["inline_data"])
        : null;
  }

  String? text;
  InlineData? inlineData;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    if (inlineData != null) {
      data["inline_data"] = inlineData!.toJson();
    }
    return data;
  }
}

class InlineData {
  InlineData({this.mimeType, this.data});

  InlineData.fromJson(Map<String, dynamic> json) {
    mimeType = json["mime_type"];
    data = json["data"];
  }
  
  String? mimeType;
  String? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["mime_type"] = mimeType;
    data["data"] = this.data;
    return data;
  }
}
