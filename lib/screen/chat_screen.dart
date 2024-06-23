import "dart:io";

import "package:flutter/material.dart";
import "package:gemini_demo/controller/chat_controller.dart";
import "package:gemini_demo/models/custom_model.dart";
import "package:gemini_demo/models/gemini_failure_response_model.dart";
import "package:gemini_demo/models/gemini_success_response_model.dart";
import "package:gemini_demo/models/gemini_text_and_image_model.dart"
    as text_and_image;
import "package:gemini_demo/models/gemini_text_only_model.dart" as text_only;
import "package:gemini_demo/util/app_image_video_picker.dart";
import "package:get/get.dart";
import "package:path/path.dart";

class ChatScreen extends GetView<ChatController> {
  ChatScreen({super.key});

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final RxString _rxFilePath = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gemini Demo")),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Obx(
                () {
                  return listViewMainWidget(context: context);
                },
              ),
            ),
            textFieldWidget(context: context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget listViewMainWidget({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: controller.chatList.length,
        reverse: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (BuildContext context, int index) {
          final CustomModel data = controller.chatList.reversed.toList()[index];
          return listViewAdapterWidget(context: context, data: data);
        },
      ),
    );
  }

  Widget listViewAdapterWidget({
    required BuildContext context,
    required CustomModel data,
  }) {
    return Align(
      alignment: align(data: data),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          topMostLeftOrRightWidget(data: data, isForLeft: true),
          topMostLeftOrRightbesideWidget(data: data, isForLeft: true),
          flexibleChatMessageCard(context: context, data: data),
          topMostLeftOrRightWidget(data: data, isForLeft: false),
          topMostLeftOrRightbesideWidget(data: data, isForLeft: false),
        ],
      ),
    );
  }

  Widget topMostLeftOrRightWidget({
    required CustomModel data,
    required bool isForLeft,
  }) {
    return isForLeft
        ? SizedBox(width: align(data: data) == Alignment.centerLeft ? 0 : 32)
        : SizedBox(width: align(data: data) == Alignment.centerRight ? 0 : 32);
  }

  Widget topMostLeftOrRightbesideWidget({
    required CustomModel data,
    required bool isForLeft,
  }) {
    return isForLeft
        ? (align(data: data) == Alignment.centerLeft)
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: customCircleAvatar(iconData: Icons.blur_on),
              )
            : const SizedBox()
        : (align(data: data) == Alignment.centerRight)
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: customCircleAvatar(iconData: Icons.account_circle),
              )
            : const SizedBox();
  }

  Widget customCircleAvatar({required IconData iconData}) {
    return Card(
      elevation: 4,
      shape: const CircleBorder(),
      child: Icon(iconData),
    );
  }

  Widget flexibleChatMessageCard({
    required BuildContext context,
    required CustomModel data,
  }) {
    final bool hasText = data.messageText.isNotEmpty;
    final bool hasAttachment = data.hasAttachment;
    return Flexible(
      child: Card(
        elevation: 4,
        color: Theme.of(context).colorScheme.primary,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              if (hasAttachment)
                Image.memory(
                  decodeFromBase64(data.attachmentBase64),
                  height: 192,
                  width: 192,
                  fit: BoxFit.contain,
                )
              else
                const SizedBox(),
              SizedBox(height: hasText && hasAttachment ? 16 : 0),
              if (hasText)
                Text(
                  data.messageText,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Alignment align({required CustomModel data}) {
    return data.messageGeneratedByAI
        ? Alignment.centerLeft
        : Alignment.centerRight;
  }

  Widget textFieldWidget({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () {
          final bool hasAttachment = _rxFilePath.value.isNotEmpty;
          return Column(
            children: <Widget>[
              if (hasAttachment)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Image.file(
                      File(_rxFilePath.value),
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(basename(_rxFilePath.value)),
                  subtitle: const Text("📎 Attachment"),
                  trailing: IconButton(
                    onPressed: () {
                      _rxFilePath("");
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  onTap: () {},
                )
              else
                const SizedBox(),
              SizedBox(height: hasAttachment ? 16 : 0),
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: "Message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: IconButton(
                    onPressed: () async {
                      await AppImageVideoPicker().openImageVideoPicker(
                        filePathCallback: _rxFilePath.call,
                        isForVideo: false,
                      );
                    },
                    icon: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: funcSend,
                    icon: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> funcSend() async {
    final bool hasText = _textEditingController.value.text.isNotEmpty;
    final bool hasAttachment = _rxFilePath.value.isNotEmpty;

    if (hasText || hasAttachment) {
      final CustomModel sendMessage = funcSendMessage();

      final Map<String, dynamic> requestModel = sendMessage.hasAttachment
          ? text_and_image.GeminiTextAndImageModel(
              contents: <text_and_image.Contents>[
                text_and_image.Contents(
                  parts: <text_and_image.Parts>[
                    text_and_image.Parts(text: sendMessage.messageText),
                    text_and_image.Parts(
                      inlineData: text_and_image.InlineData(
                        mimeType: sendMessage.attachmentMimeType,
                        data: sendMessage.attachmentBase64,
                      ),
                    ),
                  ],
                ),
              ],
            ).toJson()
          : text_only.GeminiTextOnlyModel(
              contents: <text_only.Contents>[
                text_only.Contents(
                  parts: <text_only.Parts>[
                    text_only.Parts(text: sendMessage.messageText),
                  ],
                ),
              ],
            ).toJson();

      FocusManager.instance.primaryFocus?.unfocus();
      _textEditingController.clear();
      _rxFilePath("");

      await controller.makAnAPICall(
        requestModel: requestModel,
        successCallback: successCallbackAction,
        failureCallback: failureCallbackAction,
      );

      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    } else {
      const GetSnackBar snackBar = GetSnackBar(
        message: "Either write something or attach something.",
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red,
      );
      Get.showSnackbar(snackBar);
    }
    return Future<void>.value();
  }

  CustomModel funcSendMessage() {
    final bool hasAttachment = _rxFilePath.value.isNotEmpty;

    final CustomModel data = CustomModel(
      messageId: "",
      messageText: _textEditingController.value.text.trim(),
      messageTimestamp: DateTime.now().millisecondsSinceEpoch,
      messageGeneratedByAI: false,
      hasAttachment: hasAttachment,
      attachmentName: hasAttachment ? basename(_rxFilePath.value) : "",
      attachmentMimeType: hasAttachment ? getMimeType(_rxFilePath.value) : "",
      attachmentBase64: hasAttachment ? convertToBase64(_rxFilePath.value) : "",
    );

    controller.chatList.add(data);
    return data;
  }

  CustomModel successCallbackAction(GeminiSuccessResponseModel response) {
    String text = "";

    if (response.candidates?.isNotEmpty ?? false) {
      if (response.candidates?.first.content?.parts?.isNotEmpty ?? false) {
        text = response.candidates?.first.content?.parts?.first.text ?? "";
      } else {}
    } else {}

    final CustomModel data = CustomModel(
      messageId: "",
      messageText: text,
      messageTimestamp: DateTime.now().millisecondsSinceEpoch,
      messageGeneratedByAI: true,
      hasAttachment: false,
      attachmentName: "",
      attachmentMimeType: "",
      attachmentBase64: "",
    );

    controller.chatList.add(data);
    return data;
  }

  void failureCallbackAction(GeminiFailureResponseModel response) {
    final GetSnackBar snackBar = GetSnackBar(
      message: response.error?.message,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.red,
    );
    Get.showSnackbar(snackBar);
    return;
  }
}
