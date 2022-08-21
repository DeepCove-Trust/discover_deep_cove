import 'package:flutter/material.dart';

import '../../util/screen.dart';
import '../misc/text/sub_heading.dart';

class Separator extends StatelessWidget {
  final String title;

  const Separator(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      height: Screen.height(context, percentage: 8),
      child: Center(
        child: SubHeading(
          title,
          size: Screen.isTablet(context)
              ? 30
              : Screen.isSmall(context)
                  ? 16
                  : 20,
        ),
      ),
    );
  }
}
