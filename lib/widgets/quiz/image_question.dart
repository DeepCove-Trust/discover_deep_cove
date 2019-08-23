import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/custom_grid.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_image_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  double height;

  void playAudio() {
    player.play(Env.getResourcePath(widget.question.audio.path), isLocal: true);
  }

  Widget buildAudioButton() {
    return OutlineButton.icon(
      onPressed: () => playAudio(),
      label: Body('Listen'),
      borderSide: BorderSide(color: Colors.white, width: 0.5),
      icon: Icon(FontAwesomeIcons.music, color: Colors.white),
    );
  }

  buildContent() {
    return (Screen.isTablet(context) && !Screen.isPortrait(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              Column(
                children: <Widget>[
                  questionComponent(),
                ],
              ),
              Column(
                children: <Widget>[
                  answerComponent(),
                ],
              ),
            ],
          )
        : Column(
            children: <Widget>[
              questionComponent(),
              answerComponent(),
            ],
          );
  }

  answerComponent() {
    return Expanded(
      child: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomGrid(children: widget.answers),
          ],
        ),
      ),
    );
  }

  questionComponent() {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: Screen.isPortrait(context)
          ? height / 3
          : height - Screen.height(context, percentage: 4.5),
      child: Column(
        mainAxisAlignment: Screen.isPortrait(context)
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: Screen.height(context, percentage: 5),
              left: Screen.height(context,
                  percentage: Screen.isPortrait(context) ? 0 : 3),
              bottom: Screen.height(context, percentage: 3),
            ),
            child: Container(
              color: Color.fromARGB(190, 0, 0, 0),
              height: Screen.height(context, percentage: 20),
              width: Screen.width(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubHeading(widget.question.text),
                  if (hasAudio)
                    Padding(
                      padding: EdgeInsets.only(
                        top: Screen.height(context, percentage: 2),
                      ),
                      child: buildAudioButton(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          height = constraints.maxHeight;
          return buildContent();
        },
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
