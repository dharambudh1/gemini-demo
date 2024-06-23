import "package:gemini_demo/binding/chat_binding.dart";
import "package:gemini_demo/screen/chat_screen.dart";
import "package:get/get.dart";

class AppRoutes {
  AppRoutes._();
  static final AppRoutes instance = AppRoutes._();

  String get chatScreen => "/";

  List<GetPage<dynamic>> get getPages {
    final GetPage<dynamic> getPages = GetPage<dynamic>(
      name: chatScreen,
      page: ChatScreen.new,
      binding: ChatBinding(),
    );
    return <GetPage<dynamic>>[getPages];
  }
}
