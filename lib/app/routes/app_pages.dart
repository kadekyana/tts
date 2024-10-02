import 'package:get/get.dart';

import '../modules/ChatRoom/bindings/chat_room_binding.dart';
import '../modules/ChatRoom/views/chat_room_view.dart';
import '../modules/Dashboard/bindings/dashboard_binding.dart';
import '../modules/Dashboard/views/dashboard_view.dart';
import '../modules/Home/bindings/home_binding.dart';
import '../modules/Home/views/home_view.dart';
import '../modules/Level/bindings/level_binding.dart';
import '../modules/Level/views/level_view.dart';
import '../modules/LevelLW/bindings/level_l_w_binding.dart';
import '../modules/LevelLW/views/level_l_w_view.dart';
import '../modules/ResultPage/bindings/result_page_binding.dart';
import '../modules/ResultPage/views/result_page_view.dart';
import '../modules/SplashScreen/bindings/splash_screen_binding.dart';
import '../modules/SplashScreen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.RESULT_PAGE,
      page: () => ResultPageView(),
      binding: ResultPageBinding(),
    ),
    GetPage(
      name: _Paths.LEVEL,
      page: () => const LevelView(),
      binding: LevelBinding(),
    ),
    GetPage(
      name: _Paths.LEVEL_L_W,
      page: () => const LevelLWView(),
      binding: LevelLWBinding(),
    ),
  ];
}
