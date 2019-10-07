import 'dart:io';

import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

class QuizImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final MediaFile image;
  final String text;

  const QuizImageButton({this.onTap, this.image, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Screen.isPortrait(context)
            ? Screen.width(context, percentage: 45)
            : Screen.height(context, percentage: 40),
        height: Screen.isPortrait(context)
            ? Screen.width(context, percentage: 45)
            : Screen.height(context, percentage: 40),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(
                          Env.getResourcePath(image.path),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
//                image.source == null && text == null ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    text != null
                        ? Container(
                            color: Color.fromARGB(190, 0, 0, 0),
                            height: Screen.height(context,
                                percentage:
                                    Screen.isPortrait(context) && text == null
                                        ? 2.5
                                        : 5),
                            width: Screen.width(context),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  text,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Screen.width(context) <= 350
                                          ? 16
                                          : 20),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                )
//                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
