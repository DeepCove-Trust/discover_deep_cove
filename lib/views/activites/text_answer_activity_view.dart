import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/activities/activity_app_bar.dart';
import 'package:discover_deep_cove/widgets/activities/activity_pass_save_bar.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
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
  FocusNode _textFieldFocus = new FocusNode();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _textFieldFocus.unfocus(),
      child: Scaffold(
        appBar: ActivityAppBar(widget.activity.title),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            buildContent(),
          ],
        ),
        bottomNavigationBar: widget.isReview
            ? BottomBackButton()
            : ActivityPassSaveBar(onTapSave: () => saveAnswer()),
        backgroundColor: Theme.of(context).backgroundColor,
    ));
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
          child: BodyText(
            widget.activity.description,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 2.5),
            vertical: Screen.height(context, percentage: 2.5),
          ),
          child: BodyText(
            widget.activity.task,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
        Screen.isPortrait(context) ? Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 5),
          ),
          child: Divider(
            color: HexColor("FF777777"),
          ),
        ) : Container(),
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
                ? BodyText(
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
                      height: Screen.height(context,
                          percentage: Screen.isTablet(context)
                              ? 45.0
                              : Screen.isSmall(context) ? 30.0 : 38.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0, color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(5.0) //
                            ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BodyText(
                          widget.activity.userText,
                          align: TextAlign.left,
                          size: Screen.isTablet(context) ? 30 : null,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: Screen.width(context, percentage: 87.5),
                        height: Screen.height(context,
                            percentage: Screen.isTablet(context)
                                ? 45.0
                                : Screen.isSmall(context) ? 30.0 : 38.0),
                        color: Colors.white,
                        child: TextField(
                          focusNode: _textFieldFocus,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
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
