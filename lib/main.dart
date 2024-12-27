import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
