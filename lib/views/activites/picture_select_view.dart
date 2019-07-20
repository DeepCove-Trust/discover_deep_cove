import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:discover_deep_cove/widgets/activities/selected_photo.dart';

class PictureSelectView extends StatefulWidget {
  final Activity activity;
  final bool fromMap;

  ///Takes in a [PictureSelectActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  PictureSelectView({this.activity, this.fromMap});

  @override
  _PictureSelectViewState createState() => _PictureSelectViewState();
}

class _PictureSelectViewState extends State<PictureSelectView> {
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
      appBar: AppBar(
        leading: Container(),
        title: Heading(
          text: widget.activity.title,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
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
                widget.fromMap
                    ? BodyText(
                        text: "You Answered:",
                      )
                    : Container(), // Todo
                Heading(
                    text: !widget.fromMap
                        ? widget.activity.imageOptions[photoIndex].name
                        : widget.activity.selectedPicture.name),
              ],
            ),
          ),
          !widget.fromMap
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
                          height: (MediaQuery.of(context).size.height / 100) *
                              38.68,
                          width: (MediaQuery.of(context).size.width / 4) * 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: AssetImage(widget
                                  .activity.imageOptions[photoIndex].path),
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
                  height: (MediaQuery.of(context).size.height / 100) * 38.68,
                  width: (MediaQuery.of(context).size.width / 4) * 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage(widget.activity.selectedPicture.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          widget.fromMap
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
          widget.fromMap
              ? BottomBackButton()
              : Container(
                  width: MediaQuery.of(context).size.width,
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
                            text: "Pass",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () {
                            widget.activity.selectedPicture =
                                widget.activity.imageOptions[photoIndex];
                            Navigator.of(context).pop();
                          },
                          borderSide: BorderSide(color: Color(0xFF777777)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: BodyText(
                            text: "Save",
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
}
