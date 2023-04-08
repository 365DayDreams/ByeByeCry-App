import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:callkeep/callkeep.dart';

void startStopAudio(bool playAudio) async {
  final audioPlayer = AudioPlayer();
  final callKeep = FlutterCallkeep();
  var src=AssetSource("assets/audio.mp3");

  if (playAudio) {
    await audioPlayer.play(src);
    await callKeep.backToForeground();
  } else {
    await audioPlayer.stop();
  }

  callKeep.on(CallKeepPerformAnswerCallAction(), (CallKeepPerformAnswerCallAction event) async {
    // Stop audio playback when call is answered
    await audioPlayer.stop();
  });

  callKeep.on(CallKeepDidDisplayIncomingCall(), (CallKeepDidDisplayIncomingCall event) async {
    // Mute incoming call
    await callKeep.setMutedCall(event.callUUID!, true);
  });

  callKeep.on(CallKeepDidPerformDTMFAction(),
          (CallKeepDidPerformDTMFAction event) async {
    // Resume audio playback after DTMF is performed
    await audioPlayer.play(src);
  });

  callKeep.on(CallKeepPerformEndCallAction(), (CallKeepPerformEndCallAction event) async {
    // Stop audio playback when call is ended

    try {
      await audioPlayer.resume();
    }  catch (e) {
      // TODO
    }
  });
}
