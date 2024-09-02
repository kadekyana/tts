import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts/app/routes/app_pages.dart';

void main() {
  runApp(SpeechQuizApp());
}

class SpeechQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
