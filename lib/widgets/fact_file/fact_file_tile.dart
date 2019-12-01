import 'dart:io';

import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class SmallTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final Object heroTag;
  final VoidCallback onTap;

  SmallTile(
      {@required this.title,
      @required this.imagePath,
      this.onTap,
      this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black54, offset: Offset(3, 3), blurRadius: 3)
      ]),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Hero(
              placeholderBuilder: (a, b, c) => Opacity(
                opacity: 0.25,
                child: c,
              ),
              tag: heroTag,
              child: Image.file(
                File(
                  Env.getResourcePath(imagePath),
                ),
                fit: BoxFit.cover,
                width: 500,
                height: 500,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                color: Color.fromRGBO(0, 0, 0, 0.75),
                child: SubHeading(title),
              ),
            ),
          ],
        ),
      ),
    );

    // Todo: Handle long titles
  }
}
