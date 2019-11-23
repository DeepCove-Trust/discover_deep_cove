import 'dart:io';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/activities/activity_app_bar.dart';
import 'package:discover_deep_cove/widgets/activities/activity_pass_save_bar.dart';
import 'package:discover_deep_cove/widgets/activities/editAnswer.dart';
import 'package:discover_deep_cove/widgets/misc/custom_vertical_divider.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CountActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [CountActivityView] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  CountActivityView({this.activity, this.isReview});

  @override
  _CountActivityViewState createState() => _CountActivityViewState();
}

class _CountActivityViewState extends State<CountActivityView> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ActivityAppBar(
          text: widget.activity.title,
          onTap: widget.activity.factFileId != null
              ? () => displayFactFile(widget.activity.factFileId)
              : null,
        ),
        body: buildContent(),
        bottomNavigationBar: widget.isReview
            ? BottomBackButton()
            : ActivityPassSaveBar(
                onTapSave: () => saveAnswer(),
              ),
        backgroundColor: Theme.of(context).backgroundColor);
  }

  buildContent() {
    return Screen.isLandscape(context)
        ? Row(
            children: [
              Expanded(child: getTopHalf()),
              CustomVerticalDivider(),
              Expanded(child: getBottomHalf())
            ],
          )
        : Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  getTopHalf(),
                  getBottomHalf(),
                ],
              ),
            ),
          );
  }

  getTopHalf() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildGraphic(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: BodyText(
                widget.activity.description,
                align: TextAlign.left,
                size: Screen.isTablet(context) ? 25 : null,
              ),
            ),
            Screen.isPortrait(context)
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Divider(
                      height: 40,
                      color: Color(0xFF777777),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  getBottomHalf() {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: SubHeading(
              widget.activity.task,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(12.0),
              child: widget.isReview
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: SubHeading(
                        "Your answer:",
                      ),
                    )
                  : Container()),
          widget.isReview
              ? Container(
                  width: Screen.width(context,
                      percentage: Screen.isLandscape(context) ? 30 : 65),
                  height: Screen.width(context,
                      percentage: Screen.isLandscape(context) ? 15 : 35),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        widget.activity.userCount.toString(),
                        style: TextStyle(
                          fontSize: Screen.isSmall(context) ? 60 : 80,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: Screen.width(context,
                      percentage: Screen.isLandscape(context) ? 30 : 65),
                  height: Screen.width(context,
                      percentage: Screen.isLandscape(context) ? 15 : 35),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Transform.scale(
                        scale: Screen.isTablet(context) ? 2 : 1.5,
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.chevronLeft,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (count > 0) {
                              setState(() {
                                count = count - 1;
                              });
                            }
                          },
                          color: Colors.white,
                        ),
                      ),
                      BodyText(
                        count.toString(),
                        size: Screen.isSmall(context) ? 60 : 80,
                      ),
                      Transform.scale(
                        scale: Screen.isTablet(context) ? 2 : 1.5,
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.chevronRight,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (count < 100) {
                              setState(() {
                                count = count + 1;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 25),
          widget.isReview ? EditAnswer() : Container()
        ],
      ),
    );
  }

  buildGraphic() {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: Screen.isTablet(context) ? 20 : 10),
      child: widget.activity.image == null
          ? null
          : Container(
              width: Screen.width(context,
                  percentage: Screen.isLandscape(context) ? 30 : 85),
              height: Screen.width(context,
                  percentage: Screen.isLandscape(context) ? 30 : 85),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(
                    File(Env.getResourcePath(widget.activity.image.path))),
              )),
              child: Container()),
    );
  }

  void saveAnswer() async {
    widget.activity.userCount = count;
    await ActivityBean.of(context).update(widget.activity);
    Navigator.of(context).pop();
  }

  displayFactFile(int factFileId) async {
    Navigator.of(context).pushNamed(
      '/factFileDetails',
      arguments: factFileId,
    );
  }
}
