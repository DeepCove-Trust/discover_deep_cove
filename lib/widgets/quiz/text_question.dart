import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/custom_grid.dart';
import 'package:discover_deep_cove/widgets/misc/image_source.dart';
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

class _TextQuestionState extends State<TextQuestion>
    with WidgetsBindingObserver {
  AudioPlayer player = AudioPlayer();
  Color playingColor = Colors.white;
  double height;
  StreamSubscription _playerCompleteSubscription;

  bool get hasAudio => widget.question.audio != null;

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
      setState(() {
        playingColor = Colors.white;
      });
      player.stop();
    }
  }

  void _onComplete() {
    setState(() => playingColor = Colors.white);
  }

  Widget buildAudioButton() {
    return OutlineButton.icon(
      onPressed: () => playAudio(),
      label: Text(
        'Listen',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: playingColor,
          fontSize: (Screen.isSmall(context) ? 16 : 20),
        ),
      ),
      borderSide: BorderSide(color: playingColor, width: 1.5),
      icon: Icon(FontAwesomeIcons.music, color: playingColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        return Scaffold(
          body: buildContent(),
          backgroundColor: Theme.of(context).backgroundColor,
        );
      },
    );
  }

  buildContent() {
    return (Screen.isTablet(context) && !Screen.isPortrait(context))
        ? Row(
      children: <Widget>[
        Expanded(child: questionComponentLandscape()),
        Expanded(child: Column(children: <Widget>[answerComponent()],),)
      ],
    )
        : Column(
            children: <Widget>[
              questionComponentPortrait(),
              answerComponent(),
            ],
          );
  }

  questionComponentPortrait() {
    return Column(
      children: <Widget>[
        Container(
          height: Screen.height(context, percentage: 50),
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
                    width: Screen.width(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: SubHeading(
                            widget.question.text,
                            size: Screen.isTablet(context) ? 30 : null,
                          ),
                        ),
                        if (hasAudio) buildAudioButton(),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: widget.question.image.source != null
                    ? ImageSource(
                  isCopyright: widget.question.image.showCopyright,
                  source: widget.question.image.source,
                )
                    : Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  questionComponentLandscape() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
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
                      width: Screen.width(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: SubHeading(
                              widget.question.text,
                            ),
                          ),
                          if (hasAudio) buildAudioButton(),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: widget.question.image.source != null
                      ? ImageSource(
                          isCopyright: widget.question.image.showCopyright,
                          source: widget.question.image.source,
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
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
}
