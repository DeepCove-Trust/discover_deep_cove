import 'dart:io';

import 'package:discover_deep_cove/widgets/misc/sub_heading.dart';
import 'package:flutter/material.dart';

class SmallTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  SmallTile({@required this.title, @required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(6, 8, 6, 0),
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
              tag: title,
              child: Image.file(File(imagePath)),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                color: Color.fromRGBO(0, 0, 0, 0.75),
                child: SubHeading(
                  text: title,
                  align: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );

    // Todo: Handle long titles
  }
}
