import 'package:get/get.dart';

class LevelController extends GetxController {
  //TODO: Implement LevelController

  List<Map<String, String>> level = [
    {'no': "1", 'title': "Introduction", 'lock': "false"},
    {'no': "2", 'title': "Go To School", 'lock': "true"},
    {'no': "3", 'title': "Walk With Friends", 'lock': "true"},
    {'no': "4", 'title': "Go To My Vilage", 'lock': "true"},
    {'no': "5", 'title': "Good Bye Friends", 'lock': "true"},
  ];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
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
