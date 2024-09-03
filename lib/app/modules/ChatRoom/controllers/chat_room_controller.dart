import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatRoomController extends GetxController {
  late stt.SpeechToText speech;
  late FlutterTts flutterTts;
  bool isListening = false;
  String text = '';

  bool speechAvailable = false;

  var currentIndex = 0.obs;
  var showNextButton = false.obs;
  RxList<bool> isTypingComplete =
      <bool>[].obs; // List to track typing completion
  var isAnswerReady = <bool>[].obs; // List to track answer readiness

  List<Map<String, String>> conversations = [
    {
      'text': "Hi there! How's your day going?",
      'answer': "Hi! It's going pretty well, thanks. How about you?"
    },
    {
      'text':
          "Not too bad. I'm just glad to take a break and grab a coffee. Speaking of which, have you decided what you're getting?",
      'answer': "I think I'll go for a cappuccino. What about you?"
    },
    {
      'text':
          "I'm in the mood for a latte today. Oh, and maybe a slice of cake too.",
      'answer':
          "That sounds like a good idea. Which cake are you thinking of getting? "
    },
    {
      'text': "Probably the chocolate fudge cake. It's my weakness!",
      'answer':
          "Haha, can't go wrong with chocolate! Alright, I'll go order our drinks and cake."
    },
  ];

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
    flutterTts = FlutterTts();
    initializeSpeechRecognition();

    // Initialize the lists with the number of conversations
    isTypingComplete.value =
        List.generate(conversations.length, (index) => false);
    isAnswerReady.value = List.generate(conversations.length, (index) => false);
  }

  void initializeSpeechRecognition() async {
    speechAvailable = await speech.initialize();
    if (!speechAvailable) {
      showSpeechNotAvailableDialog();
    }
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

  void stopListening(String answer) {
    isListening = false;
    update();
    speech.stop();
    checkAnswer(answer);
  }

  void checkAnswer(String answer) {
    if (text.toLowerCase() == answer.toLowerCase()) {
      Get.snackbar('Correct', 'Correct Answer!');
      speakCorrectAnswer();
      showNextButton.value = true; // Show next button
    } else {
      Get.snackbar('Wrong', 'Wrong Answer!');
      speakWrongAnswer();
      showNextButton.value = true; // Hide next button
    }
    isTypingComplete[currentIndex.value] =
        true; // Mark typing complete for the current index
    isAnswerReady[currentIndex.value] =
        true; // Mark answer ready for the current index
    update();
  }

  Future<void> speakCorrectAnswer() async {
    await flutterTts.speak('Correct! The answer is $text');
  }

  Future<void> speakWrongAnswer() async {
    int type = int.parse(currentIndex.value.toString());
    await flutterTts
        .speak('Wrong! The correct answer is ${conversations[type]['answer']}');
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  void showSpeechNotAvailableDialog() {
    // Implementasi dialog
  }

  void nextConversation() {
    if (currentIndex.value < conversations.length - 1) {
      currentIndex.value++;
      showNextButton.value =
          false; // Hide button after moving to next conversation
      isTypingComplete[currentIndex.value] =
          false; // Reset typing complete status
      isAnswerReady[currentIndex.value] = false; // Reset answer readiness
      update();
    }
  }
}


// class ChatRoomController extends GetxController {
//   late stt.SpeechToText speech;
//   late FlutterTts flutterTts;
//   bool isListening = false;
//   String text = '';

//   bool speechAvailable = false;

//   var currentIndex = 0.obs;
//   var showNextButton = false.obs;
//   var isTypingComplete = false.obs;

//   List<Map<String, String>> conversations = [
//     {
//       'text': "Hi there! How's your day going?",
//       'answer': "Hi! It's going pretty well, thanks. How about you?"
//     },
//     {
//       'text':
//           "Not too bad. I'm just glad to take a break and grab a coffee. Speaking of which, have you decided what you're getting?",
//       'answer': "I think I'll go for a cappuccino. What about you?"
//     },
//     {
//       'text':
//           "I'm in the mood for a latte today. Oh, and maybe a slice of cake too.",
//       'answer':
//           "That sounds like a good idea. Which cake are you thinking of getting? "
//     },
//     {
//       'text': "Probably the chocolate fudge cake. It's my weakness!",
//       'answer':
//           "Haha, can't go wrong with chocolate! Alright, I'll go order our drinks and cake."
//     },
//   ];

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

//   void stopListening(String answer) {
//     isListening = false;
//     update();
//     speech.stop();
//     checkAnswer(answer);
//   }

//   void checkAnswer(String answer) {
//     if (text.toLowerCase() == answer.toLowerCase()) {
//       Get.snackbar('Correct', 'Correct Answer!');
//       speakCorrectAnswer();
//       showNextButton.value = true; // Show next button
//       isTypingComplete.value = true; // Indicate typing is complete
//     } else {
//       Get.snackbar('Wrong', 'Wrong Answer!');
//       speakWrongAnswer();
//       showNextButton.value = true; // Hide next button
//       isTypingComplete.value = true; // Indicate typing is complete
//     }
//     update();
//   }

//   Future<void> speakCorrectAnswer() async {
//     await flutterTts.speak('Correct! The answer is $text');
//   }

//   Future<void> speakWrongAnswer() async {
//     int type = int.parse(currentIndex.value.toString());
//     await flutterTts
//         .speak('Wrong! The correct answer is ${conversations[type]['answer']}');
//   }

//   Future<void> speak(String text) async {
//     await flutterTts.speak(text);
//   }

//   void showSpeechNotAvailableDialog() {
//     // Implementasi dialog
//   }

//   void nextConversation() {
//     if (currentIndex.value < conversations.length - 1) {
//       currentIndex.value++;
//       showNextButton.value =
//           false; // Hide button after moving to next conversation
//       isTypingComplete.value = false; // Reset typing complete status
//       update();
//     }
//   }
// }
