import 'package:flutter/material.dart';

import 'body_text.dart';

class BottomBackButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColorDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: BodyText(
                  text: 'Back',
                  align: TextAlign.center,
                )),
          ),
        ],
      ),
    );
  }
}