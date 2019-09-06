import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

class ImageSource extends StatelessWidget {
  final String source;
  final bool isCopyright;

  ImageSource({this.source, this.isCopyright});

  @override
  Widget build(BuildContext context) {
    return Text(
      isCopyright ? "©" : "" + source,
      style: TextStyle(
        color: HexColor("FF999999"),
        fontStyle: FontStyle.italic,
        fontSize: (Screen.isSmall(context) ? 16 : 20),
      ),
    );
  }
}
