import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';

class BottomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColorDark,
      child: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical : Screen.height(context, percentage: 1.5)),
          child: BodyText( 'Back'),
        )
      ),
    );
  }
}
