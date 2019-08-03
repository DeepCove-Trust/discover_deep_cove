import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CorrectWrongOverlay extends StatefulWidget {
  final bool isCorrect;
  final String answer;
  final String guess;
  final VoidCallback onTap;

  CorrectWrongOverlay({this.isCorrect, this.answer, this.guess, this.onTap});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: Screen.height(context, percentage: 13.0),
              width: Screen.width(context, percentage: 75),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Transform.rotate(
                angle: _iconAnimation.value * 2 * pi,
                child: Icon(
                  widget.isCorrect == true
                      ? FontAwesomeIcons.check
                      : FontAwesomeIcons.times,
                  size: _iconAnimation.value * 80,
                  color: widget.isCorrect == true ? Colors.green : Colors.red,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Heading(
                widget.isCorrect == true
                    ? "Correct! ${widget.answer} is the right answer"
                    : "Wrong! You selected ${widget.guess} the correct answer is ${widget.answer}",
                align: TextAlign.center,
              ),
            ),
            SizedBox(
              height: Screen.height(context, percentage: 5.0),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: BodyText(
                  "Tap to proceed",
                  align: TextAlign.center,
                ),
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
