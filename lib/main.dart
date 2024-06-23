import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:gemini_demo/firebase_options.dart";
import "package:gemini_demo/util/app_routes.dart";
import "package:get/get.dart";
import "package:keyboard_dismisser/keyboard_dismisser.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();

  runApp(const MyApp());
}

Future<void> initializeApp() async {
  final FirebaseOptions options = DefaultFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(options: options);
  return Future<void>.value();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: GetMaterialApp(
        title: "Gemini Demo",
        navigatorKey: Get.key,
        theme: getThemeData(brightness: Brightness.light),
        darkTheme: getThemeData(brightness: Brightness.dark),
        initialRoute: AppRoutes.instance.getPages.first.name,
        initialBinding: AppRoutes.instance.getPages.first.binding,
        getPages: AppRoutes.instance.getPages,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData getThemeData({required Brightness brightness}) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      applyElevationOverlayColor: true,
    );
  }
}
