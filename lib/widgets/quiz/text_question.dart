import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_text_button.dart';
import 'package:audioplayers/audio_cache.dart';

class TextQuestion extends StatefulWidget {
  final QuizQuestion question;
  final List<VoidCallback> onTaps;
  static final AudioCache audioPlayer = new AudioCache();

  TextQuestion({this.question, this.onTaps});

  @override
  _TextQuestionState createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.question.image.path),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: Color.fromARGB(190, 0, 0, 0),
                    height: (MediaQuery.of(context).size.width / 10) * 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.question.text,
                          style: Theme.of(context).textTheme.headline,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        widget.question.audio != null
                            ? OutlineButton.icon(
                                onPressed: () {
                                  TextQuestion.audioPlayer.play(
                                    widget.question.audio.path.substring(
                                      widget.question.audio.path.indexOf('/') +
                                          1,
                                    ),
                                  );
                                },
                                label: Text(
                                  "Listen",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.5),
                                icon: Icon(
                                  FontAwesomeIcons.music,
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: widget.question.trueFalseAnswer
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          QuizTextButton(
                            onTap: widget.onTaps[1],
                            text: "Yes",
                          ),
                          QuizTextButton(
                            onTap: widget.onTaps[0],
                            text: "No",
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            QuizTextButton(
                              onTap: widget.onTaps[0],
                              text: widget.question.answers[0].text,
                            ),
                            QuizTextButton(
                              onTap: widget.onTaps[1],
                              text: widget.question.answers[1].text,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          QuizTextButton(
                            onTap: widget.onTaps[2],
                            text: widget.question.answers[2].text,
                          ),
                          QuizTextButton(
                            onTap: widget.onTaps[3],
                            text: widget.question.answers[3].text,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        )
      ],
    );
  }
}
