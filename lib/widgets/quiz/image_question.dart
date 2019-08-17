import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/custom_grid.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_image_button.dart';

class ImageQuestion extends StatefulWidget {
  final QuizQuestion question;
  final List<QuizImageButton> answers;

  ImageQuestion({this.question, this.answers});

  @override
  _ImageQuestionState createState() => _ImageQuestionState();
}

class _ImageQuestionState extends State<ImageQuestion> {
  AudioPlayer player = AudioPlayer();
  bool get hasAudio => widget.question.audio != null;

  void playAudio() {
    player.play(widget.question.audio.path, isLocal: true);
  }

  Widget buildAudioButton() {
    return OutlineButton.icon(
      onPressed: () => playAudio(),
      label: Body('Listen'),
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
            children: <Widget>[
              Padding(
                padding:  EdgeInsets.only(top:  Screen.height(context, percentage: 5), bottom:  Screen.height(context, percentage: 3)),
                child: Container(
                  color: Color.fromARGB(190, 0, 0, 0),
                  height: Screen.height(context, percentage: 20),
                  width: Screen.width(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubHeading(widget.question.text),
                      if(hasAudio) Padding(
                        padding: EdgeInsets.only(top:  Screen.height(context, percentage: 2)),
                        child: buildAudioButton(),
                      ),
                    ],
                  ),
                ),
              ),
              CustomGrid(children: widget.answers),
            ],
          ),
        )),
      ],
    );
  }
}
