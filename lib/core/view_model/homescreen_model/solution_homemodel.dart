import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../base_model.dart';

enum TtsState { playing, stopped }

class SolutionHomeScreenViewModel extends BaseModel {
  FlutterTts flutterTts = FlutterTts();
  String english =
      'Description is the pattern of narrative development that aims to make vivid a place, object, character, or group. Description is one of four rhetorical modes, along with exposition, argumentation, and narration, In practice it would be difficult to write literature that drew on just one of the four basic modes. ';
  String turkish =
      'Tanımlama, bir yeri, nesneyi, karakteri veya grubu canlı kılmayı amaçlayan anlatı geliştirme modelidir. Açıklama, açıklama, tartışma ve anlatımla birlikte dört retorik moddan biridir. Pratikte dört temel moddan sadece birine dayanan bir edebiyat yazmak zor olurdu.';
  String? newEnd;
  String? newEndT;
  int pause = 0;
  int start = 0;
  int end = 0;
  bool isPause = false;
  bool changeLanguage = true;

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
      end = endOffset;
      print("Start ::: $start");
      print("Endddddd::$end");
      updateUI();
    });
  }

  textFromInput() {
    String pausedString = english.substring(0, (start + pause));
    print(
        "%%%%%%%%%%%%%${english.substring(start != 0 ? start + pause == start + pause ? (start + pause) : end + pause : isPause ? pause + start : 0, end + pause)}");
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: changeLanguage
                    ? isPause == true
                        ? pausedString
                        : english.substring(0, start)
                    : isPause == true
                        ? turkish.substring(0, (start + pause))
                        : turkish.substring(0, start),
                style: const TextStyle(color: Colors.black, fontSize: 19)),
            TextSpan(
                text: changeLanguage
                    ? english.substring(
                        start != 0
                            ? start + pause == start + pause
                                ? (start + pause)
                                : end + pause
                            : isPause
                                ? pause + start
                                : 0,
                        end + pause)
                    : turkish.substring(
                        start != 0
                            ? start + pause == start + pause
                                ? (start + pause)
                                : end + pause
                            : isPause
                                ? pause + start
                                : 0,
                        end + pause),
                style: const TextStyle(backgroundColor: Colors.red, fontSize: 19)),
            TextSpan(
                text: changeLanguage ? english.substring(pause + end) : turkish.substring(pause + end),
                style: const TextStyle(color: Colors.black, fontSize: 19)),
          ],
        ),
      ),
    );
  }

  speak(String text) async {
    if (isPause) {
      pause = pause + end;
    } else {
      pause = end;
    }
    end = 0;
    start = 0;
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.3);
    updateUI();
  }

  speakEnglish(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.3);
    changeLanguage = true;
    end = 0;
    start = 0;
    updateUI();
  }

  speakTurkish(String text) async {
    await flutterTts.setLanguage("tr-TR");
    await flutterTts.speak(text);
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.3);
    changeLanguage = false;
    end = 0;
    start = 0;
    updateUI();
  }

  stop() async {
    isPause = true;
    print("Start When Stop::: $start");
    print("End when Stop ::$end");
    await flutterTts.stop();
    ttsState = TtsState.stopped;

    if (isPause) {
      newEnd = english.substring(pause + end);
    } else {
      newEnd = english.substring(end);
    }

    if (changeLanguage) {
      newEndT = turkish.substring(pause + end);
    } else {
      newEndT = turkish.substring(end);
    }
    updateUI();
  }
}
