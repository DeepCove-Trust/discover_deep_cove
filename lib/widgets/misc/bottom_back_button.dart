import 'package:flutter/material.dart';

import '../../util/screen.dart';
import '../activities/edit_answer.dart';
import 'text/body_text.dart';

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
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Screen.height(context, percentage: 1.5),
                ),
                child: const BodyText('Back'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
