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
                        padding: const EdgeInsets.all(8.0),
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
                        padding: const EdgeInsets.all(8.0),
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