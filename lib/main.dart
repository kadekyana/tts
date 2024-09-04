import 'package:flutter/material.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:get/get.dart';
import 'package:tts/app/routes/app_pages.dart';

void main() {
  runApp(SpeechQuizApp());
}

Future<void> hideScreen() async {
  Future.delayed(Duration(milliseconds: 1800), () {
    FlutterSplashScreen.hide();
  });
}

class SpeechQuizApp extends StatefulWidget {
  @override
  State<SpeechQuizApp> createState() => _SpeechQuizAppState();
}

class _SpeechQuizAppState extends State<SpeechQuizApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hideScreen();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
