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

  FactNugget({this.path, this.text, this.name});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Screen.width(context, percentage: 1.5),
        bottom: Screen.width(context, percentage: 2.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
        ),
        width: Screen.width(context, percentage: 90),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Screen.width(context, percentage: 4),
            horizontal: Screen.width(context, percentage: 3),
          ),
          child: Column(
            children: <Widget>[
              path != null
                  ? Container(
                      height: Screen.width(context, percentage: Screen.isPortrait(context) ? 40 : 30),
                      width: Screen.width(context, percentage:  Screen.isPortrait(context) ? 40 : 30),
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
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Screen.width(context, percentage: 5),
                ),
                child: SubHeading(
                  name,
                  size: Screen.isTablet(context) ? 45 : null,
                ),
              ),
              BodyText(
                text,
                align: TextAlign.justify,
                size: Screen.isTablet(context) ? 30 : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
