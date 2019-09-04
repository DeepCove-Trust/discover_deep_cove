import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class ActivityAppBar extends StatelessWidget with PreferredSizeWidget {
  final String text;

  ActivityAppBar(this.text);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(),
      title: SubHeading(
        text,
        size:
            Screen.isTablet(context) ? 30 : Screen.isSmall(context) ? 16 : null,
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      brightness: Brightness.dark,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
