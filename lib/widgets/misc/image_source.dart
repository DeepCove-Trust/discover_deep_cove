import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:flutter/material.dart';

class ImageSource extends StatelessWidget {
  final String source;
  final bool isCopyright;
  final double size;

  ImageSource({this.source = "", this.isCopyright = false, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                isCopyright ? "© " + source : source,
                style: TextStyle(
                  color: HexColor("FF999999"),
                  fontStyle: FontStyle.italic,
                  fontSize: size,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
