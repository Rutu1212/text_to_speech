import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../base_model.dart';

enum TtsState { playing, stopped }

class SolutionHomeScreenViewModel extends BaseModel {
  FlutterTts flutterTts = FlutterTts();
  String abc =
      'Description is the pattern of narrative development that aims to make vivid a place, object, character, or group. Description is one of four rhetorical modes, along with exposition, argumentation, and narration, In practice it would be difficult to write literature that drew on just one of the four basic modes.';

  String? newEnd;
  int pause = 0;
  String? word;
  int start = 0;
  int startNew = 0;
  int endNew = 0;
  int end = 0;
  bool isPause = false;

  TtsState ttsState = TtsState.stopped;

  initTts() {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
      updateUI();
    });
    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
      updateUI();
    });
    flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      start = startOffset;
      startNew = startOffset;
      endNew = endOffset;
      end = endOffset;
      print("Start ::: $start");
      print("endddddd::$end");
      updateUI();
    });
  }

  textFromInput() {
    String pausedString = abc.substring(0, (start + pause));
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: isPause == true ? pausedString : abc.substring(0, start), style: const TextStyle(color: Colors.black, fontSize: 20)),
            TextSpan(
                text: abc.substring(start + pause, end + pause),
                style: const TextStyle(backgroundColor: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
            TextSpan(text: abc.substring(pause + end), style: const TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  speak(String text) async {
    end = 0;
    start = 0;
    if (isPause) {
      pause = pause + endNew;
    } else {
      pause = endNew;
    }
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    updateUI();
  }

  stop() async {
    isPause = true;
    print("Start When Stop::: $start");
    print("End when Stop ::$end");
    await flutterTts.stop();
    ttsState = TtsState.stopped;
    if (isPause) {
      newEnd = abc.substring(pause + end);
    } else {
      newEnd = abc.substring(end);
    }
    updateUI();
  }
}
