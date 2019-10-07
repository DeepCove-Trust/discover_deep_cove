import 'package:discover_deep_cove/data/models/quiz/quiz_answer.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_image_button.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CorrectWrongOverlay extends StatefulWidget {
  final bool isCorrect;
  final bool isImageQuestion;
  final String answer;
  final String guess;
  final QuizAnswer imageGuess;
  final QuizAnswer imageAnswer;
  final VoidCallback onTap;

  CorrectWrongOverlay({
    this.isCorrect,
    this.isImageQuestion = false,
    this.answer,
    this.guess,
    this.imageAnswer,
    this.imageGuess,
    this.onTap,
  });

  @override
  State createState() => CorrectWrongOverlayState();
}

class CorrectWrongOverlayState extends State<CorrectWrongOverlay>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _iconAnimation = CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.elasticOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromARGB(190, 0, 0, 0),
      child: InkWell(
        onTap: () => widget.onTap(),
        child: widget.isImageQuestion
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: BodyText("You answered"),
                    ),
                  ),
                  QuizImageButton(
                    onTap: null,
                    image: widget.imageGuess.image,
                    text: widget.imageGuess.text,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: Screen.width(context, percentage: 20),
                    width: Screen.width(context, percentage: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Transform.rotate(
                      angle: _iconAnimation.value * 2 * pi,
                      child: Icon(
                        widget.isCorrect 
                            ? FontAwesomeIcons.check
                            : FontAwesomeIcons.times,
                        size: Screen.width(context, percentage: 15),
                        color: widget.isCorrect 
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  widget.isCorrect
                      ? Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: BodyText("That is the correct answer"),
                          ),
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: BodyText("The correct answer is..."),
                              ),
                            ),
                            QuizImageButton(
                              onTap: null,
                              image: widget.imageAnswer.image,
                              text: widget.imageAnswer.text,
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: BodyText("Tap to proceed"),
                    ),
                    decoration: new BoxDecoration(
                      border: new Border.all(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: Screen.width(context, percentage: 20),
                    width: Screen.width(context, percentage: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Transform.rotate(
                      angle: _iconAnimation.value * 2 * pi,
                      child: Icon(
                        widget.isCorrect
                            ? FontAwesomeIcons.check
                            : FontAwesomeIcons.times,
                        size: Screen.width(context, percentage: 15),
                        color: widget.isCorrect
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Heading(
                      widget.isCorrect 
                          ? "Correct! ${widget.answer} is the right answer"
                          : "Wrong! You selected ${widget.guess} the correct answer is ${widget.answer}",
                    ),
                  ),
                  SizedBox(
                    height: Screen.height(context, percentage: 5.0),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: BodyText("Tap to proceed"),
                    ),
                    decoration: new BoxDecoration(
                      border: new Border.all(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
