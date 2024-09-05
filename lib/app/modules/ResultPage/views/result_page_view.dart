import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/result_page_controller.dart';

class ResultPageView extends GetView<ResultPageController> {
  ResultPageView({Key? key}) : super(key: key);
  var scoreUser = Get.arguments;
  @override
  Widget build(BuildContext context) {
    print(scoreUser);
    return Scaffold(
        backgroundColor: Color(0xffA0DACF),
        body: SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: Get.width,
                          height: Get.height * 0.17,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/top.png'),
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                        Container(
                          width: Get.width,
                          height: Get.height * 0.15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/congrat.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width * 0.7,
                        height: Get.height * 0.25,
                        decoration: BoxDecoration(
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
                                    ? AssetImage('assets/images/full.png')
                                    : (scoreUser.value < 99 &&
                                            scoreUser.value >= 60)
                                        ? AssetImage('assets/images/3S.png')
                                        : (scoreUser.value < 59 &&
                                                scoreUser.value >= 30)
                                            ? AssetImage('assets/images/1S.png')
                                            : (scoreUser.value < 29 &&
                                                    scoreUser.value >= 0)
                                                ? AssetImage(
                                                    'assets/images/0S.png')
                                                : AssetImage(
                                                    'assets/images/0S.png'))),
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: Container(
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAndToNamed('level');
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          width: Get.width * 0.5,
                          height: Get.height * 0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffFDC024),
                              boxShadow: [BoxShadow(offset: Offset(0, 3))]),
                          child: Align(
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
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.bottomLeft,
                            image: AssetImage('assets/images/bottom.png'),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
        ));
  }
}
