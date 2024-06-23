class CustomModel {
  CustomModel({
    required this.messageId,
    required this.messageText,
    required this.messageTimestamp,
    required this.messageGeneratedByAI,
    required this.hasAttachment,
    required this.attachmentName,
    required this.attachmentMimeType,
    required this.attachmentBase64,
  });

  final String messageId;
  final String messageText;
  final int messageTimestamp;
  final bool messageGeneratedByAI;
  final bool hasAttachment;
  final String attachmentName;
  final String attachmentMimeType;
  final String attachmentBase64;
}

CustomModel emptyModel() {
  return CustomModel(
    messageId: "",
    messageText: "",
    messageTimestamp: 0,
    messageGeneratedByAI: false,
    hasAttachment: false,
    attachmentName: "",
    attachmentMimeType: "",
    attachmentBase64: "",
  );
}
