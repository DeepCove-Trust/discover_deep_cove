import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';

class ActivityAppBar extends StatelessWidget with PreferredSizeWidget{
  final String text;

  ActivityAppBar(this.text);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(),
      title: Heading(
        text,
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      brightness: Brightness.dark,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
