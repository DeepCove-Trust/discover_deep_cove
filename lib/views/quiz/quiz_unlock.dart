import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class QuizUnlock extends StatefulWidget {
  @override
  _QuizUnlockState createState() => _QuizUnlockState();
}

///Allows the user to unlock a [quiz]
class _QuizUnlockState extends State<QuizUnlock> {
  final controller = TextEditingController();

  List<Quiz> quizzes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: Screen.height(context, percentage: 13.0),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      child: BodyText(
                        "Your teacher will give you codes to unlock quizzes.",
                        align: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "Not a Student?",
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        decoration: TextDecoration.underline),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height:
                                  Screen.height(context, percentage: 1.5),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0, 8.0, 20),
                              child: BodyText(
                                "Simply use the code posted in the communal kitchen of the lodge to "
                                "Unlock all quizzes immediately!",
                                align: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        decoration: new BoxDecoration(
                          border: new Border.all(
                            color: Color(0xFF777777),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: Screen.width(context),
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Heading(
                                "Enter unlock code:",
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                width: Screen.width(context, percentage: 37.5),
                                color: Colors.white,
                                child: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                      hintText: 'Enter code...',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(8.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: OutlineButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Heading(
                                    "Unlock",
                                  ),
                                ),
                                onPressed: () {
                                  String status;

                                  for (Quiz quiz in quizzes) {
                                    if (!quiz.unlocked &&
                                        quiz.unlockCode == controller.text) {
                                      quiz.unlocked = true;
                                      status = "Success";

                                      break;
                                    } else if (quiz.unlocked &&
                                        quiz.unlockCode == controller.text) {
                                      status = "Unlocked";
                                      break;
                                    }
                                  }

                                  switch (status) {
                                    case "Success":
                                      Toast.show(
                                        "Quiz unlocked!",
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor: Colors.black,
                                      );
                                      Navigator.of(context).pop();
                                      break;
                                    case "Unlocked":
                                      Toast.show(
                                        "Quiz already unlocked!",
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor: Colors.black,
                                      );
                                      break;
                                    default:
                                      Toast.show(
                                        "Unrecognized code! please try again.",
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor: Colors.black,
                                      );
                                  }
                                },
                                borderSide:
                                    BorderSide(color: Color(0xFFFFFFFF)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
//          BackNavBottom(),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomBackButton(),
    );
  }
}
