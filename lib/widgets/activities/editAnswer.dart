import 'package:flutter/material.dart';

import '../../util/screen.dart';

class EditAnswer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'To edit your answer, re-scan the QR code.',
      style: TextStyle(
        fontSize: Screen.isTablet(context)
            ? 25.0
            : Screen.isSmall(context)
                ? 14
                : 20,
        color: Theme.of(context).primaryColorLight,
      ),
      textAlign: TextAlign.center,
    );
  }
}
