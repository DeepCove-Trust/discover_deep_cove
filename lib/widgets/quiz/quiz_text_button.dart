import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';

class QuizTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const QuizTextButton({this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Screen.width(context, percentage: 40),
        height: Screen.height(context, percentage: 13.5),
        child: Center(
          child: Heading(
            text: text,
          ),
        ),
        decoration: new BoxDecoration(
          border: new Border.all(
            color: Color(0xFF777777),
          ),
        ),
      ),
    );
  }
}
