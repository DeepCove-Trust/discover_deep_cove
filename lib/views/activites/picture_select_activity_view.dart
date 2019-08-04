import 'dart:io';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/activities/activityAppBar.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:discover_deep_cove/widgets/activities/selected_photo.dart';

class PictureSelectActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [PictureSelectActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  PictureSelectActivityView({this.activity, this.isReview});

  @override
  _PictureSelectActivityViewState createState() =>
      _PictureSelectActivityViewState();
}

class _PictureSelectActivityViewState extends State<PictureSelectActivityView> {
  int photoIndex = 0;

  previousImage() {
    setState(() => photoIndex = photoIndex > 0 ? photoIndex - 1 : 0);
  }

  nextImage() {
    setState(() => photoIndex = photoIndex =
        photoIndex < widget.activity.imageOptions.length - 1
            ? photoIndex + 1
            : photoIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActivityAppBar(widget.activity.title),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 5, 40, 20),
            child: Text(widget.activity.description),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: Text(widget.activity.task),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Divider(color: Color(0xFF777777)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
            child: Column(
              children: <Widget>[
                widget.isReview
                    ? BodyText(
                        "You Answered:",
                      )
                    : Container(),
                Heading(!widget.isReview
                    ? widget.activity.imageOptions[photoIndex].name
                    : widget.activity.selectedPicture.name),
              ],
            ),
          ),
          !widget.isReview
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.white,
                      ),
                      onPressed: previousImage,
                      color: Colors.white,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          height: Screen.height(context, percentage: 38.68),
                          width: Screen.width(context, percentage: 75.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: FileImage(File(Env.getResourcePath(
                                  widget.activity.imageOptions[photoIndex].path))),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            child: SelectedPhoto(
                              numberOfDots: widget.activity.imageOptions.length,
                              photoIndex: photoIndex,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.white,
                      ),
                      onPressed: nextImage,
                    ),
                  ],
                )
              : Container(
                  height: Screen.height(context, percentage: 38.68),
                  width: Screen.width(context, percentage: 75.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: FileImage(File(Env.getResourcePath(
                          widget.activity.selectedPicture.path))),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          widget.isReview
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "To edit your answer, re-scan the QR code.",
                    style: Theme.of(context).textTheme.body1.copyWith(
                          color: Color(0xFF777777),
                        ),
                  ),
                )
              : Container(),
          Expanded(child: Container()),
          widget.isReview
              ? BottomBackButton()
              : Container(
                  width: Screen.width(context),
                  color: Theme.of(context).primaryColorDark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          borderSide: BorderSide(color: Color(0xFF777777)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: BodyText(
                            "Pass",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () => saveAnswer(),
                          borderSide: BorderSide(color: Color(0xFF777777)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: BodyText(
                            "Save",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  saveAnswer() async {
    widget.activity.selectedPictureId = widget.activity.imageOptions[photoIndex].id;
    await ActivityBean.of(context).update(widget.activity);
    Navigator.of(context).pop();
  }
}
