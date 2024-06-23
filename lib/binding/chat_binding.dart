import "package:gemini_demo/controller/chat_controller.dart";
import "package:get/get.dart";

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ChatController.new);
  }
}
