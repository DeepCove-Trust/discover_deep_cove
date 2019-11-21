import 'dart:io';

import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class FactNugget extends StatelessWidget {
  final String path;
  final String name;
  final String text;

  bool hasImage() => path != null;

  FactNugget({this.path, this.text, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 0.3,
          ),
        ),
      ),
      width: Screen.width(context, percentage: 90),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            hasImage()
                ? Expanded(
                    flex: 1,
                    child: Container(
                      height: Screen.width(context,
                          percentage: Screen.isPortrait(context) ? 25 : 12),
                      width: Screen.width(context,
                          percentage: Screen.isPortrait(context) ? 25 : 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(
                            File(
                              Env.getResourcePath(
                                path,
                              ),
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: SubHeading(
                      name,
                    ),
                  ),
                  BodyText(
                    text,
                    align: TextAlign.center,
                    size: Screen.isTablet(context) ? 25 : null,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
