import 'package:flutter/material.dart';
import 'package:discover_deep_cove/data/sample_data_activities.dart';
import 'package:discover_deep_cove/util/body1_text.dart';
import 'package:discover_deep_cove/util/heading_text.dart';
import 'package:discover_deep_cove/widgets/misc/back_nav_bottom.dart';
import 'package:toast/toast.dart';

class TextAnswerView extends StatefulWidget {
  final TextAnswerActivity activity;
  final bool fromMap;

  ///Takes in a [TextAnswerActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  TextAnswerView({this.activity, this.fromMap});

  @override
  _TextAnswerViewState createState() => _TextAnswerViewState();
}

class _TextAnswerViewState extends State<TextAnswerView> {
  final controller = TextEditingController();

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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Text(widget.activity.description),
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
                  padding: const EdgeInsets.all(8.0),
                  child: widget.fromMap
                      ? Body1Text(
                          text: "You Answered:",
                        )
                      : SizedBox(
                          height:
                              (MediaQuery.of(context).size.height / 100) * 2.5,
                        ),
                ),
                widget.fromMap
                    ? Container(
                        width: (MediaQuery.of(context).size.width / 4) * 3.5,
                        height: (MediaQuery.of(context).size.height / 100) * 38,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0) //
                              ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Body1Text(
                            text: widget.activity.userText,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: (MediaQuery.of(context).size.width / 4) * 3.5,
                          height: (MediaQuery.of(context).size.height / 100) * 38,
                          color: Colors.white,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            maxLength: 255,
                            controller: controller,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(8.0)),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          widget.fromMap
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "To edit your answer, re-scan the QR code.",
                        style: Theme.of(context).textTheme.body1.copyWith(
                              color: Color(0xFF777777),
                            ),
                      ),
                    ),
                    BackNavBottom(),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
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
                              child: Body1Text(
                                text: "Pass",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  widget.activity.userText =
                                      controller.text.toString();
                                  widget.activity.activated = true;
                                  Navigator.of(context).pop();
                                } else {
                                  Toast.show(
                                    "Please write down your answer!",
                                    context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.BOTTOM,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Colors.black,
                                  );
                                }
                              },
                              borderSide: BorderSide(color: Color(0xFF777777)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Body1Text(
                                text: "Save",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
