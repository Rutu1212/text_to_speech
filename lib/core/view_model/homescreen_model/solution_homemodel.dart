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
  bool isPause = false;

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
      print("startOffset: ${startOffset} || endOffset: ${endOffset}");
      print("pauseStart: ${pauseStart} || pauseEnd: ${pauseEnd}");
      print("pauseStart: ${abc.substring(0, pauseStart + start)}");
      print("text1: ${abc.substring(0, pauseStart + start)}");
      print("highlight: ${word}");
      print("text2: ${abc.substring(pauseStart + end)}");
      print("All text: ${text}");
      start = startOffset;
      end = endOffset;
      this.word = word;
      updateUI();
    });
  }

  textFromInput() {
    /*print("&&&&&&&&&&&&&&&&&&&&&&&&&&${end}");
    // print(word);
    print('1jkghu1jhg1hghsrgretferte $start');
    print('222222222222 $pause');
    print('1jkghu1jhg1hghsrgretfexzvxbvcb cb vcn v nvnb n v nvnrte ${start + pause}');
    print('6565765767 $end');*/
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: isPause == true ? abc.substring(0, start + pause) : abc.substring(0, start),
                style: const TextStyle(color: Colors.black, fontSize: 20)),
            TextSpan(text: word ?? '', style: const TextStyle(backgroundColor: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
            TextSpan(text: abc.substring(pause + end), style: const TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  speak(String text) async {
    if (isPause) {
      pause = end;
    }
    start = 0;
    end = 0;
    updateUI();
    print('==============');
    print('start $start');
    print('pause $pauseStart');
    print('end $end');
    print("text: $text");
    print('==============');

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.5);
    await flutterTts.speak(text);
    await flutterTts.setVolume(0.5);
    updateUI();
  }

  stop() async {
    await flutterTts.stop();
    ttsState = TtsState.stopped;

    /* if (isPause) {
      print('1111111111111111111111111111');
      pauseStart = start;
      pauseEnd = end;
    } else if (pauseStart > 0) {
      print('00000000000000000000000000000');
      pauseStart = start;
      pauseEnd = end;
      print('else if start $pauseStart');
      print('else if end $pauseEnd');
    } else {
      print('222222222222222222222222');
      pauseStart = start;
      pauseEnd = end;
    }*/

    isPause = true;
    newEnd = abc.substring(end);
    print("======= STOP: $newEnd");

    print("0000000::$start");
    print(end);
    // start = 10;
    /*start = 0;
    end = 0;*/
    updateUI();
  }
}
