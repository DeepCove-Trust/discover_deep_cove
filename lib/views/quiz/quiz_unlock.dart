import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

enum UnlockStatus { success, alreadyUnlocked, failure }

class QuizUnlock extends StatefulWidget {
  final VoidCallback refreshCallback;

  QuizUnlock({@required this.refreshCallback});

  @override
  _QuizUnlockState createState() => _QuizUnlockState();
}

///Allows the user to unlock a [quiz]
class _QuizUnlockState extends State<QuizUnlock> {
  TextEditingController textController = TextEditingController();
  List<Quiz> quizzes;

  //ScrollController scrollController = ScrollController();
  // KeyboardVisibilityNotification _keyboardVisibility =
  //     new KeyboardVisibilityNotification();
  // int _keyboardVisibilitySubscriberId;
  // bool _keyboardState;

  // @protected
  // void initState() {
  //   super.initState();

  //   _keyboardState = _keyboardVisibility.isKeyboardVisible;

  //   _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
  //     onChange: (bool visible) {
  //       print(visible);
  //       scrollView();
  //     },
  //   );
  // }

  // void scrollView() {
  //   var scrollPosition = scrollController.position;
  //   print("scrolled");

  //   scrollController.animateTo(
  //     scrollPosition.maxScrollExtent,
  //     duration: Duration(milliseconds: 200),
  //     curve: Curves.easeOut,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildContent(),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomBackButton(),
    );
  }

  void verifyCode(BuildContext context) async {
    UnlockStatus status;

    Quiz quiz = await QuizBean.of(context).findByCode(textController.text);

    if (quiz != null) {
      if (quiz.unlocked) {
        status = UnlockStatus.alreadyUnlocked;
      } else {
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

  buildContent() {
    return (Screen.width(context) >= 600 && !Screen.isPortrait(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              getTopHalf(),
              getBottomHalf(),
            ],
          )
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getTopHalf(),
                getBottomHalf(),
              ],
            ),
          );
  }

  getTopHalf() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: Screen.height(context,
                percentage: Screen.width(context) <= 350 ? 5 : Screen.width(context) >= 600 && Screen.isPortrait(context) ? 8 : 0),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Screen.height(context,
                        percentage: Screen.width(context) <= 350 ? 2 : 5),
                    horizontal: Screen.width(context) <= 350 ? 20 : 50),
                child: Screen.width(context) <= 600
                    ? Body(
                        "Your teacher will give you codes to unlock quizzes.",
                      )
                    : Heading(
                        "Your teacher will give you codes to unlock quizzes.",
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Screen.height(context, percentage: 5),
                    horizontal: Screen.width(context) <= 350 ? 20 : 50),
                child: Container(
                  width: Screen.width(context,
                      percentage: Screen.width(context) <= 350 ? 100 : 80),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Not a Student?",
                          style: TextStyle(
                            fontSize: Screen.width(context) <= 350
                                ? 16
                                : Screen.width(context) >= 650 ? 30 : 20,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context,
                            percentage: Screen.width(context) <= 350 ? 1.5 : 3),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 20),
                        child: Screen.width(context) <= 600
                            ? Body(
                                "Simply use the code posted in the communal kitchen of the lodge to "
                                "Unlock all quizzes immediately!",
                              )
                            : Heading(
                                "Simply use the code posted in the communal kitchen of the lodge to "
                                "Unlock all quizzes immediately!",
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
            ],
          ),
        ],
      ),
    );
  }

  getBottomHalf() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Screen.width(context) >= 600 ? 28.0 : 8.0,
              vertical: Screen.width(context,
                  percentage: Screen.width(context) <= 350 ? 2 : 5),
            ),
            child: Container(
              width: Screen.width(context,
                  percentage: Screen.width(context) <= 350 ? 100 : 80),
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: Screen.width(context, percentage: 5),
                      bottom: Screen.width(context, percentage: 5),
                    ),
                    child: Heading(
                      "Enter unlock code:",
                    ),
                  ),
                  Transform.scale(
                    scale: Screen.width(context) >= 600 ? 1.25 : 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: Screen.width(
                          context,
                          percentage: Screen.width(context) >= 600 ? 30 : 62.5,
                        ),
                        color: Colors.white,
                        child: TextField(
                          controller: textController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Enter code...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Screen.width(context, percentage: 5)),
                    child: OutlineButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Heading(
                          "Unlock",
                        ),
                      ),
                      onPressed: () => verifyCode(context),
                      borderSide: BorderSide(
                        color: HexColor("FFFFFFFF"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
