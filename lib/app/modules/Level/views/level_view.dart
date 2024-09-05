import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/level_controller.dart';

class LevelView extends GetView<LevelController> {
  const LevelView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffA0DACF),
      appBar: AppBar(
        backgroundColor: Color(0xffA0DACF),
        title: const Text(
          'Listen And Say Menu Level',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.toNamed('/home');
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
          width: Get.width,
          height: Get.height,
          child: ListView.builder(
              itemCount: controller.level.length,
              itemBuilder: (context, index) {
                final data = controller.level[index];
                return WidgetButton(
                    no: data["no"]!,
                    title: data['title']!,
                    lock: (data['lock'] == "true") ? true : false);
              })),
    );
  }
}

class WidgetButton extends StatelessWidget {
  WidgetButton(
      {super.key, required this.no, required this.title, required this.lock});

  String no;
  String title;
  bool lock;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/chat-room');
      },
      child: Container(
        width: Get.width * 0.8,
        height: Get.height * 0.1,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: (lock) ? Colors.black26 : Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 5), blurRadius: 5, color: Colors.black38),
            ]),
        child: Row(
          children: [
            Expanded(
                flex: (lock) ? 2 : 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/iconListen.png'),
                    ),
                  ),
                )),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level $no',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$title',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            (lock)
                ? Expanded(
                    child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/lock.png'),
                      ),
                    ),
                  ))
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
