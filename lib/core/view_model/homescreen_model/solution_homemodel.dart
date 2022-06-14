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
  int pauseStart = 0;
  int pauseEnd = 0;
  String? word;
  int start = 0;
  int end = 0;
  int lastLength = 0;
  bool isPause = false;
  bool isStop = false;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

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
      end = endOffset;
      lastLength = word.length;
      this.word = word;
      print("Start  ++++++   Pause : ${start + pause}");
      updateUI();
    });
  }

  textFromInput() {
    String pausedString = abc.substring(0, (start + pause));
    if (isStop) {
      print("-------------- ${pausedString.replaceRange((pausedString.length - (word ?? "").length), pausedString.length, "")}");
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: isPause == true
                    ? isStop
                        ? pausedString.replaceRange((pausedString.length - (word ?? "").length), pausedString.length, '')
                        : pausedString /*.substring(0, pausedString.length - (word ?? "").length) */ : abc.substring(0, start),
                style: const TextStyle(color: Colors.black, fontSize: 20)),
            TextSpan(text: word ?? "", style: const TextStyle(backgroundColor: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
            TextSpan(text: abc.substring(pause + end), style: const TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.5);
    await flutterTts.speak(text);
    isStop = false;
    await flutterTts.setVolume(0.5);
    updateUI();
  }

  stop() async {
    isStop = true;
    await flutterTts.stop();
    ttsState = TtsState.stopped;

    if (isPause) {
      newEnd = abc.substring(pause + end);
      pause = pause + end;
    } else {
      newEnd = abc.substring(end);
      pause = end;
    }

    end = 0;
    start = 0;
    isPause = true;
    print("=========================     $pause");
    print("======= STOP: $newEnd");
    print("Startttt::$start");
    print("endddddd::$end");
    print("ABD LENGTH : ${abc.length}");
    print("NEW LENGTH : ${newEnd!.length}");
    print("LENGTH : ${newEnd!.length + end}");
    updateUI();
  }
}
