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
                        print("model.newEnd tts state ${model.ttsState} :english:: ${model.isPause}:: ${model.newEnd}");
                        model.ttsState == TtsState.playing
                            ? await model.stop()
                            : await model.speak(model.isPause ? model.newEnd : await model.speak(model.english));
                      },
                      child: const Text('English')),
                  ElevatedButton(
                      onPressed: () async {
                        model.fromTurkish = true;
                        print("model. tts state ::: ${model.ttsState} newEnd  ${model.isPause}:turkish:::: ${model.newEnd}");
                        model.ttsState == TtsState.playing
                            ? await model.stop()
                            : await model.speak(model.isPause ? model.newEnd : await model.speak(model.turkish));
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
