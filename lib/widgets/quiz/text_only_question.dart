import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/custom_grid.dart';
import 'package:discover_deep_cove/widgets/misc/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextOnlyQuestion extends StatefulWidget {
  final QuizQuestion question;
  final List<Widget> answers;

  TextOnlyQuestion({this.question, this.answers});

  @override
  _TextOnlyQuestionState createState() => _TextOnlyQuestionState();
}

class _TextOnlyQuestionState extends State<TextOnlyQuestion> {
  AudioPlayer player = AudioPlayer();

  bool get hasAudio => widget.question.audio != null;

  void playAudio() {
    player.play(widget.question.audio.path, isLocal: true);
  }

  Widget buildAudioButton() {
    return OutlineButton.icon(
      onPressed: () => playAudio(),
      label: BodyText(text: 'Listen', align: TextAlign.center),
      borderSide: BorderSide(color: Colors.white, width: 0.5),
      icon: Icon(FontAwesomeIcons.music, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0, bottom: 25),
                child: Container(
                  color: Color.fromARGB(190, 0, 0, 0),
                  height: (MediaQuery.of(context).size.height / 100) * 20,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SubHeading(text: widget.question.text),
                      if (hasAudio)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: buildAudioButton(),
                        ),
                    ],
                  ),
                ),
              ),
              CustomGrid(children: widget.answers)
            ],
          ),
        )),
      ],
    );
  }
}
