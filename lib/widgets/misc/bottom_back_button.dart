import 'package:flutter/material.dart';

import 'package:discover_deep_cove/widgets/misc/text/body.dart';

class BottomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColorDark,
      child: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical : 20),
          child: Body( 'Back'),
        )
      ),
    );
  }
}
