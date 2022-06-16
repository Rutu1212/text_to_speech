import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../base_model.dart';

enum TtsState { playing, stopped }

class SolutionHomeScreenViewModel extends BaseModel {
  FlutterTts flutterTts = FlutterTts();

  // String english =
  //     'Description is the pattern of narrative development that aims to make vivid or place, object, character, or group. Description is one of four rhetorical modes, along with exposition, argumentation, and narration, In practice it would be difficult to write literature that drew on just one of the four basic modes.';
  // String turkish =
  //     'Tanımlama, bir yeri, nesneyi, karakteri veya grubu canlı kılmayı amaçlayan anlatı geliştirme modelidir. Açıklama, açıklama, tartışma ve anlatımla birlikte dört retorik moddan biridir. Pratikte dört temel moddan sadece birine dayanan bir edebiyat yazmak zor olurdu.';

  List<String> englishList = [
    'Description is the pattern of narrative development that aims to make vivid or place, object, character, or group. Description is one of four rhetorical modes, along with exposition, argumentation, and narration, In practice it would be difficult to write literature that drew on just one of the four basic modes.',
    'In this post, we are going to show you the array List basis of Dart or Flutter. In Dart, the array is called List. In this article, you will learn example-wise how to create and use Array in Dart or Flutter',
    'The dissipation rate can also be estimated from less specialized instruments. Breaking internal waves, like that shown in Figure, lift dense water above light water',
  ];
  List<String> turkishList = [
    'Tanımlama, bir yeri, nesneyi, karakteri veya grubu canlı kılmayı amaçlayan anlatı geliştirme modelidir. Açıklama, açıklama, tartışma ve anlatımla birlikte dört retorik moddan biridir. Pratikte dört temel moddan sadece birine dayanan bir edebiyat yazmak zor olurdu.',
    "Bu yazıda, size Dart veya Flutter'ın dizi listesi temelini göstereceğiz. Dart'ta diziye Liste denir. Bu makalede, Dart veya Flutter'da Array'in nasıl oluşturulacağını ve kullanılacağını örnek olarak öğreneceksiniz.",
    'Dağılma oranı, daha az uzmanlaşmış araçlardan da tahmin edilebilir. Şekil de gösterildiği gibi iç dalgaları kırmak, yoğun suyu hafif suyun üzerine kaldırır.',
  ];

  joinString() {
    String englishJoin = englishList.join('\n');
    String turkishJoin = turkishList.join('\n');
    print(englishJoin);
    print(turkishJoin);
  }

  String? englishJoin;
  String? turkishJoin;

  String? newEnd;
  bool fromTurkish = false;
  int pause = 0;
  int start = 0;
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
      end = endOffset;
      updateUI();
    });
  }

  textFromInput() {
    String pausedString = english.substring(0, (start + pause));
    String pausedTurkishString = turkish.substring(0, (start + pause));
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: isPause == true
                    ? (fromTurkish ? pausedTurkishString : pausedString)
                    : (fromTurkish ? turkish.substring(0, start) : english.substring(0, start)),
                style: const TextStyle(color: Colors.black, fontSize: 19)),
            TextSpan(
                text: fromTurkish
                    ? turkish.substring(
                        start != 0
                            ? start + pause == start + pause
                                ? (start + pause)
                                : end + pause
                            : isPause
                                ? pause + start
                                : 0,
                        end + pause)
                    : english.substring(
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
                text: fromTurkish ? turkish.substring(pause + end) : english.substring(pause + end),
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
    await flutterTts.setLanguage(fromTurkish ? "tr-TR" : "en-US");
    await flutterTts.speak(text);
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.3);
    updateUI();
  }

  stop() async {
    isPause = true;
    await flutterTts.stop();
    ttsState = TtsState.stopped;
    if (isPause) {
      newEnd = fromTurkish ? turkish.substring(pause + end) : english.substring(pause + end);
    } else {
      newEnd = fromTurkish ? turkish.substring(end) : english.substring(end);
    }
    updateUI();
  }
}
