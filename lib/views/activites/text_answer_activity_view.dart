import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/models/activity/activity.dart';
import '../../env.dart';
import '../../util/screen.dart';
import '../../widgets/activities/activity_app_bar.dart';
import '../../widgets/activities/activity_pass_save_bar.dart';
import '../../widgets/activities/edit_answer.dart';
import '../../widgets/misc/bottom_back_button.dart';
import '../../widgets/misc/custom_vertical_divider.dart';
import '../../widgets/misc/text/body_text.dart';
import '../../widgets/misc/text/sub_heading.dart';

class TextAnswerActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [TextAnswerActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  const TextAnswerActivityView({this.activity, this.isReview});

  @override
  _TextAnswerActivityViewState createState() => _TextAnswerActivityViewState();
}

class _TextAnswerActivityViewState extends State<TextAnswerActivityView> {
  final controller = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();

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
        appBar: ActivityAppBar(
          text: widget.activity.title,
          onTap: widget.activity.factFileId != null ? () => displayFactFile(widget.activity.factFileId) : null,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            buildContent(),
          ],
        ),
        bottomNavigationBar:
            widget.isReview ? const BottomBackButton() : ActivityPassSaveBar(onTapSave: () => saveAnswer()),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }

  buildContent() {
    return (Screen.isTablet(context) && Screen.isLandscape(context))
        ? Row(
            children: [Expanded(child: getTopHalf()), CustomVerticalDivider(), Expanded(child: getBottomHalf())],
          )
        : Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildGraphic(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Screen.width(context, percentage: 3),
                vertical: Screen.height(context, percentage: 2),
              ),
              child: BodyText(
                widget.activity.description,
                align: TextAlign.left,
                size: Screen.isTablet(context) ? 30 : null,
              ),
            ),
            Screen.isPortrait(context)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Divider(
                      color: Theme.of(context).primaryColorLight,
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
      padding: const EdgeInsets.all(20),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: SubHeading(
                  widget.activity.task,
                  size: Screen.isTablet(context) ? 35 : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.isReview
                    ? const SubHeading(
                        'Your answer was',
                      )
                    : const SizedBox(
                        height: 15,
                      ),
              ),
              Column(
                children: <Widget>[
                  widget.isReview
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          width: 1000,
                          decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: BodyText(
                              widget.activity.userText,
                              align: TextAlign.left,
                              size: Screen.isTablet(context) ? 30 : null,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            width: Screen.width(context, percentage: 87.5),
                            height: Screen.height(context,
                                percentage: Screen.isTablet(context)
                                    ? 45.0
                                    : Screen.isSmall(context)
                                        ? 30.0
                                        : 38.0),
                            color: Colors.white,
                            child: TextField(
                              focusNode: _textFieldFocus,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 10,
                              style: TextStyle(color: Colors.black, fontSize: Screen.isTablet(context) ? 30 : 20),
                              controller: controller,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                            ),
                          ),
                        ),
                  widget.isReview ? EditAnswer() : Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildGraphic() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Screen.isTablet(context) ? 20 : 10),
      child: widget.activity.image == null
          ? null
          : Container(
              width: Screen.width(context, percentage: Screen.isLandscape(context) ? 33 : 85),
              height: Screen.width(context, percentage: Screen.isLandscape(context) ? 33 : 85),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(Env.getResourcePath(widget.activity.image.path))),
              )),
              child: Container()),
    );
  }

  void saveAnswer() async {
    widget.activity.userText = controller.text;
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
