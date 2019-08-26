import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
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
                        padding: EdgeInsets.symmetric(horizontal: Screen.width(context) - Screen.width(context,
                            percentage: Screen.isTablet(context) &&
                                    Screen.isLandscape(context)
                                ? 97.5
                                : Screen.isTablet(context)
                                    ? 94
                                    : Screen.isSmall(context) ? 85 : 90), vertical: 8.0,),
                        child: OutlineButton(
                          onPressed: () => Navigator.of(context).pop(),
                          borderSide: BorderSide(
                            color: HexColor("FF777777"),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Body(
                            'Pass',
                            size: Screen.width(context) >= 600
                                ? 30
                                : Screen.width(context) <= 350 ? 16 : 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Screen.width(context) - Screen.width(context,
                            percentage: Screen.isTablet(context) &&
                                    Screen.isLandscape(context)
                                ? 97.5
                                : Screen.isTablet(context)
                                    ? 95
                                    : Screen.isSmall(context) ? 85 : 90), vertical: 8.0,),
                        child: OutlineButton(
                          onPressed: () => onTap,
                          borderSide: BorderSide(
                            color: HexColor("FF777777"),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Body(
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