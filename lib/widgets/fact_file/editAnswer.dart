import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

class EditAnswer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "To edit your answer, re-scan the QR code.",
      style: TextStyle(
        fontSize: Screen.isSmall(context) ? 16 : 20,
        color: HexColor("FF777777"),
      ),
    );
  }
}
