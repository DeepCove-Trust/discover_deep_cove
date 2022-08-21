import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/models/media_file.dart';
import '../../env.dart';
import '../../util/screen.dart';
import '../misc/image_source.dart';
import '../misc/text/body_text.dart';
import '../misc/text/sub_heading.dart';

class Tile extends StatelessWidget {
  final String title;
  final String subheading;
  final MediaFile image;
  final VoidCallback onTap;

  const Tile({@required this.title, this.subheading, this.image, this.onTap});

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
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 5),
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            if (image != null)
              Hero(
                tag: title,
                child: SizedBox(
                  // todo this hero is pointless now
                  width: Screen.width(context),
                  height: Screen.width(context),
                ),
              ),
            SizedBox(
              width: double.infinity, // expands the child to limits
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: const Color.fromRGBO(0, 0, 0, 0.75),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SubHeading(
                      title,
                    ),
                    if (subheading != null) const SizedBox(height: 10),
                    if (subheading != null) BodyText(subheading),
                    if (image.source != null) const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: image.source != null
                  ? ImageSource(
                      isCopyright: image.showCopyright,
                      source: image.source,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
