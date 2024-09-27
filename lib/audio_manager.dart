import 'package:assets_audio_player/assets_audio_player.dart';

class AudioManagerInit {
  static final AudioManagerInit _instance = AudioManagerInit._internal();

  factory AudioManagerInit() {
    return _instance;
  }

  AudioManagerInit._internal();

  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();
  bool isPlaying = false;

  void init() {
    _audioPlayer.open(Audio('assets/images/kuis.mp3'),
        autoStart: true, loopMode: LoopMode.single);
  }

  void playMusic() {
    _audioPlayer.play();
    isPlaying = true;
  }

  void pauseMusic() {
    _audioPlayer.pause();
    isPlaying = false;
  }
}
