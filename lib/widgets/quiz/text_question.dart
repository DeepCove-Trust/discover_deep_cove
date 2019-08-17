import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/custom_grid.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/text/custom_h_grid.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_text_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextQuestion extends StatefulWidget {
  final QuizQuestion question;
  final List<QuizTextButton> answers;

  TextQuestion({this.question, this.answers});

  @override
  _TextQuestionState createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  AudioPlayer player = AudioPlayer();
  double height;

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

  buildContent() {
    return (Screen.isTablet(context) && !Screen.isPortrait(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  questionComponent(),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
            Screen.isPortrait(context)
                ? CustomGrid(children: widget.answers)
                : CustomHGrid(children: widget.answers)
          ],
        ),
      ),
    );
  }

  questionComponent() {
    return Column(
      children: <Widget>[
        Container(
          height: !Screen.isPortrait(context) ? height : Screen.height(context, percentage: 50),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(
                      File(
                        Env.getResourcePath(widget.question.image.path),
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: Color.fromARGB(190, 0, 0, 0),
                    height: Screen.height(context, percentage: 12),
                    width: Screen.width(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SubHeading(widget.question.text),
                        if (hasAudio) buildAudioButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
        return Scaffold(
          body: buildContent(),
          //backgroundColor: Theme.of(context).backgroundColor,
        );
      },
    );
  }
}
