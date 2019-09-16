import 'dart:io';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
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
  Offset tapPos;
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
          ? BottomBackButton(isReview: widget.isReview)
          : ActivityPassSaveBar(
              onTapSave: () => saveAnswer(),
            ),
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
            horizontal: Screen.width(context, percentage: 5),
            vertical: Screen.height(context, percentage: 2.5),
          ),
          child: BodyText(
            widget.activity.description,
            size: Screen.isTablet(context)
                ? 25.0
                : Screen.isSmall(context) ? 14 : 16,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 5),
            vertical: Screen.height(context, percentage: 1.25),
          ),
          child: BodyText(
            widget.activity.task,
            size: Screen.isTablet(context)
                ? 25.0
                : Screen.isSmall(context) ? 14 : 16,
          ),
        ),
      ],
    );
  }

  getBottomHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: widget.isReview
              ? BodyText(
                  "Your Answer:",
                  size: Screen.isTablet(context)
                      ? 25.0
                      : Screen.isSmall(context) ? 14 : 16,
                )
              : null,
        ),
        widget.isReview
            ? Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: Screen.width(context,
                          percentage: Screen.isTablet(context) &&
                                  Screen.isLandscape(context)
                              ? 45
                              : Screen.isTablet(context)
                                  ? 85
                                  : Screen.isSmall(context) ? 75 : 80),
                      width: Screen.width(context,
                          percentage: Screen.isTablet(context) &&
                                  Screen.isLandscape(context)
                              ? 45
                              : Screen.isTablet(context)
                                  ? 85
                                  : Screen.isSmall(context) ? 75 : 80),
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
                  Positioned(
                    top: widget.activity.userYCoord,
                    left: widget.activity.userXCoord,
                    child: Center(
                      child: Container(
                        width: Screen.height(context, percentage: 10),
                        height: Screen.height(context, percentage: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor("80FF5026"),
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
                        onHorizontalDragUpdate: _handleDrag,
                        onVerticalDragUpdate: _handleDrag,
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
                  isTapped
                      ? Positioned(
                          top: _getYPos(),
                          left: _getXPos(),
                          child: GestureDetector(
                            onHorizontalDragUpdate: _handleDrag,
                            onVerticalDragUpdate: _handleDrag,
                            onTapDown: _handleTap,
                            child: Container(
                              width: Screen.height(context, percentage: 10),
                              height: Screen.height(context, percentage: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: HexColor("80FF5026"),
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
      ],
    );
  }

  double _getImageDimension() {
    return Screen.width(context,
        percentage: Screen.isTablet(context) && Screen.isLandscape(context)
            ? 45
            : Screen.isTablet(context)
                ? 85
                : Screen.isSmall(context) ? 75 : 80);
  }

  double _getXOffset() {
    return Screen.width(context,
        percentage: Screen.isTablet(context) && Screen.isLandscape(context)
            ? 0.8
            : Screen.isTablet(context)
                ? -0.5
                : Screen.isSmall(context) ? -2.5 : 0);
  }

  void _handleDrag(DragUpdateDetails details) {
    _placeMarker(details.globalPosition);
  }

  void _handleTap(TapDownDetails details) {
    _placeMarker(details.globalPosition);
  }

  ///This updates the circle co-ords on the image
  void _placeMarker(Offset position) {
    final RenderBox referenceBox = context.findRenderObject();
    setState(() {
      isTapped = true;
      tapPos = referenceBox.globalToLocal(position);

      double radius = Screen.height(context, percentage: 5);

      double imageX = _getImagePositions().dx;
      double imageY = _getImagePositions().dy;

      double pixelPosX = position.dx - imageX;
      double pixelPosY = position.dy - imageY;

      double imageWidth = _getImageDimension();
      double imageHeight = imageWidth;

      double percentPosX = pixelPosX / imageWidth;
      double percentPosY = pixelPosY / imageHeight;

      posX = percentPosX;
      posY = percentPosY;

      print("");
      //Circle cords
      print("X " + posX.toString());
      print("Y " + posY.toString());
      //Pos of tap on screen
      print("tX " + tapPos.dx.toString());
      print("tY " + tapPos.dy.toString());
      //Image pos on screen
      print("tX " + _getImagePositions().dx.toString());
      print("tY " + _getImagePositions().dy.toString());

      // print("%X " + percentX.toString());
      // print("%Y " + percentY.toString());
    });
  }

  double _getXPos() {
    print("posX: $posX");
    print("imagePosX: ${_getImagePositions().dx}");
    print("imageWidth: ${_getImageDimension()}");
    double pos = posX * _getImageDimension() - _getXOffset();
    print("X Pos: " + pos.toString());
    return pos;
  }

  double _getYPos() {
    double pos =
        posY * _getImageDimension() - Screen.height(context, percentage: 4.5);
    print("Y Pos: " + pos.toString());
    return pos;
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
    return transparentAccent = HexColor(
        '80' + Theme.of(context).accentColor.toString().substring(10, 16));
  }

  void saveAnswer() async {
    widget.activity.userXCoord = posX;
    widget.activity.userYCoord = posY;
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
