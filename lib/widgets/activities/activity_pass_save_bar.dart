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
                textColor: Colors.white,
                disabledTextColor: Theme.of(context).primaryColorDark,
                disabledBorderColor: Theme.of(context).primaryColorDark,
                borderSide: BorderSide(
                  color: Color(0xFF777777),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child:  Text(
                  "Pass",
                  style: TextStyle(fontSize: 20),
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
                textColor: Colors.white,
                disabledTextColor: Theme.of(context).primaryColorDark,
                disabledBorderColor: Theme.of(context).primaryColorDark,
                borderSide: BorderSide(
                  color: Color(0xFF777777),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
