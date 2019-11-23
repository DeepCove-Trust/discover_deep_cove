import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class QuizTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const QuizTextButton({@required this.onTap, @required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Screen.width(context, percentage: 40.0),
        height: Screen.height(context, percentage: 13.5),
        child: Center(
          child: SubHeading(text, size: Screen.isTablet(context) ? 25 : 20,),
        ),
        decoration: new BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(offset: Offset(1, 1), blurRadius: 3)]
        ),
      ),
    );
  }
}
