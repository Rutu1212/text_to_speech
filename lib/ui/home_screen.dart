import 'package:flutter/material.dart';

import '../core/view_model/base_view.dart';
import '../core/view_model/homescreen_model/homemodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenViewModel? model;

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeScreenViewModel>(builder: ((buildContext, model, child) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {
                        model.ttsState == TtsState.playing
                            ? await model.stop()
                            : await model.speak(/*model.isPause ? model.newEnd! :*/ model.isPause == false ? model.speak(model.abc) : model.newEnd!);
                        setState(() {});
                      },
                      icon: Icon(model.ttsState == TtsState.playing ? Icons.pause_circle_outline : Icons.play_circle_outline,
                          size: 40, color: Colors.white),
                    ),
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {
                        model.ttsState == TtsState.playing
                            ? await model.speak(model.abc)
                            : await model.speak(/*model.isPause ? model.newEnd! :*/ model.abc);
                      },
                      icon: Icon(Icons.refresh_outlined, size: 40, color: model.ttsState == TtsState.playing ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
                height: 40,
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
