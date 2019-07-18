import 'package:discover_deep_cove/widgets/misc/heading_text.dart';
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
        width: MediaQuery.of(context).size.width / 2.5,
        height: (MediaQuery.of(context).size.width / 2.5) / 1.5,
        child: Center(
          child: HeadingText(
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