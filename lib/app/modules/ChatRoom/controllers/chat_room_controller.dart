import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatRoomController extends GetxController {
  late stt.SpeechToText speech;
  late FlutterTts flutterTts;
  bool isListening = false;
  String text = '';

  bool speechAvailable = false;

  var scoreUser = 0.obs;
  var currentIndex = 0.obs;
  var showNextButton = false.obs;
  RxList<bool> isTypingComplete =
      <bool>[].obs; // List to track typing completion
  var isAnswerReady = <bool>[].obs; // List to track answer readiness
  List<String> resultWords = [];
  String? resultSentence;

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

  void checkAnswer(String answer) async {
    print(isAnswerReady);

    if (isAnswerReady[currentIndex.value] == true) {
      Get.snackbar(
          'Warning', 'You already tried it! Let\'s go to the next dialog',
          duration: Duration(seconds: 5),
          colorText: Colors.white,
          backgroundColor: Colors.blue);
      await flutterTts
          .speak('You already tried it! Let\'s go to the next dialog');
    } else {
      String clearText = removePunctuation(text);
      String clearAnswer = removePunctuation(answer);

      // Pisahkan kalimat menjadi daftar kata
      List<String> correctWords = clearText.split(' ');
      List<String> answerWords = clearAnswer.split(' ');

      // Bandingkan kata demi kata
      for (int i = 0; i < correctWords.length; i++) {
        if (i < answerWords.length &&
            correctWords[i].toLowerCase() == answerWords[i].toLowerCase()) {
          resultWords.add(correctWords[i]); // Benar
        } else {
          resultWords.add(
            '[${correctWords[i]}]', // Salah, beri tanda (misalnya, dengan tanda kurung)
          );
        }
      }

      // Gabungkan hasil untuk ditampilkan ke pengguna
      resultSentence = resultWords.join(' ');

      if (clearText.toLowerCase() == clearAnswer.toLowerCase()) {
        scoreUser += 20;
        update();
        speakCorrectAnswer();
        showNextButton.value = true; // Tampilkan tombol next
        Get.snackbar('Correct', 'Correct Answer!\nYour Score Now: $scoreUser',
            duration: Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.amber);
      } else {
        scoreUser += 10;
        update();
        speakWrongAnswer();
        showNextButton.value = true; // Tampilkan tombol next
        Get.snackbar(
            'Wrong',
            'Wrong Answer!\nYour Score Now: $scoreUser\n'
                'Here is where you went wrong: $resultSentence',
            duration: Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red);
      }

      isTypingComplete[currentIndex.value] =
          true; // Tandai typing selesai untuk index saat ini
      isAnswerReady[currentIndex.value] =
          true; // Tandai jawaban siap untuk index saat ini
      update();
    }
  }

  Future<void> speakCorrectAnswer() async {
    await flutterTts.speak('Correct! The answer is $text');
  }

  Future<void> speakWrongAnswer() async {
    int type = int.parse(currentIndex.value.toString());
    await flutterTts.speak(
        'Wrong! The correct answer is ${conversations[type]['answer']} & Here is where you went wrong: $resultSentence');
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  String removePunctuation(String input) {
    // Menggunakan regex untuk menghapus tanda baca
    return input.replaceAll(RegExp(r'[^\w\s]'), '');
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
