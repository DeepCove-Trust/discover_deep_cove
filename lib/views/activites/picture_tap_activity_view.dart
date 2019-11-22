import 'dart:io';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/activities/editAnswer.dart';
import 'package:discover_deep_cove/widgets/misc/custom_vertical_divider.dart';
import 'package:discover_deep_cove/widgets/misc/image_source.dart';
import 'package:discover_deep_cove/widgets/activities/activity_app_bar.dart';
import 'package:discover_deep_cove/widgets/activities/activity_pass_save_bar.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:flutter/material.dart';

class PictureTapActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [PictureTapActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  PictureTapActivityView({this.activity, this.isReview});

  @override
  _PictureTapActivityViewState createState() => _PictureTapActivityViewState();
}

class _PictureTapActivityViewState extends State<PictureTapActivityView> {
  Color transparentAccent;
  bool isTapped = false;
  double posY = 0;
  double posX = 0;

  GlobalKey _keyImage = GlobalKey();

  _afterLayout(_) {
    _getImagePositions();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  void dispose() {
    // Return default orientations
    Screen.setOrientations(context);
  }

  @override
  Widget build(BuildContext context) {
    // Force portrait for this view
    Screen.setOrientations(context, forcePortrait: true);
    return Scaffold(
      appBar: ActivityAppBar(
        text: widget.activity.title,
        onTap: widget.activity.factFileId != null
            ? () => displayFactFile(widget.activity.factFileId)
            : null,
      ),
      body: Screen.isLandscape(context)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  BodyText('Loading'),
                ],
              ),
            )
          : buildContent(),
      bottomNavigationBar: widget.isReview
          ? BottomBackButton()
          : ActivityPassSaveBar(
              onTapSave: () => saveAnswer(),
            ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  buildContent() {
    return Screen.isLandscape(context)
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
                children: [getTopHalf(), getBottomHalf()],
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
            Screen.isPortrait(context)
                ? SizedBox(height: Screen.height(context, percentage: 4))
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: BodyText(
                widget.activity.description,
                align: TextAlign.left,
                size: Screen.isTablet(context) ? 25.0 : null,
              ),
            ),
            SizedBox(height: Screen.height(context, percentage: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: BodyText(
                widget.activity.task,
                align: TextAlign.left,
                size: Screen.isTablet(context) ? 25.0 : null,
              ),
            ),
            SizedBox(
                height: Screen.isPortrait(context)
                    ? Screen.height(context, percentage: 4)
                    : 0)
          ],
        ),
      ),
    );
  }

  getBottomHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: widget.isReview
                ? BodyText("Your Answer",
                    size: Screen.isTablet(context) ? 25 : 16)
                : null,
          ),
        ),
        widget.isReview
            ? Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: Screen.width(context,
                          percentage: Screen.isLandscape(context) ? 45 : 85),
                      width: Screen.width(context,
                          percentage: Screen.isLandscape(context) ? 45 : 85),
                      child: Container(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(
                                File(
                                  Env.getResourcePath(
                                    widget.activity.image.path,
                                  ),
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.activity.image.source != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Screen.width(
                              context,
                              percentage: Screen.isTablet(context) &&
                                      Screen.isLandscape(context)
                                  ? 2.5
                                  : Screen.isTablet(context)
                                      ? 7.5
                                      : Screen.isSmall(context) ? 12.5 : 10,
                            ),
                          ),
                          child: ImageSource(
                            isCopyright: widget.activity.image.showCopyright,
                            source: widget.activity.image.source,
                          ),
                        )
                      : Container(),
                  Positioned(
                    top: _getYPos(widget.activity.userCoordY),
                    left: _getXPos(widget.activity.userCoordX),
                    child: Center(
                      child: Container(
                        width: Screen.height(context, percentage: 10),
                        height: Screen.height(context, percentage: 10),
                        child: Container(
                          key: _keyImage,
                          decoration: BoxDecoration(
                            color: Color(0x80FF5026),
                            border: Border.all(
                              color: setTransparentColor(),
                              width: 3.0,
                              style: BorderStyle.solid,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: _getImageDimension(),
                      width: _getImageDimension(),
                      child: GestureDetector(
                        onTapDown: _handleTap,
                        child: Container(
                          key: _keyImage,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                  File(
                                    Env.getResourcePath(
                                      widget.activity.image.path,
                                    ),
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.activity.image.source != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Screen.width(
                              context,
                              percentage: Screen.isTablet(context) &&
                                      Screen.isLandscape(context)
                                  ? 2.5
                                  : Screen.isTablet(context)
                                      ? 7.5
                                      : Screen.isSmall(context) ? 12.5 : 10,
                            ),
                          ),
                          child: ImageSource(
                            isCopyright: widget.activity.image.showCopyright,
                            source: widget.activity.image.source,
                          ),
                        )
                      : Container(),
                  isTapped
                      ? Positioned(
                          top: _getYPos(posY),
                          left: _getXPos(posX),
                          child: GestureDetector(
                            onTapDown: _handleTap,
                            child: Container(
                              width: Screen.height(context, percentage: 10),
                              height: Screen.height(context, percentage: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0x80FF5026),
                                  border: Border.all(
                                    color: setTransparentColor(),
                                    width: 3.0,
                                    style: BorderStyle.solid,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: widget.isReview ? EditAnswer() : Container(),
        )
      ],
    );
  }

  double _getImageDimension() {
    return Screen.width(
      context,
      percentage: Screen.isTablet(context) && Screen.isLandscape(context)
          ? 45
          : Screen.isTablet(context) ? 85 : Screen.isSmall(context) ? 75 : 80,
    );
  }

  double _getXOffset() {
    return Screen.width(
      context,
      percentage: Screen.isTablet(context) && Screen.isLandscape(context)
          ? 0.8
          : Screen.isTablet(context)
              ? -0.5
              : Screen.isSmall(context) ? -2.5 : 0,
    );
  }

  void _handleTap(TapDownDetails details) {
    _placeMarker(details.globalPosition);
  }

  ///This updates the circle co-ords on the image
  void _placeMarker(Offset position) {
    setState(() {
      isTapped = true;
      posX = (position.dx - _getImagePositions().dx) / _getImageDimension();
      posY = (position.dy - _getImagePositions().dy) / _getImageDimension();
    });
  }

  double _getXPos(xVal) {
    return xVal * _getImageDimension() - _getXOffset();
  }

  double _getYPos(yVal) {
    return yVal * _getImageDimension() -
        Screen.height(context, percentage: 4.5);
  }

  ///returns a [offset] this contains the x and y positions of the image
  Offset _getImagePositions() {
    final RenderBox renderBoxImage =
        _keyImage.currentContext.findRenderObject();
    final imagePos = renderBoxImage.localToGlobal(Offset.zero);
    return imagePos;
  }

  ///Updates the transparency value of the accent color
  setTransparentColor() {
    return transparentAccent = Color(0x80FF5026);
  }

  void saveAnswer() async {
    widget.activity.userCoordX = posX;
    widget.activity.userCoordY = posY;
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
