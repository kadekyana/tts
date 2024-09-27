import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tts/app/modules/Level/controllers/level_controller.dart';

import '../controllers/result_page_controller.dart';

class ResultPageView extends GetView<ResultPageController> {
  ResultPageView({super.key});
  var scoreUser = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffA0DACF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height * 0.17,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/top.png'),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    height: Get.height * 0.15,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/congrat.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width * 0.7,
                    height: Get.height * 0.25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/trophy.png'),
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.8,
                    height: Get.height * 0.05,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (scoreUser == 100)
                            ? const AssetImage('assets/images/full.png')
                            : (scoreUser < 99 && scoreUser >= 60)
                                ? const AssetImage('assets/images/3S.png')
                                : (scoreUser < 59 && scoreUser >= 30)
                                    ? const AssetImage('assets/images/1S.png')
                                    : (scoreUser < 29 && scoreUser >= 0)
                                        ? const AssetImage(
                                            'assets/images/0S.png')
                                        : const AssetImage(
                                            'assets/images/0S.png'),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final controllerLevel = Get.put(LevelController());
                      await controllerLevel.fetchScores();
                      Get.offAndToNamed('/level');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: Get.width * 0.5,
                      height: Get.height * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffFDC024),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Back To Menu',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    height: Get.height * 0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.bottomLeft,
                        image: AssetImage('assets/images/bottom.png'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
