import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatRoomController extends GetxController {
  late stt.SpeechToText speech;
  late FlutterTts flutterTts;
  bool isListening = false;
  String text = '';
  int currentIndex = 0;
  bool speechAvailable = false;
  List<Map<String, String>> conversations = [
    {
      'text': 'Hi Beni, what did you learn in school today?',
      'answer': "We had a new lesson about plants in science class"
    },
    {
      'text': 'What is your favorite subject?',
      'answer': "My favorite subject is science"
    },
    // Tambahkan percakapan lainnya di sini
  ];

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
    flutterTts = FlutterTts();
    initializeSpeechRecognition();
  }

  void initializeSpeechRecognition() async {
    // Implementasi inisialisasi
  }

  void startListening() async {
    if (speechAvailable) {
      isListening = true;
      update();
      speech.listen(onResult: (result) {
        text = result.recognizedWords;
        update();
      });
    } else {
      showSpeechNotAvailableDialog();
    }
  }

  void stopListening() {
    isListening = false;
    update();
    speech.stop();
    checkAnswer();
  }

  void checkAnswer() {
    String currentAnswer = conversations[currentIndex]['answer'] ?? '';
    if (text.toLowerCase() == currentAnswer.toLowerCase()) {
      Get.snackbar('Correct', 'Correct Answer!');
      speakCorrectAnswer();
    } else {
      Get.snackbar('Wrong', 'Wrong Answer!');
      speakWrongAnswer();
    }
    // Pindah ke percakapan berikutnya
    nextConversation();
  }

  Future<void> speakCorrectAnswer() async {
    await flutterTts.speak('Correct! The answer is $text');
  }

  Future<void> speakWrongAnswer() async {
    await flutterTts.speak(
        'Wrong! The correct answer is ${conversations[currentIndex]['answer']}');
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  void showSpeechNotAvailableDialog() {
    // Implementasi dialog
  }

  void nextConversation() {
    if (currentIndex < conversations.length - 1) {
      currentIndex++;
      update();
    }
  }
}



// class ChatRoomController extends GetxController {
//   late stt.SpeechToText speech;
//   late FlutterTts flutterTts;
//   bool isListening = false;
//   String text = '';
//   String tes = 'Hi Beni, what did you learn in school today?';
//   String Answer = "We had a new lesson about plants in science class";
//   bool speechAvailable = false;

//   @override
//   void onInit() {
//     super.onInit();
//     speech = stt.SpeechToText();
//     flutterTts = FlutterTts();
//     initializeSpeechRecognition();
//   }

//   void initializeSpeechRecognition() async {
//     speechAvailable = await speech.initialize();
//     if (!speechAvailable) {
//       showSpeechNotAvailableDialog();
//     }
//   }

//   void startListening() async {
//     if (speechAvailable) {
//       isListening = true;
//       update();
//       speech.listen(onResult: (result) {
//         text = result.recognizedWords;
//         update();
//       });
//     } else {
//       showSpeechNotAvailableDialog();
//     }
//   }

//   void stopListening() {
//     isListening = false;
//     update();
//     speech.stop();
//     checkAnswer();
//   }

//   void checkAnswer() {
//     if (text.toLowerCase() == Answer.toLowerCase()) {
//       Get.snackbar('Correct', 'Correct Answer!');
//       speakCorrectAnswer();
//     } else {
//       Get.snackbar('Wrong', 'Wrong Answer!');
//       speakWrongAnswer();
//     }
//   }

//   // Fungsi untuk membacakan teks yang benar
//   Future<void> speakCorrectAnswer() async {
//     await flutterTts.speak('Correct! The answer is $text');
//   }

//   Future<void> speakWrongAnswer() async {
//     await flutterTts.speak('Wrong! The correct answer is $Answer');
//   }

//   Future<void> speak(String text) async {
//     await flutterTts.speak(text);
//   }

//   void showSpeechNotAvailableDialog() {
//     Get.dialog(
//       AlertDialog(
//         title: Text('Speech Recognition Unavailable'),
//         content: Text(
//             'Speech recognition is not available on your device. Please try again later or use a different device.'),
//         actions: <Widget>[
//           TextButton(
//             child: Text('OK'),
//             onPressed: () {
//               Get.back();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
