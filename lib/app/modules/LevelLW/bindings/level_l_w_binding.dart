import 'package:get/get.dart';

import '../controllers/level_l_w_controller.dart';

class LevelLWBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LevelLWController>(
      () => LevelLWController(),
    );
  }
}
