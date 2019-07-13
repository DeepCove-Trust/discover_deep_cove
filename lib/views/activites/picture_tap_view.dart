import 'dart:math';

import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:discover_deep_cove/data/sample_data_activities.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/widgets/misc/back_nav_bottom.dart';
import 'package:toast/toast.dart';

class PictureTapView extends StatefulWidget {
  final PictureTapActivity activity;
  final bool fromMap;

  ///Takes in a [PictureTapActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  PictureTapView({this.activity, this.fromMap});

  @override
  _PictureTapViewState createState() => _PictureTapViewState();
}

class _PictureTapViewState extends State<PictureTapView> {
  Offset tapPos;
  Color transparentAccent;
  bool firstTap = false;
  double posY = 0;
  double posX = 0;

  GlobalKey _keyImage = GlobalKey();

  _afterLayout(_) {
    _getPositions();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: HeadingText(
          text: widget.activity.title,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Text(widget.activity.description),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Text(widget.activity.task),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: widget.fromMap
                ? BodyText(
                    text: "Your Answer:",
                  )
                : Container(),
          ),
          widget.fromMap
              ? Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.activity.image.path),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          color: Color.fromARGB(190, 0, 0, 0),
                          height: (MediaQuery.of(context).size.width / 10) * 1,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "To edit your answer, re-scan the QR code.",
                                style:
                                    Theme.of(context).textTheme.body1.copyWith(
                                          color: Color(0xFF777777),
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: widget.activity.userPoint.y,
                      left: widget.activity.userPoint.x,
                      child: Center(
                        child: Container(
                          width: 100.0,
                          height: 100.0,
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
                    ),
                  ],
                )
              : Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: _handleTap,
                      child: Container(
                        key: _keyImage,
                        height: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.activity.image.path),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    firstTap
                        ? Positioned(
                            top: posY,
                            left: posX,
                            child: Center(
                              child: Container(
                                width: 100.0,
                                height: 100.0,
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
          Expanded(child: Container()),
          widget.fromMap
              ? BackNavBottom()
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
                            if (firstTap) {
                              widget.activity.activated = true;
                              widget.activity.userPoint = Point(posX, posY);
                              Navigator.of(context).pop();
                            } else {
                              Toast.show(
                                "Please tap the picture!",
                                context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM,
                                backgroundColor: Theme.of(context).primaryColor,
                                textColor: Colors.black,
                              );
                            }
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

  ///This updates the circle co-ords on the image
  void _handleTap(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    setState(() {
      firstTap = true;
      tapPos = referenceBox.globalToLocal(details.globalPosition);
      posX = tapPos.dx - 50;
      posY = tapPos.dy - (_getPositions() + 50);
    });
  }

  ///returns a [double] this is the y pos of the image
  double _getPositions() {
    final RenderBox renderBoxImage =
        _keyImage.currentContext.findRenderObject();
    final imagePos = renderBoxImage.localToGlobal(Offset.zero);

    return imagePos.dy;
  }

  ///Updates the transparency value of the accent color
  setTransparentColor() {
    return transparentAccent = HexColor(
        '80' + Theme.of(context).accentColor.toString().substring(10, 16));
  }
}
