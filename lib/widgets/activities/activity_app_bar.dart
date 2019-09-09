import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivityAppBar extends StatelessWidget with PreferredSizeWidget {
  final String text;
  final VoidCallback onTap;

  ActivityAppBar(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(),
      title: SubHeading(
        text,
        size:
            Screen.isTablet(context) ? 30 : Screen.isSmall(context) ? 16 : null,
      ),
      actions: <Widget>[
        onTap == null
            ? IconButton(
                icon: Icon(
                  FontAwesomeIcons.book,
                  color: Colors.white,
                ),
                onPressed: () => onTap,
              )
            : Container(),
      ],
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      brightness: Brightness.dark,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
