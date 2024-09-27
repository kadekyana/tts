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

  var scoreUser = 0.0.obs;
  var currentIndex = 0.obs;
  var showNextButton = false.obs;
  RxList<bool> isTypingComplete = <bool>[].obs;
  var isAnswerReady = <bool>[].obs;
  List<String> resultWords = [];
  String? resultSentence;
  RxDouble scoreCorrect = 0.0.obs;
  RxDouble scoreWrong = 0.0.obs;

  final List<Map<String, String>> arguments = Get.arguments['conversations'];
  // List<Map<String, String>> conversations = [
  //   {
  //     'image': 'assets/images/1.png',
  //     'text': "Aisha is reading a book in the library",
  //     'answer': "Reading"
  //   },
  //   {
  //     'image': 'assets/images/2.png',
  //     'text': "Caca and Evi are going to school by bike",
  //     'answer': "Going"
  //   },
  //   {
  //     'image': 'assets/images/3.png',
  //     'text': "Leo and his friends are playing marbles in the schoolyard",
  //     'answer': "Playing"
  //   },
  // ];

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
    flutterTts = FlutterTts();
    initializeSpeechRecognition();

    // Initialize the lists with the number of conversations
    isTypingComplete.value = List.generate(arguments.length, (index) => false);
    isAnswerReady.value = List.generate(arguments.length, (index) => false);
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

  void Scoring() {
    int maxScore = 100;
    int totalQuestion = arguments.length;
    scoreCorrect.value = maxScore / totalQuestion;
    scoreWrong.value = scoreCorrect / 2;
    update();
    print(scoreCorrect);
    print(scoreWrong);
  }

  List<TextSpan> getHighlightedText(String text, String answer) {
    List<TextSpan> spans = [];
    List<String> words = text.split(' ');

    for (String word in words) {
      if (word.toLowerCase() == answer.toLowerCase()) {
        // Highlight kata yang cocok dengan answer
        spans.add(TextSpan(
          text: '$word ',
          style: TextStyle(
            color: Colors.green,
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else {
        // Tampilkan kata biasa
        spans.add(
          TextSpan(
            text: '$word ',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Poppins', fontSize: 18),
          ),
        );
      }
    }

    return spans;
  }

  void checkAnswer(String answer) async {
    Scoring();

    // Cek apakah pertanyaan sudah pernah dijawab
    if (isAnswerReady[currentIndex.value]) {
      Get.snackbar(
        'Warning',
        'You already tried it! Let\'s go to the next dialog',
        duration: Duration(seconds: 5),
        colorText: Colors.white,
        backgroundColor: Colors.blue,
      );
      await flutterTts
          .speak('You already tried it! Let\'s go to the next dialog');
    } else {
      // Create a list to store highlighted text
      String clearText = removePunctuation(text);

      List<TextSpan> highlightedText = getHighlightedText(clearText, answer);

      // Process the answer checking
      String clearAnswer = removePunctuation(answer);
      List<String> correctWords = clearText.split(' ');
      List<String> answerWords = clearAnswer.split(' ');

      // Reset resultWords and highlightedText for new data
      resultWords.clear();
      highlightedText.clear();

      // Compare word by word
      for (int i = 0; i < correctWords.length; i++) {
        if (i < answerWords.length &&
            correctWords[i].toLowerCase() == answerWords[i].toLowerCase()) {
          resultWords.add(correctWords[i]); // Correct answer
          highlightedText.add(TextSpan(
              text: correctWords[i], style: TextStyle(color: Colors.green)));
        } else {
          highlightedText.add(TextSpan(
              text: correctWords[i], style: TextStyle(color: Colors.red)));
        }
      }

      // Store the highlighted text for the current conversation
      // conversations[currentIndex.value]['highlightedText'] = highlightedText;

      // Check the overall answer correctness
      if (clearText.toLowerCase() == clearAnswer.toLowerCase()) {
        scoreUser.value += scoreCorrect.value;
        update();
        speakCorrectAnswer();
        showNextButton.value = true;
        Get.snackbar('Correct', 'Correct Answer!\nYour Score Now: $scoreUser',
            duration: Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.amber);
      } else {
        scoreUser.value += scoreWrong.value;
        update();
        speakWrongAnswer();
        showNextButton.value = true;
      }

      // Mark that the question has been answered
      isAnswerReady[currentIndex.value] = true;
    }
  }

  Future<void> speakCorrectAnswer() async {
    await flutterTts.speak('Correct! The answer is $text');
  }

  Future<void> speakWrongAnswer() async {
    int type = int.parse(currentIndex.value.toString());
    await flutterTts.speak(
        'Wrong! The correct answer is ${arguments[type]['answer']} & Here is where you went wrong: $resultSentence');
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  String removePunctuation(String input) {
    return input.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  void showSpeechNotAvailableDialog() {
    // Implementasi dialog
  }

  void nextConversation() {
    if (currentIndex.value < arguments.length - 1) {
      currentIndex.value++;
      showNextButton.value =
          false; // Sembunyikan tombol setelah dialog berikutnya
      isTypingComplete[currentIndex.value] = false; // Reset status typing
      isAnswerReady[currentIndex.value] = false; // Reset status jawaban
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
