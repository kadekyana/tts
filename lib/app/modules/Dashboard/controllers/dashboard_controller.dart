import 'package:get/get.dart';
import 'package:tts/audio_manager.dart';

class DashboardController extends GetxController {
  //TODO: Implement DashboardController
  final AudioManagerInit audioManager = AudioManagerInit();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    audioManager.init();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
