import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:typewritertext/typewritertext.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  ChatRoomView({Key? key}) : super(key: key);

  var answerQuestion = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffA0DACF),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Listen And Speaking',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Color(0xffA0DACF),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        width: Get.width,
        height: Get.height,
        child: GestureDetector(
          child: Obx(() => ListView.builder(
                itemCount: controller.currentIndex.value + 1,
                itemBuilder: (BuildContext context, int index) {
                  final dataChat = controller.conversations[index];
                  bool cek = index == controller.currentIndex.value;
                  answerQuestion.value = dataChat['answer']!;

                  return Column(
                    children: [
                      ChatItem(
                        controller: controller,
                        Sendder: false,
                        textChat: dataChat['text']!,
                        onTextFinished: () {
                          controller.isTypingComplete[index] = true;
                          controller.update();
                        },
                      ),
                      Obx(() {
                        return controller.isTypingComplete[index]
                            ? ChatItem(
                                controller: controller,
                                Sendder: true,
                                textChat: dataChat['answer']!,
                                onTextFinished: () {},
                              )
                            : SizedBox
                                .shrink(); // Tidak menampilkan apa-apa jika belum selesai
                      }),
                      if (cek)
                        Align(
                          alignment: Alignment.centerRight,
                          child: GetBuilder<ChatRoomController>(
                            builder: (controller) {
                              print(controller.showNextButton.value);
                              return controller.showNextButton.value
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.nextConversation();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        width: Get.width * 0.3,
                                        height: Get.height * 0.04,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xffFDC024),
                                            boxShadow: [
                                              BoxShadow(offset: Offset(0, 3))
                                            ]),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Next Dialog',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                    )
                                  : SizedBox
                                      .shrink(); // Hide button if not needed
                            },
                          ),
                        ),
                    ],
                  );
                },
              )),
        ),
      ),
      bottomNavigationBar: Container(
        width: Get.width,
        height: Get.height * 0.2,
        child: Column(
          children: [
            GetBuilder<ChatRoomController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: TextEditingController(text: controller.text),
                    readOnly: true,
                    maxLines: null,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        labelText: 'Your Speak',
                        labelStyle: TextStyle(fontFamily: 'Poppins'),
                        hintText: 'Your spoken text will appear here',
                        hintStyle: TextStyle(fontFamily: 'Poppins')),
                  ),
                );
              },
            ),
            Spacer(),
            GetBuilder<ChatRoomController>(
              builder: (controller) {
                return controller.isListening
                    ? GestureDetector(
                        onTap: () {
                          controller.stopListening(answerQuestion.value);
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
                                'Stop Speaking',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          controller.startListening();
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
                                'Start Speaking',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
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
    required this.onTextFinished,
  });

  final String textChat;
  final ChatRoomController controller;
  final bool Sendder;
  final VoidCallback onTextFinished;

  @override
  Widget build(BuildContext context) {
    controller.speak(textChat);
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
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            )),
                        child: TypeWriter.text(
                          textChat,
                          textAlign: TextAlign.justify,
                          onFinished: (value) {
                            onTextFinished();
                          },
                          duration: Duration(milliseconds: 50),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            )),
                        child: TypeWriter.text(
                          textChat,
                          textAlign: TextAlign.justify,
                          onFinished: (value) {
                            onTextFinished();
                          },
                          duration: Duration(milliseconds: 70),
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