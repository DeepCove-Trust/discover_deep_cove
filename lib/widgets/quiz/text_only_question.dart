import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/custom_grid.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextOnlyQuestion extends StatefulWidget {
  final QuizQuestion question;
  final List<Widget> answers;

  TextOnlyQuestion({this.question, this.answers});

  @override
  _TextOnlyQuestionState createState() => _TextOnlyQuestionState();
}

class _TextOnlyQuestionState extends State<TextOnlyQuestion>
    with WidgetsBindingObserver {
  AudioPlayer player = AudioPlayer();
  Color playingColor = Colors.white;

  bool get hasAudio => widget.question.audio != null;
  StreamSubscription _playerCompleteSubscription;

  double height;

  void playAudio() {
    setState(() => playingColor = Theme.of(context).primaryColor);
    player.play(Env.getResourcePath(widget.question.audio.path), isLocal: true);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _playerCompleteSubscription = player.onPlayerCompletion.listen((event) {
      _onComplete();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player.stop();

    _playerCompleteSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      stopAudio();
    }
  }

  stopAudio() {
    setState(() {
      playingColor = Colors.white;
    });
    player.stop();
  }

  void _onComplete() {
    setState(() => playingColor = Colors.white);
  }

  Widget buildAudioButton() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(7.5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        onPressed: () => playAudio(),
        icon: Icon(
          FontAwesomeIcons.music,
          color: playingColor,
          size: 30,
        ),
      ),
    );
  }

  buildContent() {
    return (Screen.isTablet(context) && !Screen.isPortrait(context))
        ? Row(
            children: <Widget>[questionComponent(), answerComponent()],
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomGrid(
            children: widget.answers,
            showAsColumn: Screen.isLandscape(context),
          ),
        ]),
      ),
    );
  }

  questionComponent() {
    return Expanded(
      child: Container(
        color: Color.fromARGB(190, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: Container(
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
