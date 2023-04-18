import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lecle_volume_flutter/lecle_volume_flutter.dart';

class AudioPlayerBG {
  static AudioPlayerBG? _instance;

   AudioPlayer? _player;
  Future<AudioSession>? _session;

  int? _limit = 0;

  Timer? _timerDuration;

  AudioPlayerBG._internal() {

    _player = AudioPlayer(
      // Handle audio_session events ourselves for the purpose of this demo.
      handleInterruptions: false,
      androidApplyAudioAttributes: false,
      handleAudioSessionActivation: false,
    );
  }

  static AudioPlayerBG getInstance() {
    if (_instance == null) {
      _instance = AudioPlayerBG._internal();
    }
    return _instance!;
  }

  Future<void> _packagePlayer(String src) async {

    /*// Define the playlist
    var playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: audioSourceList,
    );*/

    await _player!.setAsset(src,

    );

    _player!.setLoopMode(LoopMode.one);

    _player!.play();
  }

  seek(Duration durationLeft) {
    _limit = durationLeft.inSeconds;
  }

  Future<void> playAudio(
      Duration durationMax, String src) async {
    _limit = durationMax.inSeconds;

    if (_timerDuration != null) {
      _timerDuration!.cancel();
      try {
     // await _player!.stop();
      } catch (e) {
        // TODO
      }
    }
    // Set a timer to stop audio playback after the specified duration

    _timerDuration = Timer.periodic(Duration(seconds: 1), (timer) {
      _limit = _limit! - 1;

      print("_limit===========${_player!.playing}");
      print(_limit);

      if (_limit! <= 0) {
        _player!.stop();
        _timerDuration!.cancel();
      }
    });
    await _packagePlayer(src);

  }

  Future<void> stop() async {
    await _player!.stop();
    //_player!.dispose();
    if (_timerDuration != null) _timerDuration!.cancel();
  }
  void pauseAudio() async {
    await _player!.pause;
    if (_timerDuration != null) _timerDuration!.cancel();
  }
  void resumeAudio() async {
    await _player!.play;
    if (_timerDuration != null) _timerDuration!.cancel();
    _timerDuration = Timer.periodic(Duration(seconds: 1), (timer) {
      _limit = _limit! - 1;

      print("_limit===========${_player!.playing}");
      print(_limit);

      if (_limit! <= 0) {
        _player!.stop();
        _timerDuration!.cancel();
      }
    });
  }

  bool isPlaying() {
    return _player!.playing;
  }

  IcyInfo? currentAudio() {
    try {
      return _player!.icyMetadata!.info;
    } catch (e) {
      return null;
    }
  }

  int getRemainingDuration() {
    return _limit ?? 0;
  }

  setVolume(vol){
    _player!.setVolume(vol);
  }
  bool IsSilenCall=false;

  void silenceIncomingCalls({bool silent = true}) async {
    IsSilenCall = silent;
    if (!silent) {//mistake cilo // real device a run dissi wait r music dynamic banaite partecina
      initAudioStreamType();
      setVol(androidVol: 5, iOSVol: 5.0, showVolumeUI: false);
      return;
    }

    _session =  AudioSession.instance;
    initAudioStreamType();
    setVol();

    _session?.then((audioSession) async {
      // This line configures the app's audio session, indicating to the OS the
      // type of audio we intend to play. Using the "speech" recipe rather than
      // "music" since we are playing a podcast.
      await audioSession.setActive(true);
      await audioSession.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      ));
      // Listen to audio interruptions and pause or duck as appropriate.
      listenCall(audioSession);

    });
  }
  Future<void> initAudioStreamType() async {
    await Volume.initAudioStream(AudioManager.streamRing);
  }

  void setVol(
      {int androidVol = 0,
      double iOSVol = 0.0,
      bool showVolumeUI = false}) async {
    await Volume.setVol(
      androidVol: androidVol,
      iOSVol: iOSVol,
      showVolumeUI: showVolumeUI,
    );
  }


  listenCall(AudioSession audioSession) {
    audioSession.interruptionEventStream.listen((event) async {
if(!IsSilenCall){
  return;
}
      print("==============dasfsdfsd==");
      print(event.begin);
      if (event.begin) {
        print("================");
        print(event.type);

        await _player!.stop();
        print("_player!.playing==sss");
        print(_player!.playing);
        await Future.delayed(Duration(milliseconds: 100));
        _player!.play();
        print("_player!.playing=======");
        print(_player!.playing);
      }
    });
  }
}
