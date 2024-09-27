import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:tts/app/modules/Level/controllers/level_controller.dart';
import 'package:typewritertext/typewritertext.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  ChatRoomView({Key? key}) : super(key: key);

  var answerQuestion = ''.obs;
  final Map<String, dynamic> arguments = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> conversations = arguments['conversations'];
    final int levelNo = arguments['no'];
    return Scaffold(
      backgroundColor: Color(0xffA0DACF),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Look And Say',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
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
                    final dataChat = conversations[index];
                    bool cek = index == controller.currentIndex.value;
                    bool isLastDialog = index == conversations.length - 1;
                    answerQuestion.value = dataChat['answer']!;

                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 200,
                            height: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(dataChat['image']!),
                                ),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ChatItem(
                          controller: controller,
                          Sendder: false,
                          textChat: dataChat['text']!,
                          highlightText: controller.getHighlightedText(
                              dataChat['text']!, dataChat['answer']!),
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
                                  highlightText: [],
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
                                          if (isLastDialog) {
                                            DateTime tanggal = DateTime.now();
                                            String timestamp =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(tanggal);

                                            // Konversi skor ke double
                                            double scoreDouble = double.parse(
                                                controller.scoreUser.value
                                                    .toString());

                                            // Lakukan pembulatan
                                            int score = scoreDouble
                                                .round(); // Akan membulatkan sesuai aturan .5 ke atas

                                            // SQLHelper.resultScore(
                                            //     score, timestamp, 1);
                                            final levelController =
                                                Get.find<LevelController>();
                                            levelController.updateLevelScore(
                                                levelNo, score);
                                            Get.offAllNamed('result-page',
                                                arguments:
                                                    score); // Kirim skor yang sudah dibulatkan
                                            print("Conversation finished");
                                          } else {
                                            controller.nextConversation();
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: 20, left: 10),
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
                                              isLastDialog
                                                  ? 'Finish'
                                                  : 'Next Dialog',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
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
                ))),
      ),
      bottomNavigationBar: Container(
        width: Get.width,
        height: Get.height * 0.2,
        child: Column(
          children: [
            Spacer(),
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
                    ? CircleAvatar(
                        child: SpinKitDoubleBounce(
                          color: Colors.red,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          controller.startListening();
                          Future.delayed(Duration(seconds: 3), () {
                            controller.stopListening(answerQuestion.value);
                          });
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
                                    fontSize: 26,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      );
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.highlightText,
    required this.textChat,
    required this.Sendder,
    required this.controller,
    required this.onTextFinished,
  });

  final List<TextSpan> highlightText;
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
                Transform(
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
                ),
                GetBuilder<ChatRoomController>(
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
                        "$textChat",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 20),
                        onFinished: (value) {
                          onTextFinished();
                        },
                        duration: Duration(milliseconds: 50),
                      ),
                    );
                  },
                ),
              ],
            )
          : Row(
              children: [
                GetBuilder<ChatRoomController>(
                  builder: (controller) {
                    return Container(
                      width: Get.width * 0.6,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          )),
                      child: TypewriterRichText(
                        textSpans: highlightText,
                        duration: Duration(milliseconds: 65),
                        onFinished: onTextFinished,
                      ),
                    );
                  },
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

class TypewriterRichText extends StatefulWidget {
  final List<TextSpan> textSpans;
  final Duration duration;
  final VoidCallback onFinished;

  const TypewriterRichText({
    Key? key,
    required this.textSpans,
    required this.duration,
    required this.onFinished,
  }) : super(key: key);

  @override
  _TypewriterRichTextState createState() => _TypewriterRichTextState();
}

class _TypewriterRichTextState extends State<TypewriterRichText> {
  // Untuk menyimpan jumlah karakter yang harus ditampilkan
  int _currentLength = 0;
  late String _fullText;

  @override
  void initState() {
    super.initState();
    _fullText = widget.textSpans.map((span) => span.text).join('');
    _startTypingEffect();
  }

  void _startTypingEffect() async {
    for (int i = 0; i <= _fullText.length; i++) {
      await Future.delayed(widget.duration);
      if (mounted) {
        setState(() {
          _currentLength = i;
        });
      }
    }
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil bagian teks yang harus ditampilkan
    String currentText = _fullText.substring(0, _currentLength);

    // Memetakan currentText ke TextSpan dengan highlight
    List<TextSpan> currentSpans = _mapTextToSpans(currentText);

    return RichText(
      text: TextSpan(children: currentSpans),
    );
  }

  // Fungsi untuk memetakan currentText ke highlight TextSpan
  List<TextSpan> _mapTextToSpans(String currentText) {
    List<TextSpan> spans = [];
    int charIndex = 0;

    for (var span in widget.textSpans) {
      String spanText = span.text!;
      String subSpanText = '';

      // Ambil substring jika currentText masih memuat bagian dari span ini
      if (charIndex + spanText.length <= currentText.length) {
        subSpanText = spanText;
      } else if (charIndex < currentText.length) {
        subSpanText = currentText.substring(charIndex, currentText.length);
      }

      spans.add(TextSpan(
        text: subSpanText,
        style: span.style,
      ));

      charIndex += spanText.length;
    }

    return spans;
  }
}
