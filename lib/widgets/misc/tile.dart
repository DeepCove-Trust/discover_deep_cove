import 'dart:io';

import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:discover_deep_cove/widgets/misc/sub_heading.dart';
import 'package:flutter/material.dart';

class TileOld extends StatelessWidget {
  final String title;
  final String subheading;
  final String imagePath;
  final VoidCallback onTap;

  TileOld({@required this.title, this.subheading, this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 15, 12, 0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(3, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            if(imagePath != null)
              Hero(tag: title, child: Image.file(File(imagePath))),
            Align(
              child: SizedBox(
                width: double.infinity, // expands the child to limits
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  color: Color.fromRGBO(0, 0, 0, 0.75),
                  constraints: BoxConstraints(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Heading(text: title),
                      SizedBox(height: 15), // spacing
                      SubHeading(text: subheading)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
