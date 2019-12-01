import 'dart:io';

import 'package:discover_deep_cove/data/models/notice.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/date_util.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:flutter/material.dart';

class NoticeView extends StatelessWidget {
  final Notice notice;

  NoticeView({this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContent(context),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomBackButton(),
    );
  }

  buildContent(BuildContext context) {
    return (Screen.isLandscape(context))
        ? GridView.count(
      crossAxisCount: 2,
      children: [
        getTop(context),
        ListView(
          children: [
            getBottom(context),
          ],
        ),
      ],
    )
        : Column(
      children: <Widget>[
        getTop(context),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                getBottom(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Heading(
            notice.title,
            size: Screen.isTablet(context)
                ? 30
                : Screen.isSmall(context) ? 16 : null,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            DateUtil.formatDate(notice.updatedAt),
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: Screen.isTablet(context)
                  ? 23
                  : Screen.isSmall(context) ? 12 : 14,
            ),
          ),
          Screen.isPortrait(context)
              ? Divider(color: Color(0xFF777777), height: 20)
              : Container(),
        ],
      ),
    );
  }

  getBottom(BuildContext context) {
    return Column(
      children: <Widget>[
        notice.image.path == null
            ? Container()
            : Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            height: Screen.width(context,
                percentage: Screen.isTablet(context) &&
                    Screen.isLandscape(context)
                    ? 35
                    : Screen.isTablet(context)
                    ? 70
                    : Screen.isSmall(context) ? 55 : 80),
            width: Screen.width(context,
                percentage: Screen.isTablet(context) &&
                    Screen.isLandscape(context)
                    ? 35
                    : Screen.isTablet(context)
                    ? 70
                    : Screen.isSmall(context) ? 55 : 80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: FileImage(
                  File(
                    Env.getResourcePath(
                      notice.image.path,
                    ),
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        notice.image.path == null
            ? Container()
            : Divider(color: Color(0xFF777777), height: 20),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BodyText(
                notice.shortDesc,
                size: Screen.isTablet(context)
                    ? 30
                    : Screen.isSmall(context) ? 16 : null,
                align: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              BodyText(
                notice.longDesc,
                size: Screen.isTablet(context)
                    ? 30
                    : Screen.isSmall(context) ? 16 : null,
                align: TextAlign.left,
              ),
            ],
          ),
        ),
        Divider(color: Color(0xFF777777), height: 40),
      ],
    );
  }
}