import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/views/home.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:flutter/material.dart';

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
  FocusNode _textFieldFocus = new FocusNode();
  List<Quiz> quizzes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _textFieldFocus.unfocus(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            buildContent(),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        bottomNavigationBar: BottomBackButton(),
      ),
    );
  }

  void verifyCode(BuildContext context) async {
    UnlockStatus status;

    Config config = await ConfigBean.of(context).find(1);

    if(textController.text == config.masterUnlockCode){
      return await unlockAllQuizzes();
    }

    Quiz quiz = await QuizBean.of(context).findByCode(textController.text);

    if (quiz != null) {
      if (quiz.unlocked) {
        status = UnlockStatus.alreadyUnlocked;
      } else {
        quiz.setUnlocked(true);
        await QuizBean.of(context).update(quiz);
        // This will discard any stored quizzes so the the index page fetches fresh
        // data on next view.
        PageStorage.of(context).writeState(context, null, identifier: 'Quizzes');
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

  /// Unlock all quizzes
  Future<void> unlockAllQuizzes() async {
    List<Quiz> quizzes = await QuizBean.of(context).getAll();
    for(Quiz quiz in quizzes){
      quiz.setUnlocked(true);
      await QuizBean.of(context).update(quiz);
    }
    // This will discard any stored quizzes so the the index page fetches fresh
    // data on next view.
    PageStorage.of(context).writeState(context, null, identifier: 'Quizzes');
  }

  buildContent() {
    return (Screen.isTablet(context) && Screen.isLandscape(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              getBottomHalf(),
              getTopHalf(),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: Screen.height(context,
              percentage: Screen.isSmall(context)
                  ? 5
                  : Screen.isTablet(context) && Screen.isPortrait(context)
                      ? 8
                      : 5),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Screen.height(context,
                      percentage: Screen.isSmall(context) ? 2 : 5),
                  horizontal: Screen.isSmall(context) ? 20 : 50),
              child: Screen.width(context) <= 600
                  ? BodyText(
                      "Your teacher will give you codes to unlock quizzes.",
                    )
                  : Heading(
                      "Your teacher will give you codes to unlock quizzes."),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Screen.height(context, percentage: 5),
                  horizontal: Screen.isSmall(context) ? 20 : 50),
              child: Container(
                width: Screen.width(context,
                    percentage: Screen.isSmall(context) ? 100 : 80),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Not a Student?",
                        style: TextStyle(
                          fontSize: Screen.isSmall(context)
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
                          percentage: Screen.isSmall(context) ? 1.5 : 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 20),
                      child: Heading(
                        "Simply use the code posted in the communal kitchen of the lodge to "
                        "Unlock all quizzes immediately!",
                        size: Screen.width(context) >= 600
                            ? 30
                            : Screen.width(context) <= 350 ? 16 : 20,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF777777),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  getBottomHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.isTablet(context) ? 28.0 : 8.0,
            vertical: Screen.width(context,
                percentage: Screen.isSmall(context) ? 2 : 5),
          ),
          child: Container(
            width: Screen.width(context,
                percentage: Screen.width(context) < 600 ? 100 : 80),
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
                    size: Screen.width(context) >= 600
                        ? 30
                        : Screen.width(context) <= 350 ? 16 : 20,
                  ),
                ),
                Transform.scale(
                  scale: Screen.isTablet(context) ? 1.25 : 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: Screen.width(
                        context,
                        percentage: Screen.isTablet(context) ? 30 : 62.5,
                      ),
                      color: Colors.white,
                      child: TextField(
                        focusNode: _textFieldFocus,
                        controller: textController,
                        keyboardType: TextInputType.number,
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
                    vertical: Screen.width(context, percentage: 5),
                  ),
                  child: OutlineButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Heading(
                        "Unlock",
                        size: Screen.width(context) >= 600
                            ? 30
                            : Screen.width(context) <= 350 ? 16 : 20,
                      ),
                    ),
                    onPressed: () => verifyCode(context),
                    borderSide: BorderSide(
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
