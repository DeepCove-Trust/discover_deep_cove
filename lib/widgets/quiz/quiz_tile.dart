import 'dart:io';

import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String title;
  final String subheading;
  final String imagePath;
  final VoidCallback onTap;

  Tile({@required this.title, this.subheading, this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 15, 12, 0),
        decoration: BoxDecoration(
          image: imagePath != null
              ? DecorationImage(
                  image: FileImage(File(imagePath)), fit: BoxFit.cover)
              : null,
          boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 5),
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            if (imagePath != null)
              Hero(
                tag: title,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                ),
              ),
            SizedBox(
              width: double.infinity, // expands the child to limits
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                color: Color.fromRGBO(0, 0, 0, 0.75),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Heading(
                      text: title,
                      align: TextAlign.center,
                    ),
                    if (subheading != null)
                      SizedBox(height: 10), //
                    if (subheading != null)
                      BodyText(
                        text: subheading,
                        align: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
