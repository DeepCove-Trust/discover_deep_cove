import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:flutter/material.dart';

class ActivityPassSaveBar extends StatelessWidget {
  final VoidCallback onTap;

  ActivityPassSaveBar({this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        width: Screen.width(context),
        color: Theme.of(context).primaryColorDark,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                Screen.width(context, percentage: 3),
                8.0,
                0,
                12.0,
              ),
              child: OutlineButton(
                onPressed: () => Navigator.of(context).pop(),
                borderSide: BorderSide(
                  color: HexColor("FF777777"),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: BodyText(
                  'Pass',
                  size: Screen.width(context) >= 600
                      ? 30
                      : Screen.width(context) <= 350 ? 16 : 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                8.0,
                Screen.width(context, percentage: 3),
                12.0,
              ),
              child: OutlineButton(
                onPressed: onTap,
                borderSide: BorderSide(
                  color: HexColor("FF777777"),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: BodyText(
                  "Save",
                  size: Screen.width(context) >= 600
                      ? 30
                      : Screen.width(context) <= 350 ? 16 : 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
