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
                            ? await model.stop()
                            : await model.speak(model.isPause ? model.newEnd! : model.speak(model.english));
                        setState(() {});
                      },
                      icon: Icon(
                        model.ttsState == TtsState.playing ? Icons.pause_circle_outline : Icons.play_circle_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    /*IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {
                        model.speak(model.abc);
                        model.ttsState == TtsState.stopped
                            ? await model.speak(model.abc)
                            : await model.speak(model.isPause ? model.newEnd! : model.speak(model.abc));
                      },
                      icon: const Icon(Icons.refresh_outlined, size: 40, color: Colors.white),
                    ),*/
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
                        model.ttsState == TtsState.stopped;
                        model.changeLanguage
                            ? model.ttsState == TtsState.stopped
                                ? null
                                : model.speakEnglish(model.english)
                            : null;
                        setState(() {});
                      },
                      child: const Text('English')),
                  ElevatedButton(
                      onPressed: () {
                        model.ttsState == TtsState.stopped;
                        model.changeLanguage
                            ? model.ttsState == TtsState.stopped
                                ? null
                                : model.speakTurkish(model.turkish)
                            : null;
                        setState(() {});
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
    });
  }
}
