import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/activity/activity.dart';
import '../../env.dart';
import '../../util/screen.dart';
import '../../widgets/activities/activity_app_bar.dart';
import '../../widgets/activities/activity_pass_save_bar.dart';
import '../../widgets/activities/edit_answer.dart';
import '../../widgets/activities/selected_photo.dart';
import '../../widgets/misc/bottom_back_button.dart';
import '../../widgets/misc/custom_vertical_divider.dart';
import '../../widgets/misc/image_source.dart';
import '../../widgets/misc/text/body_text.dart';
import '../../widgets/misc/text/sub_heading.dart';

class PictureSelectActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [PictureSelectActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  const PictureSelectActivityView({this.activity, this.isReview});

  @override
  _PictureSelectActivityViewState createState() => _PictureSelectActivityViewState();
}

class _PictureSelectActivityViewState extends State<PictureSelectActivityView> {
  int photoIndex = 0;

  previousImage() {
    setState(() => photoIndex = photoIndex > 0 ? photoIndex - 1 : 0);
  }

  nextImage() {
    setState(() =>
        photoIndex = photoIndex = photoIndex < widget.activity.imageOptions.length - 1 ? photoIndex + 1 : photoIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActivityAppBar(
        text: widget.activity.title,
        onTap: widget.activity.factFileId != null ? () => displayFactFile(widget.activity.factFileId) : null,
      ),
      body: buildContent(),
      bottomNavigationBar:
          widget.isReview ? const BottomBackButton() : ActivityPassSaveBar(onTapSave: () => saveAnswer()),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  buildContent() {
    return (Screen.isTablet(context) && Screen.isLandscape(context))
        ? Row(
            children: <Widget>[
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
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ),
              child: BodyText(
                widget.activity.description + widget.activity.description,
                // TODO
                align: TextAlign.left,
                size: Screen.isTablet(context) ? 25 : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ),
              child: BodyText(
                widget.activity.task,
                align: TextAlign.left,
                size: Screen.isTablet(context) ? 30 : null,
              ),
            ),
            Screen.isPortrait(context)
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Screen.width(context, percentage: 5),
                      vertical: Screen.height(context, percentage: 1.25),
                    ),
                    child: const Divider(
                      color: Color(0xFFFFFFFF),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  getBottomHalf() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Screen.height(context, percentage: 5),
                vertical: Screen.height(context, percentage: 1.25),
              ),
              child: Column(
                children: <Widget>[
                  widget.isReview
                      ? const SubHeading(
                          'You Answered:',
                        )
                      : Container(),
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
                          size: Screen.isTablet(context)
                              ? Screen.height(context, percentage: 5)
                              : Screen.height(context, percentage: 2.5),
                        ),
                        onPressed: previousImage,
                      ),
                      Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: <Widget>[
                                      Container(
                                        height: Screen.width(
                                          context,
                                          percentage: Screen.isTablet(context) && Screen.isLandscape(context)
                                              ? 35
                                              : Screen.isTablet(context)
                                                  ? 70
                                                  : Screen.isSmall(context)
                                                      ? 55
                                                      : 65,
                                        ),
                                        width: Screen.width(
                                          context,
                                          percentage: Screen.isTablet(context) && Screen.isLandscape(context)
                                              ? 35
                                              : Screen.isTablet(context)
                                                  ? 70
                                                  : Screen.isSmall(context)
                                                      ? 55
                                                      : 65,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: FileImage(
                                              File(
                                                Env.getResourcePath(widget.activity.imageOptions[photoIndex].path),
                                              ),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      widget.activity.imageOptions[photoIndex].source != null
                                          ? Container(
                                              color: const Color.fromRGBO(0, 0, 0, 0.75),
                                              width: Screen.width(
                                                context,
                                                percentage: Screen.isTablet(context) && Screen.isLandscape(context)
                                                    ? 35
                                                    : Screen.isTablet(context)
                                                        ? 70
                                                        : Screen.isSmall(context)
                                                            ? 55
                                                            : 65,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: ImageSource(
                                                  isCopyright: widget.activity.imageOptions[photoIndex].showCopyright,
                                                  source: widget.activity.imageOptions[photoIndex].source,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectedPhoto(
                              numberOfDots: widget.activity.imageOptions.length,
                              photoIndex: photoIndex,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.chevronRight,
                          color: Colors.white,
                          size: Screen.isTablet(context)
                              ? Screen.height(context, percentage: 5)
                              : Screen.height(context, percentage: 2.5),
                        ),
                        onPressed: nextImage,
                      ),
                    ],
                  )
                : Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const SizedBox(height: 12),
                          Container(
                            height: Screen.width(context, percentage: Screen.isLandscape(context) ? 30 : 75),
                            width: Screen.width(context, percentage: Screen.isLandscape(context) ? 30 : 75),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(
                                  File(
                                    Env.getResourcePath(widget.activity.selectedPicture.path),
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12, top: 24),
                            child: EditAnswer(),
                          )
                        ],
                      ),
                      widget.activity.imageOptions[photoIndex].source != null
                          ? Container(
                              color: const Color.fromRGBO(0, 0, 0, 0.75),
                              width: Screen.width(
                                context,
                                percentage: Screen.isTablet(context) && Screen.isLandscape(context)
                                    ? 35
                                    : Screen.isTablet(context)
                                        ? 70
                                        : Screen.isSmall(context)
                                            ? 55
                                            : 65,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ImageSource(
                                  isCopyright: widget.activity.imageOptions[photoIndex].showCopyright,
                                  source: widget.activity.imageOptions[photoIndex].source,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
          ],
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
              width: Screen.width(context, percentage: Screen.isLandscape(context) ? 30 : 85),
              height: Screen.width(context, percentage: Screen.isLandscape(context) ? 30 : 85),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(Env.getResourcePath(widget.activity.image.path))),
              )),
              child: Container()),
    );
  }

  saveAnswer() async {
    widget.activity.selectedPictureId = widget.activity.imageOptions[photoIndex].id;
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
