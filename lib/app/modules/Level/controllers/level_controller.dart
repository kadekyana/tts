import 'package:get/get.dart';
import 'package:tts/sql_helper.dart';

class LevelController extends GetxController {
  var levels = <Map<String, String>>[
    {'no': "1", 'title': "What Are You Doing?", 'lock': "false"},
    {'no': "2", 'title': "There Are 67 English Books", 'lock': "true"},
    {
      'no': "3",
      'title': "My Living Room is Beside The Kitchen",
      'lock': "true"
    },
    {'no': "4", 'title': "Cici Cooks In The Kitchen", 'lock': "true"},
    {'no': "5", 'title': "Where Is My Pencil?", 'lock': "true"},
  ].obs;

  var scores = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchScores();
  }

  Future<void> fetchScores() async {
    final data = await SQLHelper.getScore();
    scores.clear();

    for (var row in data) {
      final levelNo = row['level_no'];
      scores[levelNo] = row['score'];

      if (levelNo < levels.length) {
        levels[levelNo]['lock'] = 'false';
      }
    }

    scores.refresh();
    update(); // Memicu observasi ulang
  }

  Future<void> updateLevelScore(int levelNo, int score) async {
    await SQLHelper.resultScore(score, DateTime.now().toString(), levelNo);
    scores[levelNo] = score;
    if (levelNo < levels.length) {
      levels[levelNo]['lock'] = 'false';
    }
    update();
  }

  // Fungsi untuk mendapatkan percakapan berdasarkan level
  List<Map<String, String>> getConversationsByLevel(int levelNo) {
    switch (levelNo) {
      case 1:
        return [
          {
            'image': 'assets/images/1.png',
            'text': "Aisha is reading a book in the library",
            'answer': "Reading"
          },
          {
            'image': 'assets/images/2.png',
            'text': "Cici is writing in the classroom",
            'answer': "Writing"
          },
          {
            'image': 'assets/images/3.png',
            'text': "Students are discussing in the classroom",
            'answer': "Discussing"
          },
          {
            'image': 'assets/images/4.png',
            'text': "Aisha and Cici are going to school by bike",
            'answer': "Going"
          },
          {
            'image': 'assets/images/5.png',
            'text': "Aisha and Cici are dancing 'Tari Piring' in the classroom",
            'answer': "Dancing 'Tari Piring'"
          },
        ];
      case 2:
        return [
          {
            'image': 'assets/images/6.png',
            'text': "Garage",
            'answer': "Garage"
          },
          {
            'image': 'assets/images/7.png',
            'text': "Living Room",
            'answer': "Living Room"
          },
        ];
      case 3:
        return [
          {
            'image': 'assets/images/6.png',
            'text': "Garage",
            'answer': "Garage"
          },
          {
            'image': 'assets/images/7.png',
            'text': "Living Room",
            'answer': "Living Room"
          },
          {
            'image': 'assets/images/8.png',
            'text': "The bath room is clean",
            'answer': "Clean"
          },
          {
            'image': 'assets/images/9.png',
            'text': "The bedroom is dirty",
            'answer': "Dirty"
          },
          {
            'image': 'assets/images/10.png',
            'text': "The kitchen is clean",
            'answer': "Clean"
          },
        ];
      case 4:
        return [
          {
            'image': 'assets/images/11.png',
            'text': "Mr. Ilham reads a book in the living room",
            'answer': "reads"
          },
          {
            'image': 'assets/images/12.png',
            'text': "Joshua watches TV every Saturday",
            'answer': "Watches"
          },
          {
            'image': 'assets/images/13.png',
            'text': "Cici sleeps in the bedroom",
            'answer': "Sleeps"
          },
          {
            'image': 'assets/images/14.png',
            'text': "Joshua takes a bath everyday",
            'answer': "Takes_A_Bath"
          },
          {
            'image': 'assets/images/15.png',
            'text': "Mrs. Neneng cooks in the kitchen",
            'answer': "Cooks"
          },
        ];
      // Tambahkan percakapan untuk level lainnya
      default:
        return [];
    }
  }
}
