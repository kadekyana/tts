import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/level_controller.dart';

class LevelView extends GetView<LevelController> {
  const LevelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.toNamed('/home');
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          backgroundColor: Color(0xffA0DACF),
          title: const Text(
            'Menu Level',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Look and Say'),
              Tab(text: 'Look and Write'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLevelList(controller.lookAndSayLevels, 'look_and_say'),
            _buildLevelList(controller.lookAndWriteLevels, 'look_and_write'),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan daftar level berdasarkan kategori
  Widget _buildLevelList(RxList<Map<String, String>> levels, String category) {
    return Obx(() {
      return ListView.builder(
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final data = levels[index];
          final isLocked = data['lock'] == "true";
          final score = (category == 'look_and_say')
              ? controller.lookAndSayScores[int.parse(data['no']!)] ?? 0
              : controller.lookAndWriteScores[int.parse(data['no']!)] ?? 0;

          return WidgetButton(
            no: data["no"]!,
            title: data['title']!,
            lock: isLocked,
            score: score,
            category: category,
          );
        },
      );
    });
  }
}

class WidgetButton extends StatelessWidget {
  WidgetButton({
    super.key,
    required this.no,
    required this.title,
    required this.lock,
    required this.score,
    required this.category,
  });

  final String no;
  final String title;
  final bool lock;
  final int score;
  final String category;

  @override
  Widget build(BuildContext context) {
    final levelController = Get.find<LevelController>();

    return GestureDetector(
      onTap: () {
        if (!lock) {
          // Kirim data percakapan ke halaman chat room
          int levelNo = int.parse(no);
          if (category == 'look_and_say') {
            List<Map<String, String>> conversations =
                levelController.getLookAndSayConversationsByLevel(levelNo);
            Get.toNamed('/chat-room', arguments: {
              'conversations': conversations,
              'no': levelNo,
              'mode': category
            });
          } else {
            List<Map<String, String>> conversations =
                levelController.getLookAndWriteConversationsByLevel(levelNo);
            Get.toNamed('/chat-room', arguments: {
              'conversations': conversations,
              'no': levelNo,
              'mode': category
            });
          }
        }
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
              offset: Offset(0, 5),
              blurRadius: 5,
              color: Colors.black38,
            ),
          ],
        ),
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
              ),
            ),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$title',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  if (!lock)
                    Text(
                      'Score: $score',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                ],
              ),
            ),
            if (lock)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/lock.png'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
