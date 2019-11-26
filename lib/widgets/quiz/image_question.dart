import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/custom_grid.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_image_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageQuestion extends StatefulWidget {
  final QuizQuestion question;
  final List<QuizImageButton> answers;
  final AudioPlayer player;

  ImageQuestion({this.question, this.answers, this.player});

  @override
  _ImageQuestionState createState() => _ImageQuestionState();
}

class _ImageQuestionState extends State<ImageQuestion>
    with WidgetsBindingObserver {
  Color playingColor = Colors.white;

  bool get hasAudio => widget.question.audio != null;
  StreamSubscription _playerCompleteSubscription;
  double height;

  void playAudio() {
    setState(() => playingColor = Theme.of(context).primaryColor);
    widget.player.play(Env.getResourcePath(widget.question.audio.path), isLocal: true);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _playerCompleteSubscription = widget.player.onPlayerCompletion.listen((event) {
      _onComplete();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.player.stop();

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
    widget.player.stop();
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
          borderRadius: BorderRadius.circular(15)),
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

  buildContent() {
    return (Screen.isTablet(context) && !Screen.isPortrait(context))
        ? Row(
            children: <Widget>[
              Expanded(child: questionComponentLandscape()),
              answerComponent()
            ],
          )
        : Column(
            children: <Widget>[
              Expanded(
                child: questionComponentPortrait(),
              ),
              answerComponent(),
            ],
          );
  }

  questionComponentPortrait() {
    return Container(
        color: Color.fromARGB(190, 0, 0, 0),
        padding: EdgeInsets.all(24),
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SubHeading(widget.question.text),
                  hasAudio ? buildAudioButton() : Container()
                ],
              ),
            ),
          ),
        ));
  }

  questionComponentLandscape() {
    return Container(
        color: Color.fromARGB(190, 0, 0, 0),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SubHeading(widget.question.text),
            hasAudio ? buildAudioButton() : Container()
          ],
        ));
  }

  answerComponent() {
    return Expanded(
      flex: Screen.isPortrait(context) ? 2 : 1,
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
}
