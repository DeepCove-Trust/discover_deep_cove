import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/activities/editAnswer.dart';
import 'package:flutter/material.dart';

import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';

class BottomBackButton extends StatelessWidget {
  final bool isReview;

  const BottomBackButton({this.isReview = false});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isReview
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EditAnswer(),
                )
              : Container(),
          Container(
            width: Screen.width(context),
            color: Theme.of(context).primaryColorDark,
            child: FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Screen.height(context, percentage: 1.5),
                ),
                child: Body('Back'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
