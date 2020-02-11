import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
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

    if (textController.text == config.masterUnlockCode) {
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
        PageStorage.of(context)
            .writeState(context, null, identifier: 'Quizzes');
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
    for (Quiz quiz in quizzes) {
      quiz.setUnlocked(true);
      await QuizBean.of(context).update(quiz);
    }
    // This will discard any stored quizzes so the the index page fetches fresh
    // data on next view.
    PageStorage.of(context).writeState(context, null, identifier: 'Quizzes');
  }

  buildContent() {
    return Screen.isLandscape(context)
        ? Row(
            children: <Widget>[
              Expanded(child: getBottomHalf()),
              Expanded(
                child: Column(
                  children: <Widget>[Expanded(child: getTopHalf())],
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 2, child: getTopHalf()),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: getBottomHalf(),
                    )
                  ],
                ),
              ),
            ],
          );
  }

  getTopHalf() {
    return Padding(
      padding: EdgeInsets.all(Screen.isTablet(context) ? 40 : 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SubHeading(
            'Your teacher will give you codes to unlock quizzes.',
            size: Screen.isTablet(context) ? 40 : 20,
          ),
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            child: Column(
              children: <Widget>[
                Text(
                  'Not a student?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: Screen.isTablet(context) ? 30 : 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                BodyText(
                  'Use the code in the main hostel building to unlock all quizzes.',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getBottomHalf() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[Expanded(child: buildUnlockForm())],
      ),
    );
  }

  buildUnlockForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: Screen.width(context, percentage: 2.5),
            bottom: Screen.width(context, percentage: 2.5),
          ),
          child: Heading(
            "Enter unlock code:",
            size: Screen.width(context) >= 600
                ? 30
                : Screen.width(context) <= 350 ? 16 : 20,
          ),
        ),
        ClipRRect(
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
              style: TextStyle(
                  color: Colors.black,
                  fontSize: Screen.isTablet(context) ? 35 : 25),
              decoration: InputDecoration(
                hintText: 'Enter code...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8.0),
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
    );
  }
}
