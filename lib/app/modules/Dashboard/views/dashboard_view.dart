import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controllerDashboard =
      Get.put(DashboardController());
  DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffA0DACF),
        body: SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height,
            child: Column(
              children: [
                Container(
                  width: Get.width * 0.7,
                  height: Get.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/menu.png'),
                    ),
                  ),
                ),
                Container(
                  width: Get.width * 0.6,
                  height: Get.height * 0.05,
                  child: FittedBox(
                    child: Text(
                      'Are You Ready To Learn ?',
                      style: TextStyle(
                          fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: Get.width * 0.7,
                  height: Get.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/dialog.png'),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/home');
                  },
                  child: Container(
                    width: Get.width * 0.5,
                    height: Get.height * 0.05,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffFDC024),
                        boxShadow: [BoxShadow(offset: Offset(0, 3))]),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Start',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ));
  }
}
