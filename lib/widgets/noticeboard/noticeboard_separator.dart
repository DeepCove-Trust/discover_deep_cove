
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final String title;

  Separator(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      height: Screen.height(context, percentage: 8),
      child: Center(
        child: SubHeading(
          title,
          size:
          Screen.isTablet(context) ? 30 : Screen.isSmall(context) ? 16 : 20,
        ),
      ),
    );
  }
}