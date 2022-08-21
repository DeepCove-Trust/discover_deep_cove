import 'package:flutter/material.dart';

import '../../util/screen.dart';

class ActivityPassSaveBar extends StatelessWidget {
  final VoidCallback onTapSave;
  final VoidCallback onTapPass;

  const ActivityPassSaveBar({@required this.onTapSave, this.onTapPass});

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
              child: OutlinedButton(
                onPressed: onTapPass ?? () => Navigator.of(context).pop(),
                // TODO: disabled color not working with outlined button find out if needed and how to implement
                // disabledTextColor: Theme.of(context).primaryColorDark,
                // disabledBorderColor: Theme.of(context).primaryColorDark,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white),
                  ),
                ),
                child: const Text(
                  'Pass',
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
              child: OutlinedButton(
                onPressed: onTapSave,
                // TODO: disabled color not working with outlined button find out if needed and how to implement
                // disabledTextColor: Theme.of(context).primaryColorDark,
                // disabledBorderColor: Theme.of(context).primaryColorDark,
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    BorderSide(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white),
                  ),
                ),
                child: const Text(
                  'Save',
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
