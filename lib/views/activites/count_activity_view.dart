import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/activities/activity_app_bar.dart';
import 'package:discover_deep_cove/widgets/activities/activity_pass_save_bar.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
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
          widget.activity.title,
          widget.activity.factFileId != null
              ? () => displayFactFile(widget.activity.factFileId)
              : null,
        ),
        body: buildContent(),
        bottomNavigationBar: widget.isReview
            ? BottomBackButton(isReview: widget.isReview)
            : ActivityPassSaveBar(
                onTapSave: () => saveAnswer(),
              ),
        backgroundColor: Theme.of(context).backgroundColor);
  }

  buildContent() {
    return (Screen.isTablet(context) && Screen.isLandscape(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              getTopHalf(),
              getBottomHalf(),
            ],
          )
        : Column(
            children: [
              getTopHalf(),
              Flexible(
                child: getBottomHalf(),
              ),
            ],
          );
  }

  getTopHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 2.5),
            vertical: Screen.height(context, percentage: 5.0),
          ),
          child: BodyText(
            widget.activity.description,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
        SizedBox(
          height: Screen.height(
            context,
            percentage: 5.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 2.5),
            vertical: Screen.height(context, percentage: 5.0),
          ),
          child: BodyText(
            widget.activity.task,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
        Screen.isPortrait(context)
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Screen.height(context, percentage: 5.0),
                ),
                child: Divider(
                  color: HexColor("FF777777"),
                ),
              )
            : Container(),
      ],
    );
  }

  getBottomHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: widget.isReview
              ? BodyText(
                  "You Counted:",
                  size: Screen.isTablet(context) ? 30 : null,
                )
              : SizedBox(
                  height: Screen.height(context, percentage: 5.0),
                ),
        ),
        SizedBox(
          height: Screen.height(
            context,
            percentage: Screen.isSmall(context) ? 5.0 : 10.0,
          ),
        ),
        widget.isReview
            ? Container(
                width: Screen.width(context),
                height: Screen.height(context,
                    percentage: Screen.isLandscape(context) ? 15.0 : 10.0),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      widget.activity.userCount.toString(),
                      style: TextStyle(
                        fontSize: Screen.isSmall(context) ? 40 : 60,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: Screen.width(context),
                height: Screen.height(context,
                    percentage: Screen.isLandscape(context) ? 15.0 : 10.0),
                color: Theme.of(context).primaryColor,
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
                          if (count > 1) {
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
                      size: Screen.isSmall(context)
                          ? 40
                          : Screen.isTablet(context) ? 70 : 50,
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
      ],
    );
  }

  void saveAnswer() async {
    widget.activity.userCount = count;
    await ActivityBean.of(context).update(widget.activity);
    Navigator.of(context).pop();
  }

  displayFactFile(int factFileId) {

    Navigator.of(context).pushNamed(
      '/factFileDetails',
      arguments: factFileId,
    );
  }
}
