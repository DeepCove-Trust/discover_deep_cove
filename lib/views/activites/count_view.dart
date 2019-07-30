import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CountView extends StatefulWidget {
  final Activity activity;
  final bool fromMap;

  ///Takes in a [CountActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  CountView({this.activity, this.fromMap});

  @override
  _CountViewState createState() => _CountViewState();
}

class _CountViewState extends State<CountView> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Heading(
           widget.activity.title,
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
          SizedBox(
            height: (MediaQuery.of(context).size.height / 100) * 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
            child: Text(widget.activity.task),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Divider(color: Color(0xFF777777)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: widget.fromMap
                ? BodyText(
                     "You Counted:",
                  )
                : SizedBox(
                    height: (MediaQuery.of(context).size.height / 100) * 5,
                  ),
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.height / 100) * 20,
          ),
          widget.fromMap
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height / 100) * 10,
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        widget.activity.userCount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline
                            .copyWith(fontSize: 60),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height / 100) * 10,
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.5,
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
                      Text(
                        count.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline
                            .copyWith(fontSize: 60),
                      ),
                      Transform.scale(
                        scale: 1.5,
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
          widget.fromMap
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
                  child: Text(
                    "To edit your answer, re-scan the QR code.",
                    style: Theme.of(context).textTheme.body1.copyWith(
                          color: Color(0xFF777777),
                        ),
                  ),
                )
              : null,
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
                             "Pass",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () {
                            widget.activity.userCount = count;
                            Navigator.of(context).pop();
                          },
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
}
