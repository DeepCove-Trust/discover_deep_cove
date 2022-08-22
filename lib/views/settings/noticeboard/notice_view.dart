import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/notice.dart';
import '../../../env.dart';
import '../../../util/date_util.dart';
import '../../../util/screen.dart';
import '../../../widgets/misc/bottom_back_button.dart';
import '../../../widgets/misc/text/heading.dart';

class NoticeView extends StatelessWidget {
  final Notice notice;

  const NoticeView({this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContent(context),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: const BottomBackButton(),
    );
  }

  buildContent(BuildContext context) {
    return (Screen.isLandscape(context))
        ? Row(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[getBottom(context)],
                ),
              ),
              notice.image?.path == null ? Container() : Expanded(child: Center(child: buildImage(context))),
            ],
          )
        : Column(
            children: <Widget>[
              getTop(context),
              Flexible(
                child: ListView(
                  children: [
                    getBottom(context),
                  ],
                ),
              ),
            ],
          );
  }

  Widget buildImage(BuildContext context) {
    return Image(
      image: FileImage(File(Env.getResourcePath(notice.image.path))),
      fit: BoxFit.cover,
      width: getImageDimension(context),
      height: getImageDimension(context),
    );
  }

  getTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          Heading(
            notice.title,
            size: Screen.isTablet(context) ? 30 : null,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            DateUtil.formatDate(notice.updatedAt),
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: Screen.isTablet(context)
                  ? 23
                  : Screen.isSmall(context)
                      ? 15
                      : 17,
            ),
          ),
          const SizedBox(height: 20),
          Screen.isPortrait(context) ? Divider(color: Theme.of(context).primaryColorLight, height: 0) : Container(),
        ],
      ),
    );
  }

  getImageDimension(BuildContext context) {
    return Screen.width(
      context,
      percentage: Screen.isLandscape(context)
          ? 40
          : Screen.isTablet(context)
              ? 75
              : 85,
    );
  }

  getBottom(BuildContext context) {
    return Column(
      children: <Widget>[
        Screen.isLandscape(context) ? getTop(context) : Container(),
        notice.image?.path == null || Screen.isLandscape(context)
            ? Container()
            : Padding(padding: const EdgeInsets.only(bottom: 10), child: buildImage(context)),
        notice.image?.path == null || Screen.isLandscape(context)
            ? Container()
            : Divider(color: Theme.of(context).primaryColorLight, height: 10),
        Padding(
          padding: EdgeInsets.all(Screen.isTablet(context) ? 25 : 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                notice.longDesc,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: Screen.isTablet(context)
                      ? 22
                      : Screen.isSmall(context)
                          ? 16
                          : 20,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
