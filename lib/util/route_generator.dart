import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/util/transparent_page_route.dart';
import 'package:discover_deep_cove/views/activites/activity_screen_args.dart';
import 'package:discover_deep_cove/views/activites/count_activity_view.dart';
import 'package:discover_deep_cove/views/activites/photograph_activity_view.dart';
import 'package:discover_deep_cove/views/activites/picture_select_activity_view.dart';
import 'package:discover_deep_cove/views/activites/picture_tap_activity_view.dart';
import 'package:discover_deep_cove/views/activites/text_answer_activity_view.dart';
import 'package:discover_deep_cove/views/fact_file/fact_file_details.dart';
import 'package:discover_deep_cove/views/fact_file/fact_file_overlay.dart';
import 'package:discover_deep_cove/views/home.dart';
import 'package:discover_deep_cove/views/quiz/quiz_unlock.dart';
import 'package:discover_deep_cove/views/quiz/quiz_view.dart';
import 'package:discover_deep_cove/views/settings/about.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Home(),
        );

      case '/about':
        return MaterialPageRoute(builder: (_) => About());

      //Fact file routes
      case '/factFileDetails':
        if (args is FactFileEntry) {
          final FactFileEntry args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => FactFileDetails(
              entry: args,
            ),
          );
        }

        return _errorRoute();

      case '/factFileOverlay':
        if (args is FactFileEntry) {
          final FactFileEntry args = settings.arguments;
          return TransparentPageRoute(
            builder: (_) => FactFileOverlay(entry: args),
          );
        }
        return _errorRoute();

      //Quiz routes
      case '/quizUnlock':
        if (args is VoidCallback) {
          return MaterialPageRoute(
            builder: (_) => QuizUnlock(refreshCallback: args,),
          );
        }
        return _errorRoute();

      case '/quizQuestions':
        if (args is Quiz) {
          return MaterialPageRoute(
            builder: (_) => QuizView(
              quiz: args,
            ),
          );
        }

        return _errorRoute();

      //Activity routes
      case '/activity':
        ActivityScreenArgs aArgs = args as ActivityScreenArgs;
        if (aArgs != null) {
          if (aArgs.activity.activityType ==
              ActivityType.countActivity) {
            return MaterialPageRoute(
                builder: (_) => CountActivityView(
                    activity: aArgs.activity, isReview: aArgs.isReview));
          }
          if (aArgs.activity.activityType ==
              ActivityType.photographActivity) {
            return MaterialPageRoute(
                builder: (_) => PhotographActivityView(
                    activity: aArgs.activity, isReview: aArgs.isReview));
          }
          if (aArgs.activity.activityType ==
              ActivityType.pictureSelectActivity) {
            return MaterialPageRoute(
                builder: (_) => PictureSelectActivityView(
                    activity: aArgs.activity, isReview: aArgs.isReview));
          }
          if (aArgs.activity.activityType ==
              ActivityType.pictureTapActivity) {
            return MaterialPageRoute(
                builder: (_) => PictureTapActivityView(
                    activity: aArgs.activity, isReview: aArgs.isReview));
          }
          if (aArgs.activity.activityType ==
              ActivityType.textAnswerActivity) {
            return MaterialPageRoute(
                builder: (_) => TextAnswerActivityView(
                    activity: aArgs.activity, isReview: aArgs.isReview));
          }
        }
        return _errorRoute();

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
