import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:flutter/material.dart';

class ActivityPassSaveBar extends StatelessWidget {
  final VoidCallback onTapSave;
  final VoidCallback onTapPass;

  ActivityPassSaveBar({@required this.onTapSave, this.onTapPass});

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
                8.0,
              ),
              child: OutlineButton(
                onPressed: this.onTapPass ?? () => Navigator.of(context).pop(),
                borderSide: BorderSide(
                  color: HexColor("FF777777"),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: BodyText(
                  'Pass',
                  size: Screen.isTablet(context)
                      ? 30
                      : Screen.isSmall(context) ? 14 : 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                8.0,
                Screen.width(context, percentage: 3),
                8.0,
              ),
              child: OutlineButton(
                onPressed: onTapSave,
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
