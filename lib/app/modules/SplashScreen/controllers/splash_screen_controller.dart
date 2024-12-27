import 'package:get/get.dart';
import 'package:tts/app/modules/Dashboard/views/dashboard_view.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // Timer untuk splash screen
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => DashboardView()); // Pindah ke DashboardView setelah 3 detik
    });
  }
}
