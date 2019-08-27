import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/activities/activity_app_bar.dart';
import 'package:discover_deep_cove/widgets/activities/activity_pass_save_bar.dart';
import 'package:discover_deep_cove/widgets/activities/editAnswer.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:flutter/material.dart';

class TextAnswerActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [TextAnswerActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  TextAnswerActivityView({this.activity, this.isReview});

  @override
  _TextAnswerActivityViewState createState() => _TextAnswerActivityViewState();
}

class _TextAnswerActivityViewState extends State<TextAnswerActivityView> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActivityAppBar(widget.activity.title),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildContent(),
        ],
      ),
      bottomNavigationBar: widget.isReview
          ? BottomBackButton()
          : ActivityPassSaveBar(onTap: () => saveAnswer()),
      backgroundColor: Theme.of(context).backgroundColor,
    );
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
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getTopHalf(),
                getBottomHalf(),
              ],
            ),
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
          child: Body(
            widget.activity.description,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 2.5),
            vertical: Screen.height(context, percentage: 5.0),
          ),
          child: Body(
            widget.activity.task,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 5),
          ),
          child: Divider(
            color: HexColor("FF777777"),
          ),
        ),
      ],
    );
  }

  getBottomHalf() {
    return Padding(
      padding: EdgeInsets.only(
        right: Screen.width(context, percentage: 2.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.isReview
                ? Body(
                    "You Answered:",
                    size: Screen.isTablet(context) ? 30 : null,
                  )
                : SizedBox(
                    height: Screen.height(context, percentage: 2.5),
                  ),
          ),
          Column(
            children: <Widget>[
              widget.isReview
                  ? Container(
                      width: Screen.width(context, percentage: 87.5),
                      height: Screen.height(context, percentage: 38.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0, color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(5.0) //
                            ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Body(
                          widget.activity.userText,
                          align: TextAlign.left,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: Screen.width(context, percentage: 87.5),
                        height: Screen.height(context, percentage: 60.0),
                        color: Colors.white,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          style: TextStyle(color: Colors.black),
                          controller: controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          widget.isReview
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: EditAnswer(),
                )
              : Container(),
        ],
      ),
    );
  }

  void saveAnswer() async {
    widget.activity.userText = controller.text;
    await ActivityBean.of(context).update(widget.activity);
    Navigator.of(context).pop();
  }
}
