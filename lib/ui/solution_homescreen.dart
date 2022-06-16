import 'package:flutter/material.dart';

import '../core/view_model/base_view.dart';
import '../core/view_model/homescreen_model/solution_homemodel.dart';

class SolutionHomeScreen extends StatefulWidget {
  const SolutionHomeScreen({Key? key}) : super(key: key);

  @override
  State<SolutionHomeScreen> createState() => _SolutionHomeScreenState();
}

class _SolutionHomeScreenState extends State<SolutionHomeScreen> {
  SolutionHomeScreenViewModel? model;

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    model.joinString();
  }*/

  @override
  Widget build(BuildContext context) {
    return BaseView<SolutionHomeScreenViewModel>(builder: ((buildContext, model, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: RichText(
              text: const TextSpan(
                text: 'Ubamm',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 23),
                children: [
                  TextSpan(
                    text: 'Wellness',
                    style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              model.textFromInput(),
              const Spacer(),
              Container(
                height: 70,
                width: MediaQuery.of(context).size.width * 1,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {
                        model.ttsState == TtsState.playing
                            ? model.stop()
                            : model.fromTurkish
                                ? await model.speak(model.isPause ? model.newEnd : model.speak(model.turkish))
                                : await model.speak(model.isPause ? model.newEnd : model.speak(model.english));
                        setState(() {});
                      },
                      icon: Icon(
                        model.ttsState == TtsState.playing ? Icons.pause_circle_outline : Icons.play_circle_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        model.fromTurkish = false;
                        if (model.ttsState == TtsState.playing || model.ttsState == TtsState.stopped) {
                          // await model.flutterTts.stop();
                          model.isPause = false;
                          model.start = 0;
                          model.end = 0;
                          // await model.speak(model.english);
                          if (model.isPause == true) {
                            model.ttsState == TtsState.stopped ? model.stop() : model.speak(model.english);
                          } else if (model.isPause == false) {
                            model.ttsState == TtsState.playing ? model.speak(model.english) : model.stop();
                          }
                        }
                      },
                      child: const Text('English')),
                  ElevatedButton(
                      onPressed: () async {
                        model.fromTurkish = true;
                        if (model.ttsState == TtsState.playing || model.ttsState == TtsState.stopped) {
                          // await model.flutterTts.stop();
                          model.isPause = false;
                          model.start = 0;
                          model.end = 0;
                          // await model.speak(model.turkish);
                          if (model.isPause == true) {
                            model.ttsState == TtsState.stopped ? model.stop() : model.speak(model.turkish);
                          } else if (model.isPause == false) {
                            model.ttsState == TtsState.playing ? model.speak(model.turkish) : model.stop();
                          }
                        }
                      },
                      child: const Text('Turkish')),
                ],
              ),
              const Divider(
                color: Colors.white,
                height: 20,
              ),
            ],
          ),
        ),
      );
    }), onModelReady: (model) async {
      this.model = model;
      model.initTts();
      model.joinString();
    });
  }
}
