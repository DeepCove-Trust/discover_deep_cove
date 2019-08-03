import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';

enum UnlockStatus { success, alreadyUnlocked, failure }

class QuizUnlock extends StatefulWidget {
  final VoidCallback refreshCallback;

  QuizUnlock({this.refreshCallback});

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
                  height: (MediaQuery.of(context).size.height / 100) * 13,
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      child: BodyText(
                        text:
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
                                  (MediaQuery.of(context).size.height / 100) *
                                      1.5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0, 8.0, 20),
                              child: BodyText(
                                text:
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
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Heading(
                                text: "Enter unlock code:",
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                width: (MediaQuery.of(context).size.width / 4) *
                                    2.5,
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
                                    text: "Unlock",
                                  ),
                                ),
                                onPressed: () => verifyCode(),
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

  void verifyCode() async {
    UnlockStatus status;

    Quiz quiz = await QuizBean.of(context)
        .findOneWhere((quiz) => quiz.unlockCode == controller.text);

    if(quiz != null){
      if(quiz.unlocked){
        status  = UnlockStatus.alreadyUnlocked;
      }
      else {
        quiz.unlocked = true;
        await QuizBean.of(context).update(quiz);
        status = UnlockStatus.success;
      }

      widget.refreshCallback();
      Navigator.of(context).pop();

    } else {
      status = UnlockStatus.failure;
    }

    switch (status) {
      case UnlockStatus.success:
        Util.showToast(context, 'Quiz unlocked');
        break;
      case UnlockStatus.alreadyUnlocked:
        Util.showToast(context, 'Quiz already unlocked');
        break;
      default:
        Util.showToast(context, 'Invalid code entered');
    }
  }
}
