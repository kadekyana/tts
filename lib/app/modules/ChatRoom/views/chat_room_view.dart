import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        width: Get.width,
        height: Get.height,
        child: ListView.builder(
          itemCount: controller.conversations.length,
          itemBuilder: (BuildContext context, int index) {
            final dataChat = controller.conversations[index];
            return Column(
              children: [
                ChatItem(
                  controller: controller,
                  Sendder: false,
                  textChat: dataChat['text'] ?? '',
                ),
                ChatItem(
                  controller: controller,
                  Sendder: true,
                  textChat: dataChat['answer'] ?? '',
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        width: Get.width,
        height: Get.height * 0.15,
        child: Column(
          children: [
            GetBuilder<ChatRoomController>(
              builder: (controller) {
                return TextField(
                  controller: TextEditingController(text: controller.text),
                  readOnly: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Your spoken text will appear here',
                  ),
                );
              },
            ),
            GetBuilder<ChatRoomController>(
              builder: (controller) {
                return FilledButton(
                  onPressed: controller.isListening
                      ? controller.stopListening
                      : controller.startListening,
                  child: Text(controller.isListening
                      ? 'Stop Listening'
                      : 'Start Speak'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.textChat,
    required this.Sendder,
    required this.controller,
  });

  final String textChat;
  final ChatRoomController controller;
  final bool Sendder;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Sendder
          ? Row(
              children: [
                Expanded(child: Container()),
                Expanded(
                    child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: IconButton(
                    onPressed: () {
                      controller.speak(textChat);
                    },
                    icon: Icon(
                      Icons.volume_up_rounded,
                    ),
                  ),
                )),
                Expanded(
                  flex: 6,
                  child: GetBuilder<ChatRoomController>(
                    builder: (controller) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            )),
                        child: Text(
                          textChat,
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 6,
                  child: GetBuilder<ChatRoomController>(
                    builder: (controller) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            )),
                        child: Text(
                          textChat,
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      controller.speak(textChat);
                    },
                    icon: Icon(
                      Icons.volume_up_rounded,
                    ),
                  ),
                ),
                Expanded(child: Container())
              ],
            ),
    );
  }
}


// body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       Text(
      //         'Say something:',
      //         style: TextStyle(fontSize: 18),
      //       ),
      //       SizedBox(height: 10),
      //       GetBuilder<ChatRoomController>(
      //         builder: (controller) {
      //           return TextField(
      //             controller: TextEditingController(text: controller.text),
      //             readOnly: true,
      //             maxLines: null,
      //             decoration: InputDecoration(
      //               border: OutlineInputBorder(),
      //               hintText: 'Your spoken text will appear here',
      //             ),
      //           );
      //         },
      //       ),
      //       SizedBox(height: 10),
      //       GetBuilder<ChatRoomController>(
      //         builder: (controller) {
      //           return ElevatedButton(
      //             onPressed: controller.isListening
      //                 ? controller.stopListening
      //                 : controller.startListening,
      //             child: Text(controller.isListening
      //                 ? 'Stop Listening'
      //                 : 'Start Listening'),
      //           );
      //         },
      //       ),
      //       SizedBox(height: 10),
      //       ElevatedButton(
      //         onPressed: controller.checkAnswer,
      //         child: Text('Check Answer'),
      //       ),
      //       IconButton(
      //           onPressed: () {
      //             controller.speakTes();
      //           },
      //           icon: Icon(Icons.volume_up_rounded))
      //     ],
      //   ),
      // ),