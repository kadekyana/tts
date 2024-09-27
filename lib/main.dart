import 'package:flutter/material.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:get/get.dart';
import 'package:tts/app/modules/Level/controllers/level_controller.dart';
import 'package:tts/app/routes/app_pages.dart';
import 'package:tts/sql_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inisialisasiDatabase();
  runApp(SpeechQuizApp());
}

Future<void> inisialisasiDatabase() async {
  await SQLHelper.db();
  print('Database berhasil diinisialisasi');
  SQLHelper.checkScoreData();
  SQLHelper.checkLevelsData();
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
    Get.put(LevelController());
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
