class GeminiSuccessResponseModel {
  GeminiSuccessResponseModel({this.candidates, this.usageMetadata});

  GeminiSuccessResponseModel.fromJson(Map<String, dynamic> json) {
    if (json["candidates"] != null) {
      candidates = <Candidates>[];
      for (final dynamic v in json["candidates"] as List<dynamic>) {
        candidates!.add(Candidates.fromJson(v));
      }
    }
    usageMetadata = json["usageMetadata"] != null
        ? UsageMetadata.fromJson(json["usageMetadata"])
        : null;
  }

  List<Candidates>? candidates;
  UsageMetadata? usageMetadata;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (candidates != null) {
      data["candidates"] =
          candidates!.map((Candidates v) => v.toJson()).toList();
    }
    if (usageMetadata != null) {
      data["usageMetadata"] = usageMetadata!.toJson();
    }
    return data;
  }
}

class Candidates {
  Candidates({this.content, this.finishReason, this.index, this.safetyRatings});

  Candidates.fromJson(Map<String, dynamic> json) {
    content =
        json["content"] != null ? Content.fromJson(json["content"]) : null;
    finishReason = json["finishReason"];
    index = json["index"];
    if (json["safetyRatings"] != null) {
      safetyRatings = <SafetyRatings>[];
      for (final dynamic v in json["safetyRatings"] as List<dynamic>) {
        safetyRatings!.add(SafetyRatings.fromJson(v));
      }
    }
  }

  Content? content;
  String? finishReason;
  int? index;
  List<SafetyRatings>? safetyRatings;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data["content"] = content!.toJson();
    }
    data["finishReason"] = finishReason;
    data["index"] = index;
    if (safetyRatings != null) {
      data["safetyRatings"] =
          safetyRatings!.map((SafetyRatings v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  Content({this.parts, this.role});

  Content.fromJson(Map<String, dynamic> json) {
    if (json["parts"] != null) {
      parts = <Parts>[];
      for (final dynamic v in json["parts"] as List<dynamic>) {
        parts!.add(Parts.fromJson(v));
      }
    }
    role = json["role"];
  }

  List<Parts>? parts;
  String? role;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (parts != null) {
      data["parts"] = parts!.map((Parts v) => v.toJson()).toList();
    }
    data["role"] = role;
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

class SafetyRatings {
  SafetyRatings({this.category, this.probability});

  SafetyRatings.fromJson(Map<String, dynamic> json) {
    category = json["category"];
    probability = json["probability"];
  }

  String? category;
  String? probability;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["category"] = category;
    data["probability"] = probability;
    return data;
  }
}

class UsageMetadata {
  UsageMetadata({
    this.promptTokenCount,
    this.candidatesTokenCount,
    this.totalTokenCount,
  });

  UsageMetadata.fromJson(Map<String, dynamic> json) {
    promptTokenCount = json["promptTokenCount"];
    candidatesTokenCount = json["candidatesTokenCount"];
    totalTokenCount = json["totalTokenCount"];
  }

  int? promptTokenCount;
  int? candidatesTokenCount;
  int? totalTokenCount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["promptTokenCount"] = promptTokenCount;
    data["candidatesTokenCount"] = candidatesTokenCount;
    data["totalTokenCount"] = totalTokenCount;
    return data;
  }
}
