import 'dart:io';

import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String title;
  final String subheading;
  final MediaFile image;
  final VoidCallback onTap;

  Tile({@required this.title, this.subheading, this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: image != null
              ? DecorationImage(
                  image: FileImage(
                    File(
                      Env.getResourcePath(image.path),
                    ),
                  ),
                  fit: BoxFit.cover,
                )
              : null,
          boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 5),
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            if (image != null)
              Hero(
                tag: title,
                child: Container(
                  // todo this hero is pointless now
                  width: Screen.width(context),
                  height: Screen.width(context),
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
                    SubHeading(
                      title,
                    ),
                    if (subheading != null)
                      SizedBox(height: 10), //
                    if (subheading != null)
                      BodyText(subheading),
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
