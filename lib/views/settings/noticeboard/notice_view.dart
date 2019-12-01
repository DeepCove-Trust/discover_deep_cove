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
        ? Row(
            children: <Widget>[
              Expanded(
                  child: ListView(
                children: <Widget>[getBottom(context)],
              )),
              notice.image?.path == null
                  ? Container()
                  : Expanded(child: Center(child: buildImage(context))),
            ],
          )
        : Column(
            children: <Widget>[
              getTop(context),
              Flexible(
                child: ListView(children: [
                  getBottom(context),
                ]),
              ),
            ],
          );
  }

  Widget buildImage(BuildContext context) {
    return Image(
        image: FileImage(File(Env.getResourcePath(notice.image.path))),
        fit: BoxFit.cover,
        width: getImageDimension(context),
        height: getImageDimension(context));
  }

  getTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Heading(
            notice.title,
            size: Screen.isTablet(context) ? 30 : null,
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
                  : Screen.isSmall(context) ? 15 : 17,
            ),
          ),
          SizedBox(height: 20),
          Screen.isPortrait(context)
              ? Divider(color: Color(0xFF777777), height: 0)
              : Container(),
        ],
      ),
    );
  }

  getImageDimension(BuildContext context) {
    return Screen.width(context,
        percentage: Screen.isLandscape(context)
            ? 40
            : Screen.isTablet(context) ? 75 : 85);
  }

  getBottom(BuildContext context) {
    return Column(
      children: <Widget>[
        Screen.isLandscape(context) ? getTop(context) : Container(),
        notice.image?.path == null || Screen.isLandscape(context)
            ? Container()
            : Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: buildImage(context)),
        notice.image?.path == null || Screen.isLandscape(context)
            ? Container()
            : Divider(color: Color(0xFF777777), height: 10),
        Padding(
          padding: EdgeInsets.all(Screen.isTablet(context) ? 25 : 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BodyText(
                notice.longDesc,
                size: Screen.isTablet(context)
                    ? 22
                    : Screen.isSmall(context) ? 16 : null,
                align: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
