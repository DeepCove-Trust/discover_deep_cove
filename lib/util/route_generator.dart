import 'package:flutter/material.dart';

import '../data/models/activity/activity.dart';
import '../data/models/notice.dart';
import '../views/activites/activity_screen_args.dart';
import '../views/activites/activity_unlock.dart';
import '../views/activites/count_activity_view.dart';
import '../views/activites/photograph_activity_view.dart';
import '../views/activites/picture_select_activity_view.dart';
import '../views/activites/picture_tap_activity_view.dart';
import '../views/activites/text_answer_activity_view.dart';
import '../views/fact_file/fact_file_details.dart';
import '../views/home.dart';
import '../views/loading_screen.dart';
import '../views/quiz/quiz_unlock.dart';
import '../views/quiz/quiz_view.dart';
import '../views/quiz/quiz_view_args.dart';
import '../views/settings/about.dart';
import '../views/settings/noticeboard/notice_view.dart';
import '../views/settings/noticeboard/noticeboard.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());

      case '/splash':
        return MaterialPageRoute(builder: (_) => LoadingScreen());

      case '/about':
        return MaterialPageRoute(builder: (_) => About());

      //Noticeboard routes
      case '/noticeboard':
        return MaterialPageRoute(builder: (_) => Noticeboard());

      case '/noticeView':
        if (args is Notice) {
          final Notice args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => NoticeView(
              notice: args,
            ),
          );
        }

        return _errorRoute();

      case '/update':
        return MaterialPageRoute(
          builder: (_) => LoadingScreen(
            isFirstLoad: args,
          ),
        );

      //Fact file routes
      case '/factFileDetails':
        if (args is int) {
          final int args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => FactFileDetails(
              entryId: args,
            ),
          );
        }

        return _errorRoute();

      //Quiz routes
      case '/quizUnlock':
        if (args is VoidCallback) {
          return MaterialPageRoute(
            builder: (_) => QuizUnlock(
              refreshCallback: args,
            ),
          );
        }
        return _errorRoute();

      case '/quizQuestions':
        if (args is QuizViewArgs) {
          return MaterialPageRoute(
            builder: (_) => QuizView(
              quiz: args.quiz,
              onComplete: args.onComplete,
            ),
          );
        }

        return _errorRoute();

      //Activity routes
      case '/activity':
        ActivityScreenArgs aArgs = args as ActivityScreenArgs;
        if (aArgs != null) {
          if (aArgs.activity.activityType == ActivityType.informational) {
            return MaterialPageRoute(builder: (_) {
              // Set info activity to unlocked
              aArgs.activity.informationActivityUnlocked = true;
              ActivityBean.of(_).update(aArgs.activity);
              return FactFileDetails(entryId: aArgs.activity.factFileId);
            });
          }
          if (aArgs.activity.activityType == ActivityType.countActivity) {
            return MaterialPageRoute(
              builder: (_) => CountActivityView(activity: aArgs.activity, isReview: aArgs.isReview),
            );
          }
          if (aArgs.activity.activityType == ActivityType.photographActivity) {
            return MaterialPageRoute(
              builder: (_) => PhotographActivityView(activity: aArgs.activity, isReview: aArgs.isReview),
            );
          }
          if (aArgs.activity.activityType == ActivityType.pictureSelectActivity) {
            return MaterialPageRoute(
              builder: (_) => PictureSelectActivityView(activity: aArgs.activity, isReview: aArgs.isReview),
            );
          }
          if (aArgs.activity.activityType == ActivityType.pictureTapActivity) {
            return MaterialPageRoute(
              builder: (_) => PictureTapActivityView(activity: aArgs.activity, isReview: aArgs.isReview),
            );
          }
          if (aArgs.activity.activityType == ActivityType.textAnswerActivity) {
            return MaterialPageRoute(
              builder: (_) => TextAnswerActivityView(activity: aArgs.activity, isReview: aArgs.isReview),
            );
          }
          if (aArgs.activity.activityType == ActivityType.informational) {
            return MaterialPageRoute(
              builder: (_) => FactFileDetails(entryId: aArgs.activity.factFileId),
            );
          }
        }
        return _errorRoute();

      case '/activityUnlock':
        return MaterialPageRoute(
          builder: (_) => ActivityUnlock(
            onCodeEntry: args,
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text(
            'ERROR',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    });
  }
}
